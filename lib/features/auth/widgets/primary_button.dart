import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const CircularProgressIndicator()
            : Text(title),
      ),
    );
  }
}