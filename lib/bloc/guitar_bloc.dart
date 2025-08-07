import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class GuitarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadGuitars extends GuitarEvent {}

// States
abstract class GuitarState extends Equatable {
  @override
  List<Object> get props => [];
}

class GuitarsLoading extends GuitarState {}

class GuitarsLoaded extends GuitarState {
  final List<String> guitars;

  GuitarsLoaded(this.guitars);

  @override
  List<Object> get props => [guitars];
}

// Bloc
class GuitarBloc extends Bloc<GuitarEvent, GuitarState> {
  GuitarBloc() : super(GuitarsLoading()) {
    on<LoadGuitars>((event, emit) async {
      // Simulate loading guitars
      await Future.delayed(Duration(seconds: 2));
      emit(GuitarsLoaded(["Guitarra 1", "Guitarra 2"]));
    });
  }
}
