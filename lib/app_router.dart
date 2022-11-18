import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case VerifyEmailView.routeName:
        return MaterialPageRoute(
          builder: (context) => const VerifyEmailView(),
        );
      case LoginView.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      case RegisterView.routeName:
        return MaterialPageRoute(
          builder: (context) => const RegisterView(),
        );
        case NotesView.routeName:
        return MaterialPageRoute(
          builder: (context) => const NotesView(),
        );
      default:
        null;
    }
  }
}
