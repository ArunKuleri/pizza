part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

class SignupSucess extends SignupState {}

class SignupFailure extends SignupState {}

class SignupProcess extends SignupState {}
