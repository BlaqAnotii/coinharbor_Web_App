import 'package:coinharbor/main.dart';
import 'package:coinharbor/views/auth/create_account.dart';
import 'package:coinharbor/views/auth/email_verification.dart';
import 'package:coinharbor/views/auth/forgot_password.dart';
import 'package:coinharbor/views/auth/login.dart';
import 'package:coinharbor/views/welcome_screen.dart';
import 'package:coinharbor/widgets/MenuController.dart'
    as mcontroller;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouteConfig {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    routes: [
      /*GoRoute(
        path: '/',
        builder: (context, state) => SplashView(),
      ),*/
      GoRoute(
        path: '/',
        builder: (context, state) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => mcontroller.MenuController(),
            ),
          ],
          child: const MyHomePage(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, GoRouterState state) {
          return const MyHomePage();
        },
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, GoRouterState state) {
          return const CreateAccountScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/verification/:email',
        builder: (context, GoRouterState state) {
          final email = state.pathParameters['email'] ?? '';
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, GoRouterState state) {
          return const ForgotPasswordScreen();
        },
      ),

      //   GoRoute(
      //   path: '/point-of-sales/home',
      //   builder: (context, GoRouterState state) {
      //     return const HomeScreen2();
      //   },
      // ),
      // GoRoute(
      //   path: '/create-account',
      //   builder: (context, GoRouterState state) {
      //     return const CreateAccount();
      //   },
      // ),
      // GoRoute(
      //   path: '/login',
      //   builder: (context, GoRouterState state) {
      //     return const Login();
      //   },
      // ),
      // GoRoute(
      //   path: '/verification/:email',
      //   builder: (context, GoRouterState state) {
      //     final email = state.pathParameters['email'] ?? '';
      //     return VerificationView(
      //       email: email,
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/create-business',
      //   builder: (context, GoRouterState state) {
      //     return const CreateBusinessView();
      //   },
      // ),
      // GoRoute(
      //   path: '/join-business',
      //   builder: (context, GoRouterState state) {
      //     return const JoinBusinessView();
      //   },
      // )
    ],
  );
  GoRouter getRoutes() {
    return router;
  }
}

extension GoRouterExtension on GoRouter {
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}
