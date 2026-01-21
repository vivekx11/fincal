import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class ResultCard extends StatelessWidget {
  final List<ResultItem> items;
  final String? title;

  const ResultCard({
    super.key,
    required this.items,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title!, style: AppTheme.headingSmall),
                const SizedBox(height: AppConstants.paddingM),
              ],
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.paddingM),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label, style: AppTheme.resultLabel),
                        Text(
                          item.value,
                          style: AppTheme.resultValue.copyWith(
                            color: item.color ?? AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultItem {
  final String label;
  final String value;
  final Color? color;

  const ResultItem({
    required this.label,
    required this.value,
    this.color,
  });
}
