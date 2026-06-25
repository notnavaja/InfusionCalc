// lib/screens/calculator/calculator_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:infusions/miscellaneous/services/infusion_service.dart';
import 'package:infusions/l10n/app_localizations.dart';

// 1. State logic moved to a ChangeNotifier for clean reactivity
class CalculatorNotifier extends ChangeNotifier {
  final TextEditingController doseController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController inputController = TextEditingController(); 

  String selectedDrugUnit = 'mg';
  String selectedOutputUnit = 'mg/hora';
  bool useWeight = false;
  bool isCalculatingDose = true; 
  String concentrationDisplay = '---';
  String resultNumber = '0';
  bool isResultPending = false;

  final List<String> drugUnits = ['g', 'mg', 'mcg', 'ng'];
  final List<String> outputUnits = [
    'g/min', 'g/kg/min', 'g/hora', 'g/kg/hora', 'g/día', 'g/kg/día',
    'mg/min', 'mg/kg/min', 'mg/hora', 'mg/kg/hora', 'mg/día', 'mg/kg/día',
    'mcg/min', 'mcg/kg/min', 'mcg/hora', 'mcg/kg/hora', 'mcg/día', 'mcg/kg/día',
    'ng/min', 'ng/kg/min', 'ng/hora', 'ng/kg/hora'
  ];

  CalculatorNotifier() {
    doseController.addListener(performCalculations);
    volumeController.addListener(performCalculations);
    weightController.addListener(performCalculations);
    inputController.addListener(performCalculations);
  }

  @override
  void dispose() {
    doseController.dispose();
    volumeController.dispose();
    weightController.dispose();
    inputController.dispose();
    super.dispose();
  }

  void updateDrugUnit(String unit) {
    selectedDrugUnit = unit;
    performCalculations();
  }

  void updateOutputUnit(String unit) {
    selectedOutputUnit = unit;
    performCalculations();
  }

  void toggleUseWeight(bool value) {
    useWeight = value;
    performCalculations();
  }

  void toggleMode(bool isDose) {
    isCalculatingDose = isDose;
    inputController.clear();
    resultNumber = '0';
    isResultPending = false;
    notifyListeners();
  }

  void performCalculations() {
    final double dose = double.tryParse(doseController.text) ?? 0.0;
    final double volume = double.tryParse(volumeController.text) ?? 0.0;
    final double weight = double.tryParse(weightController.text) ?? 0.0;
    final double inputValue = double.tryParse(inputController.text) ?? 0.0;

    if (dose == 0 || volume == 0) {
      concentrationDisplay = '---';
      resultNumber = '0';
      isResultPending = false;
      notifyListeners();
      return;
    }

    final double concentrationMcg = InfusionService.getConcentration(dose, selectedDrugUnit, volume);
    final double visualConcentration = dose / volume;
    final String cleanConcentration = visualConcentration
        .toStringAsFixed(7)
        .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

    concentrationDisplay = '$cleanConcentration $selectedDrugUnit/ml';

    if (inputValue == 0) {
      resultNumber = '0';
      isResultPending = false;
      notifyListeners();
      return;
    }

    if (isCalculatingDose) {
      final result = InfusionService.calculateDose(
        pumpRateMlHr: inputValue,
        concentrationMcgMl: concentrationMcg,
        weightKg: weight,
        useWeight: useWeight,
        outputFormat: selectedOutputUnit,
      );
      
      isResultPending = false;
      resultNumber = result.toStringAsFixed(4).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
    } else {
      final result = InfusionService.calculatePumpRate(
        desiredDose: inputValue,
        concentrationMcgMl: concentrationMcg,
        weightKg: weight,
        useWeight: useWeight,
        inputFormat: selectedOutputUnit,
      );

      isResultPending = false;
      resultNumber = result.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
    }
    
    // Broadcast changes to the UI layer
    notifyListeners();
  }
}

// 2. The main screen now simply listens to the CalculatorNotifier
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = CalculatorNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
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

    // ListenableBuilder auto-rebuilds when notifyListeners() is called
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
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
                child: _buildTextField(l10n.drugDose, _notifier.doseController, '0'),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildDropdown(l10n.unit, _notifier.selectedDrugUnit, _notifier.drugUnits, (val) {
                  _notifier.updateDrugUnit(val!);
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(l10n.totalVolumeMl, _notifier.volumeController, '100', suffix: 'ml'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${l10n.concentration} ${_notifier.concentrationDisplay}', 
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
                value: _notifier.useWeight,
                activeColor: primaryColor,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  _notifier.toggleUseWeight(value ?? false);
                },
              ),
            ),
          ),
          
          if (_notifier.useWeight) ...[
            const SizedBox(height: 8),
            _buildTextField(l10n.patientWeight, _notifier.weightController, '69', suffix: 'kg'),
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
              onTap: () => _notifier.toggleMode(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _notifier.isCalculatingDose 
                      ? primaryColor.withAlpha(30) 
                      : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  border: _notifier.isCalculatingDose 
                      ? Border.all(color: primaryColor.withAlpha(125)) 
                      : Border.all(color: Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    l10n.getDose,
                    style: TextStyle(
                      color: _notifier.isCalculatingDose 
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
              onTap: () => _notifier.toggleMode(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_notifier.isCalculatingDose 
                      ? primaryColor.withAlpha(30) 
                      : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                  border: !_notifier.isCalculatingDose 
                      ? Border.all(color: primaryColor.withAlpha(125)) 
                      : Border.all(color: Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    l10n.getRate,
                    style: TextStyle(
                      color: !_notifier.isCalculatingDose 
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
              _notifier.isCalculatingDose ? l10n.pumpRateInput : l10n.desiredDose,
              _notifier.inputController,
              '0',
              suffix: _notifier.isCalculatingDose ? 'ml/hr' : '',
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
              _notifier.selectedOutputUnit, 
              _notifier.outputUnits, 
              (val) {
                _notifier.updateOutputUnit(val!);
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

    final currentLabel = _notifier.isCalculatingDose ? l10n.infusedDose : l10n.pumpRateResult;
    final displayValue = _notifier.isResultPending ? l10n.pending : _notifier.resultNumber;

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
              fontSize: _notifier.isResultPending ? 32 : 42,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _notifier.isCalculatingDose ? _notifier.selectedOutputUnit : 'ml/hr',
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
          value: value, // Ensured the value maps dynamically from Notifier
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