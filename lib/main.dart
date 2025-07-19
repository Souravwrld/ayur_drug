import 'package:ayur_drug/features/auth/domain/auth_repo.dart';
import 'package:ayur_drug/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ayur_drug/features/home/app_data_bloc/app_data_bloc.dart';
import 'package:ayur_drug/features/home/navigation_bloc/navigation_bloc.dart';
import 'package:ayur_drug/features/home/screens/main_wrapper.dart';
import 'package:ayur_drug/features/search/domain/repo/drug_repo.dart';
import 'package:ayur_drug/features/search/presentation/bloc/search_bloc.dart';
import 'package:ayur_drug/features/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => AppDataBloc()..add(LoadAppData())),
        BlocProvider(
            create: (context) =>
                AuthBloc(AuthRepository())..add(CheckAuthStatus())),
        BlocProvider(
          create: (context) => SearchBloc(
            drugRepository: DrugRepository(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Mediayush Directory',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: const Color(0xFFFF6B35),
          fontFamily: GoogleFonts.inter().fontFamily,
          scaffoldBackgroundColor: const Color(0xFFf0f2f5),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return MainWrapper();
            } else {
              return SplashScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
