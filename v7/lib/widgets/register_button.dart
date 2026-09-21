import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  const RegisterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Material(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: AppColors.brand.withValues(alpha: .26),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: const [
                SizedBox(width: 24, child: Icon(Icons.add, size: 24, color: AppColors.onBrand)),
                Expanded(
                  child: Center(
                    child: Text(
                      'REGISTRAR GLICEMIA',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .7,
                        color: AppColors.onBrand,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 24, child: Icon(Icons.chevron_right, size: 24, color: AppColors.onBrand)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
