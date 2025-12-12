import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';
import 'package:pg1/features/engine_test/current/engine_test_page.dart';
import 'package:pg1/features/engine_test/custom/file_upload_page.dart';

class EngineTestSelectPage extends StatelessWidget {
  const EngineTestSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engine Test - 1.0.4'),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              AppButton(
                width: context.screenWidth * 0.75,
                label: 'Current TWLVE Engine',
                onPressed: () async {
                  SessionCubit sessionCubit = context.read<SessionCubit>();
                  await sessionCubit.startSession();
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EngineTestPage(
                          engine: sessionCubit.engine,
                        ),
                      ),
                    );
                  }
                },
              ),
              AppButton(
                width: context.screenWidth * 0.75,
                label: 'Manual configuration',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EngineTestCustomFileUploadPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
