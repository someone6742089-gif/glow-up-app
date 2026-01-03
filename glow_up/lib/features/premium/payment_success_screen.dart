import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _activatePremium();
  }

  Future<void> _activatePremium() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // In a real app, this is done via Webhook. 
        // For MVP demo, we update it client-side (RLS must allow this).
        await Supabase.instance.client
            .from('profiles')
            .update({'is_premium': true})
            .eq('id', user.id);
      }
    } catch (e) {
      debugPrint('Error activating premium: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.partyPopper, size: 80, color: Colors.purple),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to the Club!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You now have full access to all premium features.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.go('/home/index'),
                      child: const Text('Go Home'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
