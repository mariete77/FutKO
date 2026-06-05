import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import '../../../core/constants/gitea_constants.dart';
import '../../../core/errors/exceptions.dart';

/// Remote data source for Gitea OAuth2 / OIDC.
///
/// Supports:
///   • Authorization Code + PKCE   (Web & Mobile)
///   • Device Authorization Grant  (CLI)
class GiteaOAuthDataSource {
  final http.Client _httpClient;

  GiteaOAuthDataSource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  // ──────────────────────────────────────────────────────────
  //  Authorization Code + PKCE
  // ──────────────────────────────────────────────────────────

  /// Authenticate using the Authorization Code flow with PKCE.
  ///
  /// [context] determines which Client ID / redirect URI pair is used.
  Future<GiteaToken> signInWithAuthorizationCode(GiteaAppContext context) async {
    final config = GiteaConstants.getConfigFor(context);

    // Derive the custom URI scheme from the redirect URI.
    final customScheme = Uri.parse(config.redirectUri).scheme;

    final client = FutKOGiteaClient(
      redirectUri: config.redirectUri,
      customUriScheme: customScheme,
    );

    try {
      final AccessTokenResponse resp = await client.getTokenWithAuthCodeFlow(
        clientId: config.clientId,
        scopes: config.scopes,
      );

      if (resp.isExpired() || resp.accessToken == null) {
        throw const AuthException('Gitea authorization failed: invalid or expired token');
      }

      return GiteaToken.fromAccessTokenResponse(resp);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Gitea authorization error: \$e');
    }
  }

  /// Refresh an access token using the refresh token (if supported by Gitea).
  Future<GiteaToken> refreshToken(GiteaToken oldToken, GiteaAppContext context) async {
    if (oldToken.refreshToken == null || oldToken.refreshToken!.isEmpty) {
      throw const AuthException('No refresh token available');
    }

    final config = GiteaConstants.getConfigFor(context);
    final customScheme = Uri.parse(config.redirectUri).scheme;

    final client = FutKOGiteaClient(
      redirectUri: config.redirectUri,
      customUriScheme: customScheme,
    );

    try {
      final AccessTokenResponse resp = await client.refreshToken(
        oldToken.refreshToken!,
        clientId: config.clientId,
        scopes: config.scopes,
      );

      if (resp.accessToken == null) {
        throw const AuthException('Gitea token refresh failed');
      }

      return GiteaToken.fromAccessTokenResponse(resp);
    } catch (e) {
      throw AuthException('Gitea token refresh error: \$e');
    }
  }

  // ──────────────────────────────────────────────────────────
  //  Device Authorization Flow
  // ──────────────────────────────────────────────────────────

  /// Step 1 of Device Flow: request a device code from Gitea.
  ///
  /// Returns a map containing at minimum `device_code` and `user_code`,
  /// plus the `verification_uri` where the user must enter the code.
  Future<DeviceAuthorizationResponse> requestDeviceCode() async {
    final config = GiteaConstants.getConfigFor(GiteaAppContext.cli);

    final uri = Uri.parse(GiteaConstants.deviceAuthEndpoint);
    final response = await _httpClient.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': config.clientId,
        'scope': config.scopes.join(' '),
      },
    );

    if (response.statusCode != 200) {
      throw AuthException(
        'Device code request failed: \${response.statusCode} \${response.body}',
      );
    }

    final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
    return DeviceAuthorizationResponse.fromJson(jsonBody);
  }

  /// Step 2 of Device Flow: poll the token endpoint until the user
  /// completes authorization or we hit the timeout.
  ///
  /// Returns the [GiteaToken] once the user has authorized the device.
  Future<GiteaToken> pollForDeviceToken(
    DeviceAuthorizationResponse deviceAuth, {
    void Function(String userCode, String verificationUri)? onPromptUser,
  }) async {
    final config = GiteaConstants.getConfigFor(GiteaAppContext.cli);

    // Notify the caller so they can show the user_code / verification URI.
    onPromptUser?.call(deviceAuth.userCode, deviceAuth.verificationUri);

    final tokenUri = Uri.parse(GiteaConstants.tokenEndpoint);
    int attempts = 0;

    while (attempts < GiteaConstants.deviceFlowMaxPollAttempts) {
      await Future.delayed(Duration(seconds: deviceAuth.interval));

      final response = await _httpClient.post(
        tokenUri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          'device_code': deviceAuth.deviceCode,
          'client_id': config.clientId,
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
        final resp = AccessTokenResponse.fromMap(jsonBody);
        if (resp.accessToken != null) {
          return GiteaToken.fromAccessTokenResponse(resp);
        }
      }

      // Gitea may return 400/401 with an `error` field while pending.
      if (response.statusCode == 400 || response.statusCode == 401) {
        final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
        final error = jsonBody['error'] as String?;

        if (error == 'authorization_pending') {
          // User hasn't completed auth yet; keep polling.
          attempts++;
          continue;
        } else if (error == 'slow_down') {
          // Increase interval and keep polling.
          attempts++;
          continue;
        } else if (error == 'expired_token') {
          throw const AuthException('Device code expired. Please restart the CLI login.');
        } else if (error == 'access_denied') {
          throw const AuthException('User denied the authorization request.');
        } else {
          throw AuthException('Device flow error: \$error');
        }
      }

      attempts++;
    }

    throw const AuthException('Device authorization timed out.');
  }

  // ──────────────────────────────────────────────────────────
  //  User Info
  // ──────────────────────────────────────────────────────────

  /// Fetch the currently authenticated user's profile from Gitea.
  Future<GiteaUserProfile> fetchUserProfile(String accessToken) async {
    final uri = Uri.parse(GiteaConstants.userInfoEndpoint);
    final response = await _httpClient.get(
      uri,
      headers: {
        'Authorization': 'token \$accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw AuthException(
        'Failed to fetch Gitea user profile: \${response.statusCode}',
      );
    }

    final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
    return GiteaUserProfile.fromJson(jsonBody);
  }
}

// ═══════════════════════════════════════════════════════════
//  Data models
// ═══════════════════════════════════════════════════════════

/// Response from the Device Authorization endpoint.
class DeviceAuthorizationResponse {
  final String deviceCode;
  final String userCode;
  final String verificationUri;
  final int expiresIn;
  final int interval;

  const DeviceAuthorizationResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
  });

  factory DeviceAuthorizationResponse.fromJson(Map<String, dynamic> json) {
    return DeviceAuthorizationResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int? ?? 300,
      interval: json['interval'] as int? ?? 5,
    );
  }
}

/// Gitea user profile as returned by `GET /api/v1/user`.
class GiteaUserProfile {
  final int id;
  final String login;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String? language;

  const GiteaUserProfile({
    required this.id,
    required this.login,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.language,
  });

  factory GiteaUserProfile.fromJson(Map<String, dynamic> json) {
    return GiteaUserProfile(
      id: json['id'] as int,
      login: json['login'] as String,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      language: json['language'] as String?,
    );
  }
}
