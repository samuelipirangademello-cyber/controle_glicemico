import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.headerBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.water_drop_rounded,
            size: 46,
            color: AppColors.brand,
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTROLE GLICÊMICO',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                    color: AppColors.brandDeep,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Monitorar hoje para um amanhã melhor',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.settings_outlined,
            size: 25,
            color: AppColors.brandDeep,
          ),
        ],
      ),
    );
  }
}
