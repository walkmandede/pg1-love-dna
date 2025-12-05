import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/routes/app_router.dart';
import 'package:pg1/core/shared/theme/app_theme.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const Pg1App());
}

class Pg1App extends StatelessWidget {
  const Pg1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: BlocProvider(
        create: (context) => SessionCubit(),
        child: MaterialApp.router(
          title: 'TWLVE',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
