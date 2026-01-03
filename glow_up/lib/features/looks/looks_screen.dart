import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/supabase_service.dart';

class LooksScreen extends StatefulWidget {
  const LooksScreen({super.key});

  @override
  State<LooksScreen> createState() => _LooksScreenState();
}

class _LooksScreenState extends State<LooksScreen> {
  File? _image;
  bool _isAnalyzing = false;
  List<String>? _results;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // Or gallery

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _results = null;
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    setState(() => _isAnalyzing = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));
    
    final tips = [
      'Skin: Use a daily moisturizer with SPF.',
      'Hair: Consider a fade cut to accentuate your jawline.',
      'Posture: Keep shoulders back to appear more confident.',
      'Grooming: Shape your eyebrows slightly for a cleaner look.'
    ];

    await SupabaseService().saveLooksTips(tips.join('|'));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _results = tips;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Looks Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image == null)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 64, color: Colors.white54),
                      SizedBox(height: 16),
                      Text('Tap to Upload Selfie'),
                    ],
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_image!, height: 300, fit: BoxFit.cover),
              ),

            const SizedBox(height: 32),

            if (_isAnalyzing)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Scanning facial structure...', style: Theme.of(context).textTheme.bodyLarge)
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(duration: 1500.ms),
                ],
              ),

            if (_results != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Analysis Results', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ..._results!.map((tip) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.amber),
                          const SizedBox(height: 12),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideX()),
                ],
              ),
              
            if (_results != null)
               Padding(
                 padding: const EdgeInsets.only(top: 24),
                 child: ElevatedButton(onPressed: _pickImage, child: const Text('Analyze Another Photo')),
               ),
          ],
        ),
      ),
    );
  }
}
