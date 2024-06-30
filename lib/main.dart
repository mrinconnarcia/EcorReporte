import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/bloc/authentication_bloc.dart';
import 'data/repositories/user_repository_impl.dart';

void main() {
  runApp(EcoReporteApp());
}

class EcoReporteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: UserRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'EcoReporte',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: AppRoutes.routes,
      ),
    );
  }
}
