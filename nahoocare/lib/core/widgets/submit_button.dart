import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const SubmitButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(text),
      ),
    );
  }
}
