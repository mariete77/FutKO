import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/access_token_response.dart';

/// Gitea OAuth2 configuration for three application contexts:
/// 1. Web Frontend    – Authorization Code Flow + PKCE
/// 2. Mobile App      – Authorization Code Flow + PKCE
/// 3. CLI Access      – Device Authorization Flow
class GiteaConstants {
  GiteaConstants._();

  /// ── Gitea Instance ─────────────────────────────────────────
  static const String giteaBaseUrl = 'https://git.futko.app';
  static const String authorizeEndpoint = '$giteaBaseUrl/login/oauth/authorize';
  static const String tokenEndpoint = '$giteaBaseUrl/login/oauth/access_token';
  static const String deviceAuthEndpoint = '$giteaBaseUrl/login/oauth/device';

  /// ── Application 1: Web Frontend ────────────────────────────
  /// Flow: Authorization Code with PKCE (no client secret)
  /// Recommended scopes: openid profile email
  static const String webClientId = 'futko-web-frontend';
  static const String webRedirectUri = 'https://futko.app/auth/callback';
  static const List<String> webScopes = ['openid', 'profile', 'email'];

  /// ── Application 2: Mobile App ──────────────────────────────
  /// Flow: Authorization Code with PKCE (no client secret)
  /// Redirect URI uses custom URL scheme registered in AndroidManifest / Info.plist
  static const String mobileClientId = 'futko-mobile-app';
  static const String mobileRedirectUri = 'futko://auth/callback';
  static const List<String> mobileScopes = ['openid', 'profile', 'email'];

  /// ── Application 3: CLI Access ──────────────────────────────
  /// Flow: Device Authorization Grant (no client secret, no redirect URI)
  /// Polls for token after user completes authorization on another device
  static const String cliClientId = 'futko-cli-access';
  static const List<String> cliScopes = ['openid', 'profile', 'email'];

  /// Device-flow polling interval (seconds)
  static const int deviceFlowPollInterval = 5;

  /// Device-flow max polling attempts before timeout
  static const int deviceFlowMaxPollAttempts = 60;

  /// ─── OIDC / User Info ──────────────────────────────────────
  static String get userInfoEndpoint => '$giteaBaseUrl/api/v1/user';

  /// Returns the correct client configuration based on the current platform context.
  static GiteaClientConfig getConfigFor(GiteaAppContext context) {
    switch (context) {
      case GiteaAppContext.web:
        return GiteaClientConfig(
          clientId: webClientId,
          redirectUri: webRedirectUri,
          scopes: webScopes,
        );
      case GiteaAppContext.mobile:
        return GiteaClientConfig(
          clientId: mobileClientId,
          redirectUri: mobileRedirectUri,
          scopes: mobileScopes,
        );
      case GiteaAppContext.cli:
        return GiteaClientConfig(
          clientId: cliClientId,
          redirectUri: '', // Not used in device flow
          scopes: cliScopes,
        );
    }
  }
}

/// Enum to distinguish which OAuth2 application context is being used.
enum GiteaAppContext { web, mobile, cli }

/// Immutable configuration for a single Gitea OAuth2 client.
class GiteaClientConfig {
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  const GiteaClientConfig({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
  });
}

/// Custom OAuth2 client that points to the Gitea instance.
class FutKOGiteaClient extends OAuth2Client {
  FutKOGiteaClient({
    required String redirectUri,
    required String customUriScheme,
  }) : super(
          authorizeUrl: GiteaConstants.authorizeEndpoint,
          tokenUrl: GiteaConstants.tokenEndpoint,
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );
}

/// Wrapper around the raw token response from Gitea.
class GiteaToken {
  final String accessToken;
  final String? refreshToken;
  final String? tokenType;
  final DateTime? expiresAt;
  final List<String> scopes;

  const GiteaToken({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresAt,
    this.scopes = const [],
  });

  factory GiteaToken.fromAccessTokenResponse(AccessTokenResponse resp) {
    return GiteaToken(
      accessToken: resp.accessToken ?? '',
      refreshToken: resp.refreshToken,
      tokenType: resp.tokenType,
      expiresAt: resp.expiresIn != null
          ? DateTime.now().add(Duration(seconds: resp.expiresIn!))
          : null,
      scopes: resp.scope ?? [],
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
