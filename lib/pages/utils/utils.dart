import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
