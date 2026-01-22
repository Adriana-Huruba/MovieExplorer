import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_explorer_app/injection_container.dart' as di;
import 'package:movie_explorer_app/presentation/screens/home_screen.dart';
import 'package:movie_explorer_app/logic/bloc/movie_bloc.dart';
import 'package:movie_explorer_app/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieBloc>()..add(FetchTrendingMovies()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'Movie Explorer',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}