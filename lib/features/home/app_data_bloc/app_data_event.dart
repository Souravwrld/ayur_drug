part of 'app_data_bloc.dart';

sealed class AppDataEvent extends Equatable {
  const AppDataEvent();

  @override
  List<Object> get props => [];
}

class LoadAppData extends AppDataEvent {}
