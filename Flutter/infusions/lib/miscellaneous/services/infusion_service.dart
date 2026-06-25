// lib/miscellaneous/services/infusion_service.dart

class InfusionService {
  static double _convertToMicrograms(double amount, String unit) {
    switch (unit) {
      case 'g':
        return amount * 1000000;
      case 'mg':
        return amount * 1000;
      case 'mcg':
        return amount;
      case 'ng':
        return amount / 1000;
      default:
        return amount;
    }
  }

  static double getConcentration(double amount, String unit, double volume) {
    if (volume == 0) return 0.0;
    double amountInMcg = _convertToMicrograms(amount, unit);
    return amountInMcg / volume;
  }

  static double calculateDose({
    required double pumpRateMlHr,
    required double concentrationMcgMl,
    required double weightKg,
    required bool useWeight,
    required String outputFormat, 
  }) {
    double mcgPerHour = pumpRateMlHr * concentrationMcgMl;
    double timeAdjusted = mcgPerHour;
    if (outputFormat.contains('/min')) {
      timeAdjusted = mcgPerHour / 60;
    } else if (outputFormat.contains('/día')) {
      timeAdjusted = mcgPerHour * 24;
    }

    double weightAdjusted = timeAdjusted;
    if (useWeight && weightKg > 0 && outputFormat.contains('/kg')) {
      weightAdjusted = timeAdjusted / weightKg;
    }

    if (outputFormat.startsWith('g/')) {
      return weightAdjusted / 1000000;
    } else if (outputFormat.startsWith('mg/')) {
      return weightAdjusted / 1000;
    } else if (outputFormat.startsWith('ng/')) {
      return weightAdjusted * 1000;
    }
    return weightAdjusted;
  }

  // NUEVA FUNCIÓN: Calcular velocidad de la bomba (ml/hr) a partir de la dosis deseada
  static double calculatePumpRate({
    required double desiredDose,
    required double concentrationMcgMl,
    required double weightKg,
    required bool useWeight,
    required String inputFormat,
  }) {
    if (concentrationMcgMl == 0) return 0.0;

    // 1. Convertir la masa de la dosis ingresada a microgramos
    double doseInMcg = desiredDose;
    if (inputFormat.startsWith('g/')) {
      doseInMcg = desiredDose * 1000000;
    } else if (inputFormat.startsWith('mg/')) {
      doseInMcg = desiredDose * 1000;
    } else if (inputFormat.startsWith('ng/')) {
      doseInMcg = desiredDose / 1000;
    }

    // 2. Multiplicar por el peso del paciente si el formato lo requiere
    if (useWeight && weightKg > 0 && inputFormat.contains('/kg')) {
      doseInMcg = doseInMcg * weightKg;
    }

    // 3. Convertir el tiempo para obtener microgramos por hora (mcg/hr)
    double mcgPerHour = doseInMcg;
    if (inputFormat.contains('/min')) {
      mcgPerHour = doseInMcg * 60;
    } else if (inputFormat.contains('/día')) {
      mcgPerHour = doseInMcg / 24;
    }

    // 4. Dividir los microgramos por hora entre la concentración para obtener ml/hr
    return mcgPerHour / concentrationMcgMl;
  }
}