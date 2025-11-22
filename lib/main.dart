import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/routes/app_router.dart';
import 'core/states/session/bloc/session_bloc.dart';
import 'core/states/session/bloc/session_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const Pg1App());
}

class Pg1App extends StatelessWidget {
  const Pg1App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc()..add(const SessionStarted()),
      child: MaterialApp.router(title: 'Pg1 Love DNA', debugShowCheckedModeBanner: false, theme: ThemeData(useMaterial3: true), routerConfig: AppRouter.router),
    );
  }
}
