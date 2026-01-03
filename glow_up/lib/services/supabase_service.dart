import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // Auth
  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // Profile
  Future<UserModel?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    // Merge auth email if needed, or just rely on profile
    return UserModel.fromJson({...response, 'email': user.email});
  }

  // Habits
  Stream<List<Map<String, dynamic>>> getHabits() {
    return client
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUser!.id);
  }

  Future<void> addHabit(String title) async {
    await client.from('habits').insert({
      'user_id': currentUser!.id,
      'title': title,
    });
  }

  Future<void> deleteHabit(int id) async {
    await client.from('habits').delete().eq('id', id);
  }

  // Habit Logs
  Future<void> logHabit(int habitId) async {
    await client.from('habit_logs').insert({
      'habit_id': habitId,
      'completed_at': DateTime.now().toIso8601String().split('T')[0],
    });
    // Trigger logic to update streak would be backend side or calculated client side
  }

  // Looksmaxxing
  Future<void> saveLooksTips(String tipsJson) async {
    await client.from('looks_tips').insert({
      'user_id': currentUser!.id,
      'tips_json': tipsJson, // JSON string or object
    });
  }
  
  // Charisma
  Future<void> completeCharismaChallenge(String challengeId) async {
    await client.from('charisma_progress').insert({
      'user_id': currentUser!.id,
      'challenge_id': challengeId,
    });
  }
}
