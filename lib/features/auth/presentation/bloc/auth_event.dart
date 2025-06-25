part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpRequested extends AuthEvent {
  final String phoneNumber;

  const SendOtpRequested(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String otpCode;

  const VerifyOtpRequested(this.phoneNumber, this.otpCode);

  @override
  List<Object> get props => [phoneNumber, otpCode];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
