import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/src/user_repository.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;
  SignupBloc(this._userRepository) : super(SignupInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignupProcess());
      try {
        MyUser myUser =
            await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(myUser);
        emit(SignupSucess());
      } catch (e) {
        emit(SignupFailure());
      }
    });
  }
}
