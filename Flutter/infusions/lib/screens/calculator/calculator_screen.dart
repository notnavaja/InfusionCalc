// lib/screens/calculator/calculator_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:infusions/miscellaneous/services/infusion_service.dart';
import 'package:infusions/l10n/app_localizations.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controllers
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _inputController = TextEditingController(); 

  // State Variables
  String _selectedDrugUnit = 'mg';
  String _selectedOutputUnit = 'mg/hora';
  bool _useWeight = false;
  bool _isCalculatingDose = true; 
  String _concentrationDisplay = '---';
  
  // Result Display Variables updated for localization
  String _resultNumber = '0';
  bool _isResultPending = false;

  final List<String> _drugUnits = ['g', 'mg', 'mcg', 'ng'];
  final List<String> _outputUnits = [
    'g/min', 'g/kg/min', 'g/hora', 'g/kg/hora', 'g/día', 'g/kg/día',
    'mg/min', 'mg/kg/min', 'mg/hora', 'mg/kg/hora', 'mg/día', 'mg/kg/día',
    'mcg/min', 'mcg/kg/min', 'mcg/hora', 'mcg/kg/hora', 'mcg/día', 'mcg/kg/día',
    'ng/min', 'ng/kg/min', 'ng/hora', 'ng/kg/hora'
  ];

  @override
  void initState() {
    super.initState();
    _doseController.addListener(_performCalculations);
    _volumeController.addListener(_performCalculations);
    _weightController.addListener(_performCalculations);
    _inputController.addListener(_performCalculations);
  }

  @override
  void dispose() {
    _doseController.dispose();
    _volumeController.dispose();
    _weightController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _performCalculations() {
    //final l10n = AppLocalizations.of(context)!;
    final double dose = double.tryParse(_doseController.text) ?? 0.0;
    final double volume = double.tryParse(_volumeController.text) ?? 0.0;
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double inputValue = double.tryParse(_inputController.text) ?? 0.0;

    if (dose == 0 || volume == 0) {
      setState(() {
        _concentrationDisplay = '---';
        _resultNumber = '0';
        _isResultPending = false;
      });
      return;
    }

    final double concentrationMcg = InfusionService.getConcentration(dose, _selectedDrugUnit, volume);
    final double visualConcentration = dose / volume;
    final String cleanConcentration = visualConcentration
        .toStringAsFixed(7)
        .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

    setState(() {
      _concentrationDisplay = '$cleanConcentration $_selectedDrugUnit/ml';
    });

    if (inputValue == 0) {
      setState(() {
        _resultNumber = '0';
        _isResultPending = false;
      });
      return;
    }

    // Realizar la operación correspondiente según la pestaña activa
    if (_isCalculatingDose) {
      final result = InfusionService.calculateDose(
        pumpRateMlHr: inputValue,
        concentrationMcgMl: concentrationMcg,
        weightKg: weight,
        useWeight: _useWeight,
        outputFormat: _selectedOutputUnit,
      );
      
      setState(() {
        _isResultPending = false;
        _resultNumber = result.toStringAsFixed(4).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
      });
    } else {
      // Calcular la velocidad necesaria en ml/hr
      final result = InfusionService.calculatePumpRate(
        desiredDose: inputValue,
        concentrationMcgMl: concentrationMcg,
        weightKg: weight,
        useWeight: _useWeight,
        inputFormat: _selectedOutputUnit,
      );

      setState(() {
        _isResultPending = false;
        // Las velocidades de bomba se suelen representar con 1 o 2 decimales
        _resultNumber = result.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
      });
    }
  }

  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withAlpha(20) 
                : Colors.white.withAlpha(140),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withAlpha(25) 
                  : Colors.white.withAlpha(100),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                spreadRadius: 0,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0, bottom: 24.0),
      child: Column(
        children: [
          _buildHeaderCard(l10n),
          const SizedBox(height: 16),
          _buildMixtureCard(l10n),
          const SizedBox(height: 16),
          _buildToggleButtons(l10n),
          const SizedBox(height: 16),
          _buildInputSection(l10n),
          const SizedBox(height: 16),
          _buildFinalResultCard(l10n), 
        ],
      ),
    );
  }

  Widget _buildHeaderCard(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withAlpha(200),
                primaryColor.withAlpha(140),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.infusionCalculatorTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.infusionCalculatorSubtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(80)),
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 36),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMixtureCard(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;

    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.science_outlined, color: Theme.of(context).iconTheme.color),
                  const SizedBox(width: 8),
                  Text(l10n.mixture, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildTextField(l10n.drugDose, _doseController, '0'),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildDropdown(l10n.unit, _selectedDrugUnit, _drugUnits, (val) {
                  setState(() {
                    _selectedDrugUnit = val!;
                    _performCalculations();
                  });
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(l10n.totalVolumeMl, _volumeController, '100', suffix: 'ml'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${l10n.concentration} $_concentrationDisplay', 
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 32),
          
          Material(
            color: Colors.transparent,
            child: Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Theme.of(context).colorScheme.onSurface.withAlpha(126),
              ),
              child: CheckboxListTile(
                title: Text(l10n.calculateDoseByWeight),
                value: _useWeight,
                activeColor: primaryColor,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _useWeight = value ?? false;
                    _performCalculations();
                  });
                },
              ),
            ),
          ),
          
          if (_useWeight) ...[
            const SizedBox(height: 8),
            _buildTextField(l10n.patientWeight, _weightController, '69', suffix: 'kg'),
          ]
        ],
      ),
    );
  }

  Widget _buildToggleButtons(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildGlassContainer(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCalculatingDose = true;
                  _inputController.clear();
                  _resultNumber = '0';
                  _isResultPending = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isCalculatingDose 
                      ? primaryColor.withAlpha(30) 
                      : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  border: _isCalculatingDose 
                      ? Border.all(color: primaryColor.withAlpha(125)) 
                      : Border.all(color: Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    l10n.getDose,
                    style: TextStyle(
                      color: _isCalculatingDose 
                          ? primaryColor 
                          : (isDark ? Colors.white54 : Colors.grey),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCalculatingDose = false;
                  _inputController.clear();
                  _resultNumber = '0';
                  _isResultPending = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_isCalculatingDose 
                      ? primaryColor.withAlpha(30) 
                      : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                  border: !_isCalculatingDose 
                      ? Border.all(color: primaryColor.withAlpha(125)) 
                      : Border.all(color: Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    l10n.getRate,
                    style: TextStyle(
                      color: !_isCalculatingDose 
                          ? primaryColor 
                          : (isDark ? Colors.white54 : Colors.grey),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildGlassContainer(
            padding: const EdgeInsets.all(12),
            child: _buildTextField(
              _isCalculatingDose ? l10n.pumpRateInput : l10n.desiredDose,
              _inputController,
              '0',
              suffix: _isCalculatingDose ? 'ml/hr' : '',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _buildGlassContainer(
            padding: const EdgeInsets.all(12),
            child: _buildDropdown(
              l10n.showIn, 
              _selectedOutputUnit, 
              _outputUnits, 
              (val) {
                setState(() {
                  _selectedOutputUnit = val!;
                  _performCalculations();
                });
              }
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalResultCard(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark 
        ? const Color(0xFF1E3A42) 
        : const Color(0xFFE5F9F6); 
    final textColor = isDark ? Colors.white : const Color(0xFF0D7A85); 

    final currentLabel = _isCalculatingDose ? l10n.infusedDose : l10n.pumpRateResult;
    final displayValue = _isResultPending ? l10n.pending : _resultNumber;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLabel,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayValue,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: _isResultPending ? 32 : 42,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isCalculatingDose ? _selectedOutputUnit : 'ml/hr',
            style: TextStyle(
              color: textColor.withAlpha(200),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {String? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}