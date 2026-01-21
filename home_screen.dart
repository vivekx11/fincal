import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/bento_card.dart';
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
          // Header
          _buildHeader(),
          const SizedBox(height: 24),
          
          // Quick Stats Banner
          _buildStatsBanner(),
          const SizedBox(height: 24),
          
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: AppTheme.headingSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryStart.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '7 Tools',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Bento Grid
          _buildBentoGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Hello, ', style: AppTheme.headingLarge),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryStart, AppTheme.primaryEnd],
              ).createShader(bounds),
              child: Text(
                'User!',
                style: AppTheme.headingLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'What would you like to calculate today?',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatsBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryStart.withValues(alpha: 0.2),
                AppTheme.primaryEnd.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(
              color: AppTheme.primaryStart.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.calculate_rounded, '7', 'Calculators'),
              Container(
                height: 40,
                width: 1,
                color: AppTheme.cardBorder,
              ),
              _buildStatItem(Icons.speed_rounded, 'Fast', 'Calculations'),
              Container(
                height: 40,
                width: 1,
                color: AppTheme.cardBorder,
              ),
              _buildStatItem(Icons.lock_rounded, '100%', 'Private'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryStart,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return Column(
      children: [
        // Row 1: Large EMI + Stacked Loan Compare
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large EMI Card (2x2)
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: BentoCard(
                  title: 'EMI Calculator',
                  subtitle: 'Calculate your monthly loan payments instantly',
                  icon: Icons.percent_rounded,
                  gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
                  size: BentoSize.large,
                  onTap: () => _navigateTo(context, const EMICalculatorScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Compare Loans Card
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: BentoCard(
                  title: 'Compare\nLoans',
                  subtitle: 'Side by side',
                  icon: Icons.compare_arrows_rounded,
                  gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
                  size: BentoSize.medium,
                  onTap: () => _navigateTo(context, const CompareLoansScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 2: GST + SIP + FD
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: BentoCard(
                  title: 'GST',
                  subtitle: 'Tax calculator',
                  icon: Icons.receipt_long_rounded,
                  gradientColors: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  size: BentoSize.small,
                  onTap: () => _navigateTo(context, const GSTCalculatorScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: BentoCard(
                  title: 'SIP',
                  subtitle: 'Investment',
                  icon: Icons.auto_graph_rounded,
                  gradientColors: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  size: BentoSize.small,
                  onTap: () => _navigateTo(context, const SIPCalculatorScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: BentoCard(
                  title: 'FD',
                  subtitle: 'Fixed deposit',
                  icon: Icons.savings_rounded,
                  gradientColors: const [Color(0xFFfa709a), Color(0xFFfee140)],
                  size: BentoSize.small,
                  onTap: () => _navigateTo(context, const FDCalculatorScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 3: RD (wide) + PPF
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1.8,
                child: BentoCard(
                  title: 'RD Calculator',
                  subtitle: 'Recurring deposit returns',
                  icon: Icons.account_balance_wallet_rounded,
                  gradientColors: const [Color(0xFFa8edea), Color(0xFFfed6e3)],
                  size: BentoSize.medium,
                  onTap: () => _navigateTo(context, const RDCalculatorScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.9,
                child: BentoCard(
                  title: 'PPF',
                  subtitle: 'Provident fund',
                  icon: Icons.assured_workload_rounded,
                  gradientColors: const [Color(0xFF764ba2), Color(0xFF667eea)],
                  size: BentoSize.small,
                  onTap: () => _navigateTo(context, const PPFCalculatorScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
