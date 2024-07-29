import 'package:ecoreporte/data/repositories/community_repository_impl.dart';
import 'package:ecoreporte/data/repositories/report_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/bloc/authentication_bloc.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/info_repository_impl.dart';

void main() {
  runApp(EcoReporteApp());
}

class EcoReporteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: UserRepositoryImpl()),
        ),
        Provider<InfoRepositoryImpl>(
          create: (context) => InfoRepositoryImpl(),
        ),
        Provider<CommunityRepositoryImpl>(
          create: (context) => CommunityRepositoryImpl(),
        ),
        Provider<ReportRepositoryImpl>(
          create: (_) => ReportRepositoryImpl(),
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
