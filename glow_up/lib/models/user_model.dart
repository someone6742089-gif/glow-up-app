class UserModel {
  final String id;
  final String? email;
  final String? fullName;
  final DateTime trialStartDate;
  final bool isPremium;

  UserModel({
    required this.id,
    this.email,
    this.fullName,
    required this.trialStartDate,
    required this.isPremium,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'], // Depending on if we join auth.users
      fullName: json['full_name'],
      trialStartDate: DateTime.parse(json['trial_start_date']),
      isPremium: json['is_premium'] ?? false,
    );
  }

  bool get isTrialActive {
    final now = DateTime.now();
    final trialEnd = trialStartDate.add(const Duration(days: 5));
    return now.isBefore(trialEnd);
  }

  bool get hasAccess => isPremium || isTrialActive;
  
  int get trialDaysRemaining {
    final now = DateTime.now();
    final trialEnd = trialStartDate.add(const Duration(days: 5));
    if (now.isAfter(trialEnd)) return 0;
    return trialEnd.difference(now).inDays;
  }
}
