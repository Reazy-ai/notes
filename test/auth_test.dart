import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();

      test('Should not be initialized to begin with', () {
        expect(provider._isInitialized, false);
      });

      test('Cannot logout if not initialized', () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });

      test(
        'Should be able to initialize',
        () async {
          await provider.initialize();
          expect(provider._isInitialized, true);
        },
      );

      test(
        'User should be null after initialization',
        () {
          expect(provider.currentUser, null);
        },
      );

      test(
        'Should be able to initialize after 2 seconds',
        () async {
          await provider.initialize();
          expect(provider._isInitialized, true);
        },timeout: const Timeout(Duration(seconds: 3)),
      );

      test(
        'Create user should delegate to login function',
        () async {
          final badEmail = provider.createUser(
            email: 'foo@bar.com',
            password: 'password',
          );
          expect(
            badEmail,
            throwsA(
              const TypeMatcher<UserNotFoundAuthException>(),
            ),
          );

          final badPassword = provider.createUser(
            email: 'Hello@hey.com',
            password: 'foobar',
          );
          expect(
            badPassword,
            throwsA(
              const TypeMatcher<WrongPasswordAuthException>(),
            ),
          );

          final user = await provider.createUser(
            email: 'hey',
            password: 'hi',
          );
          expect(provider.currentUser, user);
          expect(user.isEmailVerified, false);
        },
      );

      test(
        'Logged in user should be able to get verified',
        () {
          // Why not await on the sendEmailVerification since it returns a future?
          provider.sendEmailVerification();
          final user = provider.currentUser;
          expect(user, isNotNull);
          expect(user!.isEmailVerified, true);
        },
      );

      test(
        'Should be able to logout and login again',
        () {
           provider.logOut();
           provider.login(
            email: 'email',
            password: 'password',
          );
          final user = provider.currentUser;
          expect(user, isNotNull);
        },
      );
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') {
      throw UserNotFoundAuthException();
    }
    if (password == 'foobar') {
      throw WrongPasswordAuthException();
    }
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false, email: 'hello@hi.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true, email: 'hello@hi.com');
    _user = newUser;
  }
}
