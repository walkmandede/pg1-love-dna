import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/logger/app_logger.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class EngineTestPage extends StatefulWidget {
  const EngineTestPage({super.key});

  @override
  State<EngineTestPage> createState() => _EngineTestPageState();
}

class _EngineTestPageState extends State<EngineTestPage> {
  late SessionCubit _sessionCubit;
  final ValueNotifier<bool> _isLoaded = ValueNotifier(false);
  // List<LoveResult> loveResults = [];
  final ValueNotifier<List<CardAnswerModel>> _customCardAnswers = ValueNotifier([
    CardAnswerModel(cardId: 'card_01', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_02', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_03', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_04', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_05', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_06', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_07', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_08', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_09', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_10', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_11', behaviourId: 'A', interpretationId: '1'),
    CardAnswerModel(cardId: 'card_12', behaviourId: 'A', interpretationId: '1'),
  ]);

  final ValueNotifier<EngineResult?> _result = ValueNotifier(null);

  final ValueNotifier<String> _setAllBValue = ValueNotifier('A');
  final ValueNotifier<String> _setAllIValue = ValueNotifier('1');

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    _sessionCubit = context.read<SessionCubit>();
    await _sessionCubit.startSession();
    await Future.delayed(const Duration(milliseconds: 100));
    _isLoaded.value = true;
  }

  String _prettifyJson(dynamic jsonObject) {
    const encoder = JsonEncoder.withIndent('  ');
    final pretty = encoder.convert(jsonObject);
    return pretty;
  }

  Future<void> _computeResults() async {
    _result.value = null;
    final cardAnswers = [..._customCardAnswers.value];

    final result = await _sessionCubit.computeResult(cardAnswers);
    _result.value = result;
  }

  Future<void> _randomizeAnswers() async {
    for (final answer in _customCardAnswers.value) {
      final bIdIndex = Random().nextInt(4);
      final iIdIndex = Random().nextInt(4);

      final bAnswer = ['A', 'B', 'C', 'D'][bIdIndex];
      final iAnswer = ['1', '2', '3', '4'][iIdIndex];
      // answer.behaviourId = bAnswer;
      // answer.interpretationId = iAnswer;
      // newAnswers.add(answer);
      _bFieldOnChanged(answer, bAnswer);
      _iFieldOnChanged(answer, iAnswer);
    }
  }

  void _bFieldOnChanged(CardAnswerModel answer, String value) {
    if (!['A', 'B', 'C', 'D'].contains(value)) {
      return;
    }

    final tempList = [..._customCardAnswers.value];
    for (final tempAnswer in tempList) {
      if (tempAnswer.cardId == answer.cardId) {
        tempAnswer.behaviourId = value;
        break;
      }
    }

    _customCardAnswers.value = [...tempList];
  }

  void _iFieldOnChanged(CardAnswerModel answer, String value) {
    if (!['1', '2', '3', '4'].contains(value)) {
      return;
    }

    final tempList = [..._customCardAnswers.value];
    for (final tempAnswer in tempList) {
      if (tempAnswer.cardId == answer.cardId) {
        tempAnswer.interpretationId = value;
        break;
      }
    }

    _customCardAnswers.value = [...tempList];
  }

  void _setAllBehaviourValue(String id) {
    for (final answer in _customCardAnswers.value) {
      _bFieldOnChanged(answer, id);
    }
  }

  void _setAllInterpretationValue(String id) {
    for (final answer in _customCardAnswers.value) {
      _iFieldOnChanged(answer, id);
    }
  }

  Future<String> runRandomDistributionTest(int testCount) async {
    String result = '';
    final random = Random(); // Fixed seed = reproducible results
    // final random = Random(42); // Fixed seed = reproducible results
    final Map<String, int> typeCounter = {};

    const behaviourOptions = ['A', 'B', 'C', 'D'];
    const interpretationOptions = ['1', '2', '3', '4'];
    final cardIds = List.generate(12, (i) => 'card_${(i + 1).toString().padLeft(2, '0')}');

    String testCountText = 'Running $testCount random TWLVE assessments...\n';
    appPrintGreen(testCountText);
    result += '$testCountText\n';

    Map<String, int> bIdCount = {'A': 0, 'B': 0, 'C': 0, 'D': 0};
    Map<String, int> iIdCount = {'1': 0, '2': 0, '3': 0, '4': 0};

    for (int test = 1; test <= testCount; test++) {
      final answers = <CardAnswerModel>[];

      for (final cardId in cardIds) {
        final bId = behaviourOptions[random.nextInt(4)];
        final iId = interpretationOptions[random.nextInt(4)];
        answers.add(
          CardAnswerModel(
            cardId: cardId,
            behaviourId: bId,
            interpretationId: iId,
          ),
        );
        bIdCount[bId] = bIdCount[bId]! + 1;
        iIdCount[iId] = iIdCount[iId]! + 1;
      }

      try {
        final result = await _sessionCubit.computeResult(answers);
        final primaryType = result.loveCodeResult.typeAssignment.typeCode;

        typeCounter[primaryType] = (typeCounter[primaryType] ?? 0) + 1;
      } catch (e) {
        appPrintRed('Error on test $test: $e');
      }
    }

    result += 'Behaviours Options Counts: \n${bIdCount.entries.map((e) => '${e.key} * ${e.value}').join('\n')}\n';
    result += 'Interpretation Options Counts: \n${iIdCount.entries.map((e) => '${e.key} * ${e.value}').join('\n')}\n\n';

    // Sort by count descending
    final sortedTypes = typeCounter.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    appPrintGreen('=== PRIMARY TYPE DISTRIBUTION (100 random users) ===');
    for (final entry in sortedTypes) {
      final percentage = (entry.value / testCount * 100).toStringAsFixed(1);
      final typeResultText = '${entry.key.padRight(25)} : ${entry.value.toString().padLeft(3)} ($percentage%)';
      result += '$typeResultText\n';
      appPrintCyan(typeResultText);
    }

    final mostCommonTypeText =
        'Most common type: ${sortedTypes.first.key} '
        '(${sortedTypes.first.value} out of 100)';

    appPrintCyan(mostCommonTypeText);
    result += '\n$mostCommonTypeText\n';

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engine Test - 1.0.4')),
      body: ValueListenableBuilder(
        valueListenable: _isLoaded,
        builder: (context, loaded, child) {
          if (!loaded) return const Center(child: CupertinoActivityIndicator());

          return SizedBox.expand(
            child: ValueListenableBuilder(
              valueListenable: _customCardAnswers,
              builder: (context, answers, child) {
                return ListView(
                  padding: const EdgeInsets.all(16),

                  children: [
                    _actions(),
                    16.heightGap,
                    ...answers.map(_answerWidget),
                    16.heightGap,
                    Row(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () {
                            _randomizeAnswers();
                          },
                          child: Text('Randomize Answers'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _computeResults();
                          },
                          child: Text('Generate Result'),
                        ),
                      ],
                    ),
                    _distributionsTest(context),
                    16.heightGap,
                    _meta(),
                    ExpansionTile(
                      title: Text('Types'),
                      children: [
                        _typesWidget(),
                      ],
                    ),
                    16.heightGap,
                    ExpansionTile(
                      title: Text('Love Code Result'),
                      children: [
                        _loveCodeJsonWidget(),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _distributionsTest(BuildContext context) {
    return Wrap(
      children: [
        ...[10, 50, 100, 1000, 5000].map((c) {
          return TextButton(
            onPressed: () async {
              final result = await runRandomDistributionTest(c);
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SelectableText(result),
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            child: Text('Random Distribution (x$c)'),
          );
        }),
      ],
    );
  }

  Widget _meta() {
    return ValueListenableBuilder(
      valueListenable: _result,
      builder: (context, result, child) {
        return ExpansionTile(
          title: Text('Meta'),
          children: [
            TextField(
              readOnly: true,
              controller: TextEditingController(text: result?.eIVectors.join(',') ?? ''),
              decoration: InputDecoration(
                labelText: 'EI Vectors',
                border: InputBorder.none,
              ),
            ),
            8.heightGap,
            TextField(
              readOnly: true,
              controller: TextEditingController(text: result?.cIVectors.join(',') ?? ''),
              decoration: InputDecoration(
                labelText: 'CI Vectors',
                border: InputBorder.none,
              ),
            ),
            8.heightGap,
            TextField(
              readOnly: true,
              controller: TextEditingController(text: result?.userVectors.map((uv) => uv.toStringAsFixed(2)).join(',') ?? ''),
              decoration: InputDecoration(
                labelText: 'User Vectors (only show 2 decimal place, but work full decimal behind the scene)',
                border: InputBorder.none,
              ),
            ),
            8.heightGap,
            TextField(
              readOnly: true,
              controller: TextEditingController(text: result?.meaningTags.join(',') ?? ''),
              decoration: InputDecoration(
                labelText: 'Meaning Tags',
                border: InputBorder.none,
              ),
            ),
            16.heightGap,
          ],
        );
      },
    );
  }

  Widget _actions() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColor.primary.withAlpha(100),
      child: Row(
        spacing: 8,
        children: [
          Expanded(child: const Text('Set all')),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _setAllBValue,
              builder: (context, setAllBValue, child) {
                return DropdownButton<String>(
                  value: setAllBValue,
                  isExpanded: true,
                  items: ['A', 'B', 'C', 'D'].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    _setAllBValue.value = value;
                    _setAllBehaviourValue(value);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _setAllIValue,
              builder: (context, setAllIValue, child) {
                return DropdownButton<String>(
                  value: setAllIValue,
                  isExpanded: true,

                  items: ['1', '2', '3', '4'].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    _setAllIValue.value = value;
                    _setAllInterpretationValue(value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerWidget(CardAnswerModel answer) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Text(answer.cardId),
        ),
        Expanded(
          child: DropdownButton<String>(
            value: answer.behaviourId,
            isExpanded: true,
            items: ['A', 'B', 'C', 'D'].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _bFieldOnChanged(answer, value);
            },
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            value: answer.interpretationId,
            isExpanded: true,

            items: ['1', '2', '3', '4'].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _iFieldOnChanged(answer, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _loveCodeJsonWidget() {
    return ValueListenableBuilder(
      valueListenable: _result,
      builder: (context, result, child) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: SelectableText(_prettifyJson(result?.loveCodeResult.toJson() ?? {})),
            ),
          ),
        );
      },
    );
  }

  Widget _typesWidget() {
    return ValueListenableBuilder(
      valueListenable: _result,
      builder: (context, result, child) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  ...(result?.rankedTypes ?? []).map((type) {
                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        color: Colors.tealAccent.withAlpha(100),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rank: ${type.rank} / Distance: ${type.distance.toStringAsFixed(2)}'),
                              Text('Rank: ${type.typeCode}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
