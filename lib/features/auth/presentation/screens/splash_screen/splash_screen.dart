import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // Check if widget is still mounted
    if (!mounted) return;
    
    final userState = ref.read(currentUserProvider);
    
    userState.when(
      data: (user) {
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      },
      error: (e, st) {
        context.go('/login');
      },
      loading: () {
        // Wait, since we are inside loading, we might need to listen to changes instead.
        // Actually, riverpod's Future inside StateNotifier initialized first.
        // But let's just listen to the provider in build.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes
    ref.listen(currentUserProvider, (previous, next) {
      if (!next.isLoading) {
        if (next.hasValue && next.value != null) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 0.85,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}