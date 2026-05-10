import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../features/auth/presentation/screens/splash_screen/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen/role_selection_screen.dart';
import 'main_navigation_screen.dart';
import '../../features/shop/presentation/screens/product_details_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash', // ✅ FIXED ENTRY POINT

    routes: <RouteBase>[

      // SPLASH
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      // LOGIN
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),

      // REGISTER
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),

      // ROLE SELECTION
      GoRoute(
        path: '/role-selection',
        name: 'roleSelection',
        builder: (BuildContext context, GoRouterState state) {
          return const RoleSelectionScreen();
        },
      ),

      // HOME (MAIN APP)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const MainNavigationScreen();
        },
      ),

      // PRODUCT DETAILS
      GoRoute(
        path: '/product-details',
        name: 'productDetails',
        builder: (BuildContext context, GoRouterState state) {
          return const ProductDetailsScreen();
        },
      ),
    ],
  );
}