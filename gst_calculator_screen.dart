import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/result_card.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_app_bar.dart';

class GSTCalculatorScreen extends StatefulWidget {
  const GSTCalculatorScreen({super.key});

  @override
  State<GSTCalculatorScreen> createState() => _GSTCalculatorScreenState();
}

class _GSTCalculatorScreenState extends State<GSTCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  double _selectedGSTRate = 18.0;
  bool _isAddGST = true; // true = Add GST, false = Remove GST
  double _gstAmount = 0;
  double _totalAmount = 0;
  double _originalAmount = 0;
  bool _showResult = false;

  final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  void _calculateGST() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() {
      if (_isAddGST) {
        // Add GST: Amount is original, calculate GST to add
        _originalAmount = amount;
        _gstAmount = amount * _selectedGSTRate / 100;
        _totalAmount = amount + _gstAmount;
      } else {
        // Remove GST: Amount includes GST, calculate original
        _totalAmount = amount;
        _originalAmount = amount * 100 / (100 + _selectedGSTRate);
        _gstAmount = _totalAmount - _originalAmount;
      }
      _showResult = true;
    });
  }

  void _reset() {
    _amountController.clear();
    setState(() {
      _gstAmount = 0;
      _totalAmount = 0;
      _originalAmount = 0;
      _showResult = false;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      appBar: const CalculatorAppBar(title: 'GST Calculator'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingM),
              // Mode Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModeButton('Add GST', _isAddGST, () {
                        setState(() => _isAddGST = true);
                      }),
                    ),
                    Expanded(
                      child: _buildModeButton('Remove GST', !_isAddGST, () {
                        setState(() => _isAddGST = false);
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
              CustomInputField(
                label: _isAddGST ? 'Original Amount (Excl. GST)' : 'Amount (Incl. GST)',
                hint: 'Enter amount',
                prefixIcon: Icons.currency_rupee,
                controller: _amountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text('Select GST Rate', style: AppTheme.bodyMedium),
              const SizedBox(height: AppConstants.paddingM),
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: AppConstants.gstRates.map((rate) {
                  final isSelected = _selectedGSTRate == rate;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGSTRate = rate),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppTheme.primaryGradient : null,
                        color: isSelected ? null : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : AppTheme.cardBorder,
                        ),
                      ),
                      child: Text(
                        '${rate.toInt()}%',
                        style: AppTheme.bodyLarge.copyWith(
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppConstants.paddingL),
              Row(
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: 'Calculate',
                      icon: Icons.calculate,
                      onPressed: _calculateGST,
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
                  title: 'GST Breakdown',
                  items: [
                    ResultItem(
                      label: 'Original Amount (Excl. GST)',
                      value: _currencyFormat.format(_originalAmount),
                    ),
                    ResultItem(
                      label: 'GST Amount (${_selectedGSTRate.toInt()}%)',
                      value: _currencyFormat.format(_gstAmount),
                      color: AppTheme.accentOrange,
                    ),
                    ResultItem(
                      label: 'Total Amount (Incl. GST)',
                      value: _currencyFormat.format(_totalAmount),
                      color: AppTheme.accentGreen,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                _buildGSTBreakdown(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGSTBreakdown() {
    final cgst = _gstAmount / 2;
    final sgst = _gstAmount / 2;

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
          Text('GST Components', style: AppTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGSTComponent('CGST', '${(_selectedGSTRate / 2).toStringAsFixed(1)}%', cgst),
              Container(width: 1, height: 50, color: AppTheme.cardBorder),
              _buildGSTComponent('SGST', '${(_selectedGSTRate / 2).toStringAsFixed(1)}%', sgst),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGSTComponent(String name, String rate, double amount) {
    return Column(
      children: [
        Text(name, style: AppTheme.bodySmall),
        Text(rate, style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryStart)),
        const SizedBox(height: 4),
        Text(_currencyFormat.format(amount), style: AppTheme.resultValue.copyWith(fontSize: 16)),
      ],
    );
  }
}
