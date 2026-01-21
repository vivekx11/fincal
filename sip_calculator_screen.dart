import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/result_card.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_app_bar.dart';

class SIPCalculatorScreen extends StatefulWidget {
  const SIPCalculatorScreen({super.key});

  @override
  State<SIPCalculatorScreen> createState() => _SIPCalculatorScreenState();
}

class _SIPCalculatorScreenState extends State<SIPCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyInvestmentController = TextEditingController();
  final _expectedReturnController = TextEditingController();
  final _timePeriodController = TextEditingController();

  double _investedAmount = 0;
  double _estimatedReturns = 0;
  double _totalValue = 0;
  bool _showResult = false;

  final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculateSIP() {
    if (!_formKey.currentState!.validate()) return;

    final monthlyInvestment = double.tryParse(_monthlyInvestmentController.text) ?? 0;
    final annualReturn = double.tryParse(_expectedReturnController.text) ?? 0;
    final years = int.tryParse(_timePeriodController.text) ?? 0;

    if (monthlyInvestment <= 0 || annualReturn <= 0 || years <= 0) return;

    final months = years * 12;
    final monthlyRate = annualReturn / 12 / 100;

    // SIP Formula: M × ({[1 + r]^n – 1} / r) × (1 + r)
    final totalValue = monthlyInvestment *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    setState(() {
      _investedAmount = monthlyInvestment * months;
      _totalValue = totalValue;
      _estimatedReturns = _totalValue - _investedAmount;
      _showResult = true;
    });
  }

  void _reset() {
    _monthlyInvestmentController.clear();
    _expectedReturnController.clear();
    _timePeriodController.clear();
    setState(() {
      _investedAmount = 0;
      _estimatedReturns = 0;
      _totalValue = 0;
      _showResult = false;
    });
  }

  @override
  void dispose() {
    _monthlyInvestmentController.dispose();
    _expectedReturnController.dispose();
    _timePeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      appBar: const CalculatorAppBar(title: 'SIP Calculator'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingM),
              CustomInputField(
                label: 'Monthly Investment',
                hint: 'Enter monthly SIP amount',
                prefixIcon: Icons.currency_rupee,
                controller: _monthlyInvestmentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly investment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingM),
              CustomInputField(
                label: 'Expected Return Rate',
                hint: 'Enter expected annual return',
                prefixIcon: Icons.trending_up,
                suffix: '% p.a.',
                controller: _expectedReturnController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expected return rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingM),
              CustomInputField(
                label: 'Time Period',
                hint: 'Enter investment duration',
                prefixIcon: Icons.calendar_today,
                suffix: 'Years',
                controller: _timePeriodController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time period';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingL),
              Row(
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: 'Calculate Returns',
                      icon: Icons.calculate,
                      onPressed: _calculateSIP,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  IconButton(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.cardBackground,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              if (_showResult) ...[
                const SizedBox(height: AppConstants.paddingL),
                ResultCard(
                  title: 'Investment Summary',
                  items: [
                    ResultItem(
                      label: 'Invested Amount',
                      value: _currencyFormat.format(_investedAmount),
                    ),
                    ResultItem(
                      label: 'Estimated Returns',
                      value: _currencyFormat.format(_estimatedReturns),
                      color: AppTheme.accentGreen,
                    ),
                    ResultItem(
                      label: 'Total Value',
                      value: _currencyFormat.format(_totalValue),
                      color: AppTheme.primaryStart,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                _buildBreakdownChart(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownChart() {
    final totalValue = _totalValue > 0 ? _totalValue : 1;
    final investedPercent = (_investedAmount / totalValue * 100).toStringAsFixed(1);
    final returnsPercent = (_estimatedReturns / totalValue * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Investment Breakdown', style: AppTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
            child: Row(
              children: [
                Expanded(
                  flex: (_investedAmount / totalValue * 100).round(),
                  child: Container(
                    height: 24,
                    color: AppTheme.primaryStart,
                  ),
                ),
                Expanded(
                  flex: (_estimatedReturns / totalValue * 100).round(),
                  child: Container(
                    height: 24,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend('Invested', investedPercent, AppTheme.primaryStart),
              _buildLegend('Returns', returnsPercent, AppTheme.accentGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppConstants.paddingS),
        Text('$label ($percent%)', style: AppTheme.bodySmall),
      ],
    );
  }
}
