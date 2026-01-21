import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import 'emi_calculator_screen.dart';
import 'compare_loans_screen.dart';
import 'gst_calculator_screen.dart';
import 'sip_calculator_screen.dart';
import 'fd_calculator_screen.dart';
import 'rd_calculator_screen.dart';
import 'ppf_calculator_screen.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingM,
        AppConstants.paddingL,
        AppConstants.paddingM,
        120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All Calculators', style: AppTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            'Choose a calculator to get started',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Loans Section
          _buildSectionHeader('Loans & EMI', Icons.account_balance_rounded),
          const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'EMI Calculator',
            'Calculate monthly EMI for loans',
            Icons.percent_rounded,
            const [Color(0xFF667eea), Color(0xFF764ba2)],
            const EMICalculatorScreen(),
          ),
          _buildCalculatorTile(
            context,
            'Compare Loans',
            'Compare different loan offers side by side',
            Icons.compare_arrows_rounded,
            const [Color(0xFFf093fb), Color(0xFFf5576c)],
            const CompareLoansScreen(),
          ),
          
          const SizedBox(height: 24),
          
          // Investments Section
          _buildSectionHeader('Investments', Icons.trending_up_rounded),
          const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'SIP Calculator',
            'Plan your systematic investment portfolio',
            Icons.auto_graph_rounded,
            const [Color(0xFF43e97b), Color(0xFF38f9d7)],
            const SIPCalculatorScreen(),
          ),
          _buildCalculatorTile(
            context,
            'FD Calculator',
            'Calculate fixed deposit maturity amount',
            Icons.savings_rounded,
            const [Color(0xFFfa709a), Color(0xFFfee140)],
            const FDCalculatorScreen(),
          ),
          _buildCalculatorTile(
            context,
            'RD Calculator',
            'Calculate recurring deposit returns',
            Icons.account_balance_wallet_rounded,
            const [Color(0xFFa8edea), Color(0xFFfed6e3)],
            const RDCalculatorScreen(),
          ),
          _buildCalculatorTile(
            context,
            'PPF Calculator',
            'Plan your Public Provident Fund investments',
            Icons.assured_workload_rounded,
            const [Color(0xFF764ba2), Color(0xFF667eea)],
            const PPFCalculatorScreen(),
          ),
          
          const SizedBox(height: 24),
          
          // Tax Section
          _buildSectionHeader('Tax & GST', Icons.receipt_long_rounded),
          const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'GST Calculator',
            'Calculate GST inclusive/exclusive amounts',
            Icons.receipt_rounded,
            const [Color(0xFF4facfe), Color(0xFF00f2fe)],
            const GSTCalculatorScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryStart.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryStart,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    List<Color> gradientColors,
    Widget screen,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.textMuted,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
