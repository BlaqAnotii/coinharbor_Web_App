import 'package:coinharbor/main.dart';
import 'package:coinharbor/views/auth/create_account.dart';
import 'package:coinharbor/views/auth/email_verification.dart';
import 'package:coinharbor/views/auth/forgot_password.dart';
import 'package:coinharbor/views/auth/login.dart';
import 'package:coinharbor/views/auth/reset_password.dart';
import 'package:coinharbor/views/root/root.dart';
import 'package:coinharbor/widgets/MenuController.dart'
    as mcontroller;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouteConfig {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      _animatedRoute('/', const MyHomePage()),
      _animatedRoute('/home', const MyHomePage()),
      _animatedRoute('/login', const LoginScreen()),
      _animatedRoute(
          '/create-account', const CreateAccountScreen()),
      _animatedRoute(
          '/forgot-password', const ForgotPasswordScreen()),
      _animatedRoute(
          '/reset-password', const ResetPasswordScreen()),
      GoRoute(
        path: '/verification/:email',
        pageBuilder: (context, GoRouterState state) {
          final email = state.pathParameters['email'] ?? '';

          return CustomTransitionPage(
            key: state.pageKey,
            child: EmailVerificationScreen(
              email: email,
            ),
            transitionDuration:
                const Duration(milliseconds: 800),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
// Combined fade + scale + slide
              final fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              final offsetAnimation = Tween<Offset>(
                begin: const Offset(
                    0.0, 0.1), // slide from slightly below
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              final scaleAnimation = Tween<double>(
                begin: 0.97,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
      _animatedRoute('/homepage', const RootScreen()),
    ],
  );

  static GoRoute _animatedRoute(
    String path,
    Widget child,
  ) {
    return GoRoute(
        path: path,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: child,
            transitionDuration:
                const Duration(milliseconds: 800),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
// Combined fade + scale + slide
              final fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              final offsetAnimation = Tween<Offset>(
                begin: const Offset(
                    0.0, 0.1), // slide from slightly below
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              final scaleAnimation = Tween<double>(
                begin: 0.97,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                ),
              );
            },
          );
        });
  }

  GoRouter getRoutes() => router;
}

// class AppRouteConfig {
//   static final router = GoRouter(
//     navigatorKey: GlobalKey<NavigatorState>(),
//     debugLogDiagnostics: true,
//     routes: [
//       /*GoRoute(
//         path: '/',
//         builder: (context, state) => SplashView(),
//       ),*/
//       GoRoute(
//         path: '/',
//         builder: (context, state) => MultiProvider(
//           providers: [
//             ChangeNotifierProvider(
//               create: (context) => mcontroller.MenuController(),
//             ),
//           ],
//           child: const MyHomePage(),
//         ),
//       ),
//       GoRoute(
//         path: '/home',
//         builder: (context, GoRouterState state) {
//           return const MyHomePage();
//         },
//       ),
//       GoRoute(
//         path: '/create-account',
//         builder: (context, GoRouterState state) {
//           return const CreateAccountScreen();
//         },
//       ),
//       GoRoute(
//         path: '/login',
//         builder: (context, GoRouterState state) {
//           return const LoginScreen();
//         },
//       ),
//       GoRoute(
//         path: '/verification/:email',
//         builder: (context, GoRouterState state) {
//           final email = state.pathParameters['email'] ?? '';
//           return EmailVerificationScreen(email: email);
//         },
//       ),
//       GoRoute(
//         path: '/forgot-password',
//         builder: (context, GoRouterState state) {
//           return const ForgotPasswordScreen();
//         },
//       ),
//       GoRoute(
//         path: '/reset-password',
//         builder: (context, GoRouterState state) {
//           return const ResetPasswordScreen();
//         },
//       ),
//       GoRoute(
//         path: '/homepage',
//         builder: (context, GoRouterState state) {
//           return const RootScreen();
//         },
//         routes: [
//     GoRoute(
//       path: 'dashboard',
//       builder: (context, state) => const DashboardScreen(),
//     ),
//     GoRoute(
//       path: 'transactions',
//       builder: (context, state) => const TransactionsScreen(),
//     ),
//   ],
//       ),

//       //   GoRoute(
//       //   path: '/point-of-sales/home',
//       //   builder: (context, GoRouterState state) {
//       //     return const HomeScreen2();
//       //   },
//       // ),
//       // GoRoute(
//       //   path: '/create-account',
//       //   builder: (context, GoRouterState state) {
//       //     return const CreateAccount();
//       //   },
//       // ),
//       // GoRoute(
//       //   path: '/login',
//       //   builder: (context, GoRouterState state) {
//       //     return const Login();
//       //   },
//       // ),
//       // GoRoute(
//       //   path: '/verification/:email',
//       //   builder: (context, GoRouterState state) {
//       //     final email = state.pathParameters['email'] ?? '';
//       //     return VerificationView(
//       //       email: email,
//       //     );
//       //   },
//       // ),
//       // GoRoute(
//       //   path: '/create-business',
//       //   builder: (context, GoRouterState state) {
//       //     return const CreateBusinessView();
//       //   },
//       // ),
//       // GoRoute(
//       //   path: '/join-business',
//       //   builder: (context, GoRouterState state) {
//       //     return const JoinBusinessView();
//       //   },
//       // )
//     ],
//   );
//   GoRouter getRoutes() {
//     return router;
//   }
// }

// extension GoRouterExtension on GoRouter {
//   void clearStackAndNavigate(String location) {
//     while (canPop()) {
//       pop();
//     }
//     pushReplacement(location);
//   }
// }
