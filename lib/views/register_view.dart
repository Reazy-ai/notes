import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialogs.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Registration failed');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your email and a strong password to register'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                enableSuggestions: false,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegister(email, password),
                            );
                      },
                      child: const Text('Register'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already registered?'),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: const Text('Login here'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
