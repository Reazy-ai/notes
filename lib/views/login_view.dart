import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/error_dialog.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = 'login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    _email;
    _password;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            obscureText: true,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    NotesView.routeName,
                    (_) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    VerifyEmailView.routeName,
                    (_) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong credentials',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication Error',
                );
              }
            },
            child: const Text('Login'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not registered yet?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RegisterView.routeName,
                    (route) => false,
                  );
                },
                child: const Text('Register here'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
