import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_data_event.dart';
part 'app_data_state.dart';

class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppDataBloc() : super(AppDataInitial()) {
    on<LoadAppData>((event, emit) async {
      emit(AppDataLoading());
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppDataLoaded(
        totalDrugs: 1256,
        classicalDrugs: 847,
        singleHerbs: 156,
      ));
    });
  }
}
