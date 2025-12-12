import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pg1/core/models/twlve_models.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/features/engine_test/current/engine_test_page.dart';
import 'package:pg1/features/engine_test/custom/sample_image_preview.dart';
import 'package:pg1/features/engine_test/custom/validators.dart';

class EngineTestCustomFileUploadPage extends StatefulWidget {
  const EngineTestCustomFileUploadPage({super.key});

  @override
  State<EngineTestCustomFileUploadPage> createState() => _EngineTestCustomFileUploadPageState();
}

class _EngineTestCustomFileUploadPageState extends State<EngineTestCustomFileUploadPage> {
  final String _sampleCentroidImageUrl = 'assets/png/sample_centroid_image.png';
  final String _sampleCentroidCsvContent = '''Type,T1,T2,T3,T4,T5,T6,T7,T8,T9
Steady Anchor,3,3,1,1,1,-1,-1,1,-1
Quiet Protector,2,2,2,2,-1,1,-2,0,-1
Warm Connector,1,1,3,-1,3,-2,2,0,1
Thoughtful Analyst,2,1,2,1,0,1,-1,1,-2
Independent Spirit,1,0,1,3,-1,2,-2,0,2
Growth-Seeker,1,0,2,0,2,-1,1,1,2
Spark-Driven Adventurer,-1,-1,1,-1,1,-1,2,0,3
Reassurance Harmoniser,0,1,3,-1,2,-2,3,-2,0
Compassionate Healer,1,0,3,-2,3,-2,1,-1,0
Purpose-Led Planner,2,3,1,2,0,0,-1,2,-2
Boundary-Minded Realist,2,1,0,3,-1,1,-2,1,-1
Intuitive Romantic,-1,0,3,-1,3,-1,2,0,1''';

  final String _sampleWeightImageUrl = 'assets/png/sample_weight_image.png';
  final String _sampleWeightCsvContent = '''card_number,element_type,option_id,...''';

  final _filePicker = FilePicker.platform;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final ValueNotifier<PlatformFile?> _centroidFile = ValueNotifier(null);
  final ValueNotifier<PlatformFile?> _weightFile = ValueNotifier(null);

  final ValueNotifier<CentroidCsvData?> _centroidData = ValueNotifier(null);
  final ValueNotifier<WeightCsvData?> _weightData = ValueNotifier(null);

  Future<void> _uploadCentroidCsv() async {
    _isLoading.value = true;

    try {
      final result = await _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
        withReadStream: false,
      );
      if (result?.files.isNotEmpty ?? false) {
        _centroidFile.value = result!.files.first;
        await _validateCentroidCsv();
      }
    } catch (e) {
      _showValidationDialog(
        'Upload Error',
        'Failed to upload file: $e',
        isSuccess: false,
      );
    }

    _isLoading.value = false;
  }

  Future<void> _uploadWeightCsv() async {
    _isLoading.value = true;

    try {
      final result = await _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
        withReadStream: false,
      );
      if (result?.files.isNotEmpty ?? false) {
        _weightFile.value = result!.files.first;
        await _validateWeightCsv();
      }
    } catch (e) {
      _showValidationDialog(
        'Upload Error',
        'Failed to upload file: $e',
        isSuccess: false,
      );
    }

    _isLoading.value = false;
  }

  Future<void> _validateCentroidCsv() async {
    final file = _centroidFile.value;
    if (file == null) return;

    _isLoading.value = true;

    final result = await CentroidCsvValidator.validate(file);

    _isLoading.value = false;

    if (result.isValid) {
      final data = result.parsedData as CentroidCsvData;
      _centroidData.value = data;

      _showValidationDialog(
        'Validation Success',
        'Found ${data.centroids.length} valid type centroids\n\n'
            '${result.warnings.isNotEmpty ? "Warnings:\n${result.warnings.join("\n")}" : ""}',
        isSuccess: true,
      );
    } else {
      // Clear file and data on failure
      _centroidFile.value = null;
      _centroidData.value = null;

      _showValidationDialog(
        'Validation Failed',
        'Errors:\n${result.errors.join("\n")}\n\n'
            '${result.warnings.isNotEmpty ? "Warnings:\n${result.warnings.join("\n")}" : ""}',
        isSuccess: false,
      );
    }
  }

  Future<void> _validateWeightCsv() async {
    final file = _weightFile.value;
    if (file == null) return;

    _isLoading.value = true;

    final result = await WeightCsvValidator.validate(file);

    _isLoading.value = false;

    if (result.isValid) {
      final data = result.parsedData as WeightCsvData;
      _weightData.value = data;

      _showValidationDialog(
        'Validation Success',
        'Found ${data.entries.length} valid weight entries\n\n'
            '${result.warnings.isNotEmpty ? "Warnings:\n${result.warnings.join("\n")}" : ""}',
        isSuccess: true,
      );
    } else {
      // Clear file and data on failure
      _weightFile.value = null;
      _weightData.value = null;

      _showValidationDialog(
        'Validation Failed',
        'Errors:\n${result.errors.join("\n")}\n\n'
            '${result.warnings.isNotEmpty ? "Warnings:\n${result.warnings.join("\n")}" : ""}',
        isSuccess: false,
      );
    }
  }

  void _showValidationDialog(String title, String message, {required bool isSuccess, List<Widget> actions = const <Widget>[]}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          ...actions,
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _onTestEnginePressed() async {
    final centroidData = _centroidData.value;
    final weightData = _weightData.value;

    // Validate both files are uploaded
    if (centroidData == null || weightData == null) {
      _showValidationDialog(
        'Missing Data',
        'Please upload both centroid.csv and weight.csv files before testing the engine.',
        isSuccess: false,
      );
      return;
    }

    _isLoading.value = true;

    try {
      // Parse CSV data to dart models for TwlveScoringEngine

      // Convert CentroidCsvData to List<TypeCentroid> (already in correct format)
      final centroids = centroidData.centroids.map((c) {
        return TypeCentroid(
          typeCode: c.typeCode,
          vector: c.vector,
        );
      }).toList();

      // Convert WeightCsvData to List<WeightEntry> for engine
      final weights = weightData.entries.map((e) {
        return WeightEntry(
          cardNumber: e.cardNumber,
          elementType: e.elementType,
          optionId: e.optionId,
          deltas: e.deltas,
          meaningTags: e.meaningTags,
        );
      }).toList();

      // Initialize the engine
      final engine = TwlveScoringEngine();
      engine.initialize(
        weights: weights,
        centroids: centroids,
        narratives: {}, // Add your narratives here if needed
      );

      _isLoading.value = false;

      // Success - engine is initialized
      _showValidationDialog(
        'Engine Initialized',
        'TwlveScoringEngine successfully initialized with:\n'
            '• ${centroids.length} type centroids\n'
            '• ${weights.length} weight entries\n\n'
            'Ready to compute results!',
        isSuccess: true,
        actions: [
          TextButton(
            onPressed: () {
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EngineTestPage(
                      engine: engine,
                    ),
                  ),
                );
              }
            },
            child: Text('Go to Engine Test Page'),
          ),
        ],
      );

      // TODO: You can now use the engine to compute results
      // Example:
      // final result = engine.computeResult(answers);
    } catch (e) {
      _isLoading.value = false;
      _showValidationDialog(
        'Engine Error',
        'Failed to initialize engine: $e',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration Page'),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _centroidData,
        builder: (context, centroidData, child) {
          return ValueListenableBuilder(
            valueListenable: _weightData,
            builder: (context, weightData, child) {
              if (centroidData == null || weightData == null) {
                return const SizedBox.shrink();
              }
              return FloatingActionButton.extended(
                onPressed: _onTestEnginePressed,
                label: Text('Test Engine'),
              );
            },
          );
        },
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            _body(),
            _loading(),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return SizedBox.expand(
      child: Row(
        children: [
          // Centroid Panel
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    width: min(context.screenWidth * 0.5, 400),
                    label: 'Upload centroid.csv',
                    onPressed: _uploadCentroidCsv,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SampleImagePreview(
                              title: 'Sample Centroid Format',
                              url: _sampleCentroidImageUrl,
                              csvContent: _sampleCentroidCsvContent,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Check Sample Centroid Format'),
                  ),
                  const SizedBox(height: 16),
                  _buildCentroidPreview(),
                ],
              ),
            ),
          ),
          // Divider
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
            child: SizedBox(
              width: 1.5,
              height: double.infinity,
            ),
          ),
          // Weight Panel
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    width: min(context.screenWidth * 0.5, 400),
                    label: 'Upload weight.csv',
                    onPressed: _uploadWeightCsv,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SampleImagePreview(
                              title: 'Sample Weight Format',
                              url: _sampleWeightImageUrl,
                              csvContent: _sampleWeightCsvContent,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Check Sample Weight Format'),
                  ),
                  const SizedBox(height: 16),
                  _buildWeightPreview(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentroidPreview() {
    return ValueListenableBuilder(
      valueListenable: _centroidData,
      builder: (context, data, child) {
        if (data == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _centroidFile.value?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        _centroidFile.value = null;
                        _centroidData.value = null;
                      },
                      tooltip: 'Remove file',
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  '${data.centroids.length} Type Centroids',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...data.centroids.take(5).map((centroid) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            centroid.typeCode,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            centroid.vector.map((v) => v.toStringAsFixed(1)).join(', '),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (data.centroids.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '... and ${data.centroids.length - 5} more',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightPreview() {
    return ValueListenableBuilder(
      valueListenable: _weightData,
      builder: (context, data, child) {
        if (data == null) {
          return const SizedBox.shrink();
        }

        // Calculate statistics
        final cardGroups = <int, List<WeightEntry>>{};
        for (final entry in data.entries) {
          cardGroups.putIfAbsent(entry.cardNumber, () => []).add(entry);
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _weightFile.value?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        _weightFile.value = null;
                        _weightData.value = null;
                      },
                      tooltip: 'Remove file',
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  '${data.entries.length} Weight Entries',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${cardGroups.length} Cards Configured',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                ...cardGroups.entries.take(3).map((entry) {
                  final cardNum = entry.key;
                  final entries = entry.value;
                  final behaviours = entries.where((e) => e.elementType == 'behaviour').length;
                  final interpretations = entries.where((e) => e.elementType == 'interpretation').length;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          'Card $cardNum:',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$behaviours behaviours, $interpretations interpretations',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
                if (cardGroups.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '... and ${cardGroups.length - 3} more cards',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _loading() {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        if (!isLoading) {
          return const SizedBox.shrink();
        }
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
            child: const Center(
              child: Card(
                shape: CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
