import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

// Auth State
final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

// User Profile Provider
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (state) async {
      if (state.session == null) return null;
      return await SupabaseService().getUserProfile();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Computed: Has Access (Premium or Trial)
final hasAccessProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(userProfileProvider);
  return userAsync.when(
    data: (user) => user?.hasAccess ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});
