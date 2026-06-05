# Gitea OAuth2 / OIDC Setup Guide

This document explains how to configure the three Gitea OAuth2 applications required by FutKO and how the Flutter client uses them.

---

## 1. Overview

FutKO supports authentication through your Gitea instance (`git.futko.app`) using three distinct OAuth2/OIDC application contexts:

| Application | Flow | Context Enum | Client ID |
|-------------|------|--------------|-----------|
| **Web Frontend** | Authorization Code + PKCE | `GiteaAppContext.web` | `futko-web-frontend` |
| **Mobile App** | Authorization Code + PKCE | `GiteaAppContext.mobile` | `futko-mobile-app` |
| **CLI Access** | Device Authorization Grant | `GiteaAppContext.cli` | `futko-cli-access` |

All three applications **must not use a client secret** because the code runs in user-space (browser, mobile device, or distributed CLI binary) where secrets cannot be kept confidential.

---

## 2. Configuring Applications in Gitea

Log in to your Gitea instance as an administrator (or as the owning user) and navigate to:

**Settings → Applications → Manage OAuth2 Applications**

Create the following three applications:

---

### 2.1 Application: Web Frontend

| Field | Value |
|-------|-------|
| **Application Name** | `FutKO Web Frontend` |
| **Redirect URI** | `https://futko.app/auth/callback` |
| **Confidential Client** | ❌ **Unchecked** (Public client) |

**Scopes to request:** `openid`, `profile`, `email`

**Why PKCE?**
Since the web frontend is a SPA / Flutter web build that runs entirely in the browser, we use the Authorization Code flow with PKCE (Proof Key for Code Exchange). PKCE replaces the client secret with a dynamically generated code verifier, preventing authorization code interception attacks.

---

### 2.2 Application: Mobile App

| Field | Value |
|-------|-------|
| **Application Name** | `FutKO Mobile App` |
| **Redirect URI** | `futko://auth/callback` |
| **Confidential Client** | ❌ **Unchecked** (Public client) |

**Scopes to request:** `openid`, `profile`, `email`

**Platform Configuration**

You **must** register the custom URL scheme in both Android and iOS manifests so the OS can route the redirect back to the app:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity" android:exported="true">
  <intent-filter android:label="futko_auth">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="futko" android:host="auth" android:path="/callback" />
  </intent-filter>
</activity>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>app.futko.auth</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>futko</string>
    </array>
  </dict>
</array>
```

---

### 2.3 Application: CLI Access

| Field | Value |
|-------|-------|
| **Application Name** | `FutKO CLI Access` |
| **Redirect URI** | *(leave empty or set to `urn:ietf:wg:oauth:2.0:oob` if required)* |
| **Confidential Client** | ❌ **Unchecked** (Public client) |

**Scopes to request:** `openid`, `profile`, `email`

**Why Device Flow?**
CLI tools run in a terminal where there is no browser or redirect capability. The Device Authorization Grant lets the user open a browser on **any** device (phone, laptop) and enter a short user code to authorize the CLI session. No client secret or redirect URI is required.

> **Note:** Gitea must be version **1.21+** to support the Device Authorization Grant. If your instance is older, upgrade or use a personal access token fallback for CLI access.

---

## 3. Client-Side Architecture

### 3.1 Files Added / Modified

| File | Purpose |
|------|---------|
| `lib/core/constants/gitea_constants.dart` | Client IDs, endpoints, scopes, and the `FutKOGiteaClient` wrapper |
| `lib/data/datasources/remote/gitea_oauth_datasource.dart` | PKCE and Device Flow implementation |
| `lib/data/repositories/auth_repository_impl.dart` | Combines Firebase + Gitea auth into a single `authStateChanges` stream |
| `lib/domain/repositories/auth_repository.dart` | Added `signInWithGitea(GiteaAppContext)` |
| `lib/presentation/providers/auth_provider.dart` | Added `signInWithGitea` to `AuthNotifier` |
| `lib/presentation/screens/auth/login_screen.dart` | Added **GITEA** social login button |

### 3.2 Auth State Merging

`AuthRepositoryImpl` now maintains a **combined auth state**:

1. Firebase auth changes are listened to via `FirebaseAuth.instance.authStateChanges()`.
2. Gitea auth changes are tracked via an internal `_giteaUser` variable.
3. Both emit through a broadcast `StreamController<User?>` so the UI sees a single `User?` stream regardless of which provider was used.

When a user signs in with Gitea:
1. The PKCE flow opens the system browser.
2. Gitea redirects back to the app with an authorization code.
3. The code is exchanged for an access token.
4. The token is used to fetch the user profile from `GET /api/v1/user`.
5. A `User` entity is created with ID `gitea_<gitea_user_id>`.
6. The user document is created/updated in Firestore with an `authProvider: 'gitea'` field.

### 3.3 Firestore Security Rules (Important!)

Because Gitea-authenticated users are **not** Firebase Auth users, the existing Firestore rules that check `request.auth != null` will block Gitea users.

You have two options:

**Option A: Backend Token Exchange (Recommended)**
Create a Cloud Function or backend endpoint that:
1. Receives the Gitea access token.
2. Validates it against Gitea.
3. Creates a Firebase Custom Token.
4. The Flutter app calls `FirebaseAuth.instance.signInWithCustomToken()`.

This makes Gitea users proper Firebase Auth users and keeps your existing security rules intact.

**Option B: Token-based Firestore Rules**
Change your Firestore rules to accept a Gitea access token passed in a custom header and validate it via `request.auth == null` fallback logic. This is complex and not natively supported by Firebase.

> **Recommendation:** Implement Option A (Cloud Function) before releasing Gitea auth to production.

---

## 4. Changing the Gitea Instance URL

If your Gitea instance is not yet running at `https://git.futko.app`, update this single constant before building:

```dart
// lib/core/constants/gitea_constants.dart
static const String giteaBaseUrl = 'https://your-gitea-instance.com';
```

All endpoints (`authorizeEndpoint`, `tokenEndpoint`, `deviceAuthEndpoint`, `userInfoEndpoint`) are derived from this base URL.

---

## 5. Testing

### 5.1 Mobile PKCE Flow

```bash
flutter run
```
Tap **GITEA** on the login screen. You should be taken to Gitea's authorization page. After approving, the app should receive the token and navigate to the home screen.

### 5.2 Web PKCE Flow

```bash
flutter run -d chrome
```
The web build will use `GiteaAppContext.web` automatically if you adjust the call site in `login_screen.dart` (currently hardcoded to `mobile` for the button tap).

### 5.3 Device Flow (CLI / Dart script)

A standalone Dart script can use the data source directly:

```dart
import 'package:futko/data/datasources/remote/gitea_oauth_datasource.dart';

void main() async {
  final ds = GiteaOAuthDataSource();
  final deviceAuth = await ds.requestDeviceCode();
  print('Go to ${deviceAuth.verificationUri} and enter ${deviceAuth.userCode}');
  
  final token = await ds.pollForDeviceToken(deviceAuth);
  print('Access token: ${token.accessToken}');
  
  final profile = await ds.fetchUserProfile(token.accessToken);
  print('Welcome, ${profile.login}!');
}
```

---

## 6. Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `redirect_uri_mismatch` | Redirect URI in request doesn't match Gitea app config | Verify the exact URI (trailing slashes matter) |
| Browser doesn't return to app | Custom URL scheme not registered in `AndroidManifest.xml` / `Info.plist` | Follow platform configuration in §2.2 |
| `invalid_client` | Confidential client checkbox was left enabled | Edit the Gitea app and **uncheck** "Confidential Client" |
| Device flow returns `unsupported_grant_type` | Gitea version < 1.21 | Upgrade Gitea or use a different flow |
| Firestore permission denied after Gitea login | Gitea user is not a Firebase Auth user | Implement backend token exchange (§3.3) |

---

*Last updated: 2026-05-10*
