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

class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  bool _isYears = true;
  double _emi = 0;
  double _totalInterest = 0;
  double _totalPayment = 0;
  bool _showResult = false;

  final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculateEMI() {
    if (!_formKey.currentState!.validate()) return;

    final principal = double.tryParse(_loanAmountController.text) ?? 0;
    final annualRate = double.tryParse(_interestRateController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || tenure <= 0) return;

    final monthlyRate = annualRate / 12 / 100;
    final months = _isYears ? tenure * 12 : tenure;

    // EMI = P × r × (1 + r)^n / ((1 + r)^n – 1)
    final powValue = pow(1 + monthlyRate, months);
    final emi = principal * monthlyRate * powValue / (powValue - 1);

    setState(() {
      _emi = emi;
      _totalPayment = emi * months;
      _totalInterest = _totalPayment - principal;
      _showResult = true;
    });
  }

  void _reset() {
    _loanAmountController.clear();
    _interestRateController.clear();
    _tenureController.clear();
    setState(() {
      _emi = 0;
      _totalInterest = 0;
      _totalPayment = 0;
      _showResult = false;
    });
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      appBar: const CalculatorAppBar(title: 'EMI Calculator'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingM),
              CustomInputField(
                label: 'Loan Amount',
                hint: 'Enter loan amount',
                prefixIcon: Icons.currency_rupee,
                controller: _loanAmountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loan amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingM),
              CustomInputField(
                label: 'Interest Rate',
                hint: 'Enter annual interest rate',
                prefixIcon: Icons.percent,
                suffix: '%',
                controller: _interestRateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interest rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingM),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      label: 'Loan Tenure',
                      hint: 'Enter tenure',
                      prefixIcon: Icons.calendar_today,
                      controller: _tenureController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tenure';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      children: [
                        _buildToggleButton('Years', _isYears, () {
                          setState(() => _isYears = true);
                        }),
                        _buildToggleButton('Months', !_isYears, () {
                          setState(() => _isYears = false);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingL),
              Row(
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: 'Calculate EMI',
                      icon: Icons.calculate,
                      onPressed: _calculateEMI,
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
                  title: 'EMI Breakdown',
                  items: [
                    ResultItem(
                      label: 'Monthly EMI',
                      value: _currencyFormat.format(_emi),
                      color: AppTheme.primaryStart,
                    ),
                    ResultItem(
                      label: 'Principal Amount',
                      value: _currencyFormat.format(
                        double.tryParse(_loanAmountController.text) ?? 0,
                      ),
                    ),
                    ResultItem(
                      label: 'Total Interest',
                      value: _currencyFormat.format(_totalInterest),
                      color: AppTheme.accentOrange,
                    ),
                    ResultItem(
                      label: 'Total Payment',
                      value: _currencyFormat.format(_totalPayment),
                      color: AppTheme.accentGreen,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Text(
          text,
          style: AppTheme.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
