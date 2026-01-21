import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/gradient_background.dart';
import 'emi_calculator_screen.dart';
import 'compare_loans_screen.dart';
import 'gst_calculator_screen.dart';
import 'sip_calculator_screen.dart';
import 'fd_calculator_screen.dart';
import 'rd_calculator_screen.dart';
import 'ppf_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.paddingL),
            Text('Finance', style: AppTheme.headingLarge),
            Text('Calculator', style: AppTheme.headingLarge.copyWith(color: AppTheme.primaryStart)),
            const SizedBox(height: AppConstants.paddingS),
            Text('All your financial calculations in one place', style: AppTheme.bodyMedium),
            const SizedBox(height: AppConstants.paddingXL),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppConstants.paddingM,
              crossAxisSpacing: AppConstants.paddingM,
              childAspectRatio: 1.1,
              children: [
                _buildCalcCard(context, 'EMI\nCalculator', Icons.percent, const Color(0xFF667eea), const EMICalculatorScreen()),
                _buildCalcCard(context, 'Compare\nLoans', Icons.compare_arrows, const Color(0xFFf093fb), const CompareLoansScreen()),
                _buildCalcCard(context, 'GST\nCalculator', Icons.receipt_long, const Color(0xFF4facfe), const GSTCalculatorScreen()),
                _buildCalcCard(context, 'SIP\nCalculator', Icons.trending_up, const Color(0xFF43e97b), const SIPCalculatorScreen()),
                _buildCalcCard(context, 'FD\nCalculator', Icons.savings, const Color(0xFFfa709a), const FDCalculatorScreen()),
                _buildCalcCard(context, 'RD\nCalculator', Icons.account_balance_wallet, const Color(0xFFffecd2), const RDCalculatorScreen()),
                _buildCalcCard(context, 'PPF\nCalculator', Icons.account_balance, const Color(0xFF764ba2), const PPFCalculatorScreen()),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(title, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
