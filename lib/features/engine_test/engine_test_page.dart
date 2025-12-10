import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engine Test')),
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
                    16.heightGap,
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
              child: Text(_prettifyJson(result?.loveCodeResult.toJson() ?? {})),
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
                  ...(result?.types ?? []).map((type) {
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
