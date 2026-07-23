import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key, this.showTagline = true});

  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          image: true,
          label: context.l10n.brandLogoLabel,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/atis_logo.jpeg',
              width: showTagline ? 220 : 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            context.l10n.brandTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
