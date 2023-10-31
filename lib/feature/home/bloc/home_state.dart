part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super();
}

class HomeSuccessState extends HomeState {}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState(this.error);
}
