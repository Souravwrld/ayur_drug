import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _phoneNumberKey = 'phone_number';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sampleOtp = '123456';

  Future<void> sendOtp(String phoneNumber) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Validate phone number format
    if (!_isValidPhoneNumber(phoneNumber)) {
      throw Exception('Please enter a valid 10-digit phone number');
    }
    
    // In real app, you would call your OTP service here
    print('OTP sent to $phoneNumber: $_sampleOtp');
  }

  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, accept only the sample OTP
    return otpCode == _sampleOtp;
  }

  Future<void> saveUserSession(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phoneNumber);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneNumberKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUserPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length == 10;
  }
}