part of 'navigation_bloc.dart';

sealed class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

final class NavigationInitial extends NavigationState {}

class NavigationChanged extends NavigationState {
  final int currentIndex;

  const NavigationChanged(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}
