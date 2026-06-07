import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futko/core/errors/exceptions.dart';
import 'package:futko/core/errors/failures.dart';
import 'package:futko/domain/entities/user.dart';
import 'package:futko/domain/repositories/auth_repository.dart';
import 'package:futko/data/datasources/remote/auth_remote_datasource.dart';
import 'package:futko/data/datasources/remote/gitea_oauth_datasource.dart';
import 'package:futko/core/constants/gitea_constants.dart';

/// Authentication repository implementation
///
/// Supports both Firebase (Google, Apple, Email) and Gitea OAuth2 / OIDC.
class AuthRepositoryImpl implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final AuthRemoteDataSource? _authRemoteDataSource;
  final GiteaOAuthDataSource _giteaDataSource;

  // ── Combined auth state ───────────────────────────────────
  final StreamController<User?> _authStateController;
  User? _giteaUser;

  AuthRepositoryImpl({
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
    AuthRemoteDataSource? authRemoteDataSource,
    GiteaOAuthDataSource? giteaDataSource,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _authRemoteDataSource = authRemoteDataSource ??
            AuthRemoteDataSource(
              firebaseAuth: firebaseAuth,
              googleSignIn: googleSignIn,
            ),
        _giteaDataSource = giteaDataSource ?? GiteaOAuthDataSource(),
        _authStateController = StreamController<User?>.broadcast() {
    // Listen to Firebase auth state and forward through our combined controller.
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _authStateController.add(User.fromFirebaseUser(firebaseUser));
      } else if (_giteaUser == null) {
        _authStateController.add(null);
      }
    });
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  // ═══════════════════════════════════════════════════════════
  //  Firebase methods
  // ═══════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      if (_authRemoteDataSource == null) {
        return const Left(AuthFailure('AuthRemoteDataSource not initialized'));
      }
      final firebaseUser = await _authRemoteDataSource!.signInWithGoogle();

      // Create or update user in Firestore (await to ensure profile exists)
      await _createOrUpdateUser(firebaseUser);

      return Right(User.fromFirebaseUser(firebaseUser));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createOrUpdateUser(userCredential.user!);
      return Right(User.fromFirebaseUser(userCredential.user!));
    } on firebase.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(String email, String password, String displayName) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update display name
      await userCredential.user?.updateDisplayName(displayName);
      _createOrUpdateUser(userCredential.user!).catchError((_) {});
      return Right(User.fromFirebaseUser(userCredential.user!));
    } on firebase.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email';
      case 'weak-password':
        return 'La contraseña es demasiado débil (mínimo 6 caracteres)';
      case 'invalid-email':
        return 'Email no válido';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de autenticación: $code';
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    try {
      if (_authRemoteDataSource == null) {
        return const Left(AuthFailure('AuthRemoteDataSource not initialized'));
      }
      final firebaseUser = await _authRemoteDataSource!.signInWithApple();

      // Create or update user in Firestore (non-blocking)
      _createOrUpdateUser(firebaseUser).catchError((_) {});

      return Right(User.fromFirebaseUser(firebaseUser));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Gitea OAuth2 / OIDC
  // ═══════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, User>> signInWithGitea(GiteaAppContext context) async {
    try {
      final token = await _giteaDataSource.signInWithAuthorizationCode(context);
      final profile = await _giteaDataSource.fetchUserProfile(token.accessToken);

      final user = User.fromGiteaProfile(profile);
      _giteaUser = user;
      _authStateController.add(user);

      // Create or update user document in Firestore
      await _createOrUpdateGiteaUser(user);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Shared
  // ═══════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      _giteaUser = null;
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _authStateController.add(null);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) return User.fromFirebaseUser(firebaseUser);
    return _giteaUser;
  }

  // ── Firestore helpers ─────────────────────────────────────

  /// Create or update Firebase-authenticated user in Firestore
  Future<void> _createOrUpdateUser(firebase.User firebaseUser) async {
    final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // New user
      await userDoc.set({
        'displayName': firebaseUser.displayName ?? 'Player',
        'email': firebaseUser.email,
        'photoUrl': firebaseUser.photoURL,
        'elo': 1000,
        'stats': {
          'totalGames': 0,
          'wins': 0,
          'losses': 0,
          'draws': 0,
          'totalCorrectAnswers': 0,
          'currentWinStreak': 0,
          'bestWinStreak': 0,
        },
        'subscription': {
          'type': 'free',
          'isActive': false,
        },
        'dailyGames': {
          'casualPlayed': 0,
          'rankedPlayed': 0,
          'date': FieldValue.serverTimestamp(),
        },
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Existing user - update last login
      await userDoc.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Create or update Gitea-authenticated user in Firestore
  Future<void> _createOrUpdateGiteaUser(User user) async {
    final userDoc = _firestore.collection('users').doc(user.userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'elo': user.elo,
        'stats': {
          'totalGames': 0,
          'wins': 0,
          'losses': 0,
          'draws': 0,
          'totalCorrectAnswers': 0,
          'currentWinStreak': 0,
          'bestWinStreak': 0,
        },
        'subscription': {
          'type': 'free',
          'isActive': false,
        },
        'dailyGames': {
          'casualPlayed': 0,
          'rankedPlayed': 0,
          'date': FieldValue.serverTimestamp(),
        },
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'authProvider': 'gitea',
      });
    } else {
      await userDoc.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
      });
    }
  }
}
