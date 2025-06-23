part of 'app_data_bloc.dart';

sealed class AppDataState extends Equatable {
  const AppDataState();

  @override
  List<Object> get props => [];
}

final class AppDataInitial extends AppDataState {}

class AppDataLoading extends AppDataState {}

class AppDataLoaded extends AppDataState {
  final int totalDrugs;
  final int classicalDrugs;
  final int singleHerbs;

  const AppDataLoaded({
    required this.totalDrugs,
    required this.classicalDrugs,
    required this.singleHerbs,
  });

  @override
  List<Object> get props => [totalDrugs, classicalDrugs, singleHerbs];
}
