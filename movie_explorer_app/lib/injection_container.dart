import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:movie_explorer_app/data/services/database_service.dart';
import 'package:movie_explorer_app/logic/bloc/movie_bloc.dart';
import 'data/services/api_service.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Networking
  sl.registerLazySingleton(() => Dio());
  
  // Services
  sl.registerLazySingleton(() => ApiService(sl()));
  sl.registerLazySingleton(() => DatabaseService());
  
  // Repositories & Blocs 

  sl.registerFactory(() => MovieBloc(sl()));
}