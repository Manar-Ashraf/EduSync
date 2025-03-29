import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,    
    this.isLoading = false,
    this.backgroundColor = const Color.fromARGB(255, 242, 243, 243),
    this.textColor = const Color.fromARGB(255, 5, 126, 128),
    this.borderColor = const Color.fromARGB(255, 5, 126, 128),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 5, 126, 128),
                ),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: onPressed == null 
                    ? textColor.withOpacity(0.5)
                    : textColor,
              ),
            ),
    );
  }
}