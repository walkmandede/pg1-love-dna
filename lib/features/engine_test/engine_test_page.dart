import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/models/twlve_models.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
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

  final Map<String, TextEditingController> _behaviourFields = {
    'card_01': TextEditingController(text: 'A'),
    'card_02': TextEditingController(text: 'A'),
    'card_03': TextEditingController(text: 'A'),
    'card_04': TextEditingController(text: 'A'),
    'card_05': TextEditingController(text: 'A'),
    'card_06': TextEditingController(text: 'A'),
    'card_07': TextEditingController(text: 'A'),
    'card_08': TextEditingController(text: 'A'),
    'card_09': TextEditingController(text: 'A'),
    'card_10': TextEditingController(text: 'A'),
    'card_11': TextEditingController(text: 'A'),
    'card_12': TextEditingController(text: 'A'),
  };

  final Map<String, TextEditingController> _interpretationFields = {
    'card_01': TextEditingController(text: '1'),
    'card_02': TextEditingController(text: '1'),
    'card_03': TextEditingController(text: '1'),
    'card_04': TextEditingController(text: '1'),
    'card_05': TextEditingController(text: '1'),
    'card_06': TextEditingController(text: '1'),
    'card_07': TextEditingController(text: '1'),
    'card_08': TextEditingController(text: '1'),
    'card_09': TextEditingController(text: '1'),
    'card_10': TextEditingController(text: '1'),
    'card_11': TextEditingController(text: '1'),
    'card_12': TextEditingController(text: '1'),
  };

  final ValueNotifier<EngineResult?> _result = ValueNotifier(null);

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
    print(_customCardAnswers.value.map((cca) => cca.toJson()).join('\n'));
    final cardAnswers = [..._customCardAnswers.value];

    final result = await _sessionCubit.computeResult(cardAnswers);
    _result.value = result;
    print(_prettifyJson(result.loveCodeResult.toJson()));
  }

  Future<void> _randomizeAnswers() async {
    for (final answer in _customCardAnswers.value) {
      final bIdIndex = Random().nextInt(4);
      final iIdIndex = Random().nextInt(4);

      final bAnswer = ['A', 'B', 'C', 'D'][bIdIndex];
      final iAnswer = ['1', '2', '3', '4'][iIdIndex];
      _behaviourFields[answer.cardId]?.text = bAnswer;
      _interpretationFields[answer.cardId]?.text = iAnswer;
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
                          child: Text('See Result'),
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

  Widget _answerWidget(CardAnswerModel answer) {
    final behaviourField = _behaviourFields[answer.cardId];
    final interpretationField = _interpretationFields[answer.cardId];
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Text(answer.cardId),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Behaviour'),
            controller: behaviourField,
            onChanged: (value) {
              _bFieldOnChanged(answer, value);
            },
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Interpretation'),
            controller: interpretationField,
            onChanged: (value) {
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
