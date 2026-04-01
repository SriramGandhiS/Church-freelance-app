import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>(
    (ref) => AuthController());

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController() : super(const AsyncData(null));

  Future<void> signIn(BuildContext context, String email, String password) async {
    state = const AsyncLoading();
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password.trim());

      // Try to get role from Firestore — but don't block on failure
      String role = 'user';
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .get()
            .timeout(const Duration(seconds: 5));
        role = doc.data()?['role'] as String? ?? 'user';
      } catch (_) {
        // If Firestore unreachable, determine role from email
        final e = email.trim().toLowerCase();
        if (e.contains('bishop') || e == 'admin@acidiocese.org') role = 'admin';
        else if (e.contains('selvin') || e.contains('david') || e.contains('pastor')) role = 'pastor';
      }

      state = const AsyncData(null);
      if (!context.mounted) return;
      switch (role) {
        case 'admin':  context.go('/admin/home');  break;
        case 'pastor': context.go('/pastor/home'); break;
        default:       context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_friendlyError(e.code)),
          backgroundColor: AppColors.error,
          action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
        ));
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: ${e.toString().substring(0, e.toString().length.clamp(0, 60))}'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  Future<void> register(BuildContext context, String name, String email, String password) async {
    state = const AsyncLoading();
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.trim(), password: password.trim());

      // Save to Firestore — don't block if it fails
      FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid, 'name': name.trim(), 'email': email.trim(),
        'role': 'user', 'photoUrl': '', 'createdAt': FieldValue.serverTimestamp(), 'isActive': true,
      }).catchError((_) {});

      state = const AsyncData(null);
      if (!context.mounted) return;
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_friendlyError(e.code)),
          backgroundColor: AppColors.error,
        ));
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed. Please try again.'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.go('/login');
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':    return 'No account found. Check your email or register first.';
      case 'wrong-password':    return 'Incorrect password. Please try again.';
      case 'invalid-credential': return 'Email or password is incorrect. Check and try again.';
      case 'invalid-email':     return 'Please enter a valid email address.';
      case 'email-already-in-use': return 'An account already exists with this email.';
      case 'weak-password':     return 'Password must be at least 6 characters.';
      case 'network-request-failed': return 'No internet connection. Check your network.';
      case 'too-many-requests': return 'Too many attempts. Please wait a moment and try again.';
      default: return 'Login failed ($code). Please try again.';
    }
  }
}
