import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pg1/core/models/twlve_models.dart';

// ============================================================================
// CSV Validation Results
// ============================================================================

class CsvValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final dynamic parsedData; // WeightCsvData or CentroidCsvData

  CsvValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    this.parsedData,
  });
}

// ============================================================================
// Parsed Data Classes
// ============================================================================

class WeightCsvData {
  final List<WeightEntry> entries;

  WeightCsvData(this.entries);
}

class CentroidCsvData {
  final List<TypeCentroid> centroids;

  CentroidCsvData(this.centroids);
}

// ============================================================================
// CSV Validators
// ============================================================================

class CentroidCsvValidator {
  static const List<String> expectedHeaders = ['Type', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9'];

  static const int expectedTypeCount = 12;

  static Future<CsvValidationResult> validate(PlatformFile file) async {
    final errors = <String>[];
    final warnings = <String>[];

    try {
      // Read file - handle both mobile/desktop (path) and web (bytes)
      String fileContent;
      if (file.bytes != null) {
        // Web platform
        fileContent = String.fromCharCodes(file.bytes!);
      } else if (file.path != null) {
        // Mobile/Desktop platform
        fileContent = await File(file.path!).readAsString();
      } else {
        errors.add('Unable to read file: no path or bytes available');
        return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
      }

      final rows = const CsvToListConverter().convert(fileContent);

      if (rows.isEmpty) {
        errors.add('CSV file is empty');
        return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
      }

      // Validate headers
      final headers = rows[0].map((e) => e.toString().trim()).toList();
      if (headers.length != expectedHeaders.length) {
        errors.add('Expected ${expectedHeaders.length} columns, found ${headers.length}');
      }

      for (var i = 0; i < expectedHeaders.length && i < headers.length; i++) {
        if (headers[i] != expectedHeaders[i]) {
          errors.add('Column $i: Expected "${expectedHeaders[i]}", found "${headers[i]}"');
        }
      }

      // Validate data rows
      final dataRows = rows.skip(1).toList();

      if (dataRows.length != expectedTypeCount) {
        warnings.add('Expected $expectedTypeCount type rows, found ${dataRows.length}');
      }

      final centroids = <TypeCentroid>[];
      final typesSeen = <String>{};

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        final rowNum = i + 2; // +2 because of 0-index and header row

        if (row.length != 10) {
          errors.add('Row $rowNum: Expected 10 columns, found ${row.length}');
          continue;
        }

        // Validate type name
        final typeName = row[0].toString().trim();
        if (typeName.isEmpty) {
          errors.add('Row $rowNum: Type name is empty');
          continue;
        }

        if (typesSeen.contains(typeName)) {
          errors.add('Row $rowNum: Duplicate type "$typeName"');
        }
        typesSeen.add(typeName);

        // Validate trait values (T1-T9)
        final vector = <double>[];
        for (var j = 1; j <= 9; j++) {
          try {
            final value = double.parse(row[j].toString().trim());

            // Check if value is in valid range (-3 to 3)
            if (value < -3 || value > 3) {
              warnings.add('Row $rowNum, T$j: Value $value outside typical range [-3, 3]');
            }

            vector.add(value);
          } catch (e) {
            errors.add('Row $rowNum, T$j: Invalid number "${row[j]}"');
          }
        }

        if (vector.length == 9) {
          centroids.add(TypeCentroid(typeCode: typeName, vector: vector));
        }
      }

      final isValid = errors.isEmpty;
      return CsvValidationResult(
        isValid: isValid,
        errors: errors,
        warnings: warnings,
        parsedData: isValid ? CentroidCsvData(centroids) : null,
      );
    } catch (e) {
      errors.add('Failed to read CSV file: $e');
      return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
    }
  }
}

class WeightCsvValidator {
  static const List<String> expectedHeaders = [
    'card_number',
    'element_type',
    'option_id',
    'description',
    'emotional_regulation',
    'stability_consistency',
    'sensitivity_attunement',
    'boundaries_autonomy',
    'vulnerability_openness',
    'avoidance_withdrawal',
    'pursuit_anxiety',
    'conflict_approach',
    'spontaneity_flexibility',
    'meaning_tag_1',
    'meaning_tag_2',
    'meaning_tag_3',
  ];

  static const int expectedCardCount = 12;
  static const List<String> validElementTypes = ['behaviour', 'interpretation'];

  static Future<CsvValidationResult> validate(PlatformFile file) async {
    final errors = <String>[];
    final warnings = <String>[];

    try {
      // Read file - handle both mobile/desktop (path) and web (bytes)
      String fileContent;
      if (file.bytes != null) {
        // Web platform
        fileContent = String.fromCharCodes(file.bytes!);
      } else if (file.path != null) {
        // Mobile/Desktop platform
        fileContent = await File(file.path!).readAsString();
      } else {
        errors.add('Unable to read file: no path or bytes available');
        return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
      }

      final rows = const CsvToListConverter().convert(fileContent);

      if (rows.isEmpty) {
        errors.add('CSV file is empty');
        return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
      }

      // Validate headers
      final headers = rows[0].map((e) => e.toString().trim()).toList();
      if (headers.length != expectedHeaders.length) {
        errors.add('Expected ${expectedHeaders.length} columns, found ${headers.length}');
      }

      for (var i = 0; i < expectedHeaders.length && i < headers.length; i++) {
        if (headers[i] != expectedHeaders[i]) {
          errors.add('Column $i: Expected "${expectedHeaders[i]}", found "${headers[i]}"');
        }
      }

      // Validate data rows
      final dataRows = rows.skip(1).toList();
      final entries = <WeightEntry>[];
      final cardStats = <int, Map<String, int>>{};

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        final rowNum = i + 2;

        if (row.length != expectedHeaders.length) {
          errors.add('Row $rowNum: Expected ${expectedHeaders.length} columns, found ${row.length}');
          continue;
        }

        // Parse card_number
        int? cardNumber;
        try {
          cardNumber = int.parse(row[0].toString().trim());
          if (cardNumber < 1 || cardNumber > expectedCardCount) {
            errors.add('Row $rowNum: card_number $cardNumber out of range [1-$expectedCardCount]');
          }
        } catch (e) {
          errors.add('Row $rowNum: Invalid card_number "${row[0]}"');
          continue;
        }

        // Parse element_type
        final elementType = row[1].toString().trim().toLowerCase();
        if (!validElementTypes.contains(elementType)) {
          errors.add('Row $rowNum: Invalid element_type "$elementType". Expected: ${validElementTypes.join(", ")}');
        }

        // Parse option_id
        final optionId = row[2].toString().trim();
        if (optionId.isEmpty) {
          errors.add('Row $rowNum: option_id is empty');
        }

        // Track card statistics
        cardStats.putIfAbsent(cardNumber!, () => {'behaviour': 0, 'interpretation': 0});
        cardStats[cardNumber]![elementType] = (cardStats[cardNumber]![elementType] ?? 0) + 1;

        // Parse trait deltas (columns 4-12)
        final deltas = <double>[];
        for (var j = 4; j <= 12; j++) {
          try {
            final value = double.parse(row[j].toString().trim());

            // Check if value is in typical range
            if (value < -4 || value > 4) {
              warnings.add('Row $rowNum, ${headers[j]}: Value $value outside typical range [-4, 4]');
            }

            deltas.add(value);
          } catch (e) {
            errors.add('Row $rowNum, ${headers[j]}: Invalid number "${row[j]}"');
          }
        }

        // Parse meaning tags (columns 13-15)
        final meaningTags = <String>[];
        for (var j = 13; j <= 15; j++) {
          final tag = row[j].toString().trim();
          if (tag.isNotEmpty) {
            meaningTags.add(tag);
          }
        }

        // Only behaviours should have empty meaning tags
        if (elementType == 'behaviour' && meaningTags.isNotEmpty) {
          warnings.add('Row $rowNum: behaviour rows typically have no meaning_tags');
        }

        if (deltas.length == 9) {
          entries.add(
            WeightEntry(
              cardNumber: cardNumber,
              elementType: elementType,
              optionId: optionId,
              deltas: deltas,
              meaningTags: meaningTags,
            ),
          );
        }
      }

      // Validate card completeness
      for (var card = 1; card <= expectedCardCount; card++) {
        final stats = cardStats[card];
        if (stats == null) {
          warnings.add('Card $card: No entries found');
          continue;
        }

        final behaviourCount = stats['behaviour'] ?? 0;
        final interpretationCount = stats['interpretation'] ?? 0;

        if (behaviourCount != 4) {
          warnings.add('Card $card: Expected 4 behaviour options, found $behaviourCount');
        }
        if (interpretationCount != 4) {
          warnings.add('Card $card: Expected 4 interpretation options, found $interpretationCount');
        }
      }

      final isValid = errors.isEmpty;
      return CsvValidationResult(
        isValid: isValid,
        errors: errors,
        warnings: warnings,
        parsedData: isValid ? WeightCsvData(entries) : null,
      );
    } catch (e) {
      errors.add('Failed to read CSV file: $e');
      return CsvValidationResult(isValid: false, errors: errors, warnings: warnings);
    }
  }
}

// ============================================================================
// Usage Example in your Page State
// ============================================================================

// Add these methods to your _EngineTestCustomFileUploadPageState:
