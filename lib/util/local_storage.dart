import 'package:get_storage/get_storage.dart';

class MyLocalStorage {
  final localStorage = GetStorage();

  //Keys
  String isLogin = "isLogin";
  String emailOrPhone = "emailOrPhone";
  String authToken = "authToken";
  String userId = "userId";
  String userName = "userName";
  String userProfile = "userProfile";
  String userPhone = "userPhone";
  String userBalance = "userBalance";
  String rememberMe = "rememberMe";
  String rememberEmail = "rememberEmail";
  String rememberPassword = "rememberPassword";


  //For Storing String value
  void setStringValue(String key, String value){
    localStorage.write(key, value);
  }

  String getStringValue(String key){
    return localStorage.read(key)??"";
  }

  //For Storing Bool value
  void setBoolValue(String key, bool value){
    localStorage.write(key, value);
  }

  bool getBoolValue(String key){
    return localStorage.read(key)?? false;
  }

  //For Storing Integer value
  void setNumValue(String key, String value){
    localStorage.write(key, value);
  }

  int getNumValue(String key){
    return localStorage.read(key);
  }


  //For Storing String value
  void setListValue(String key, List<dynamic> value){
    localStorage.write(key, value);
  }

  List<dynamic> getListValue(String key){
    return localStorage.read(key)?? [];
  }

  //For Clear the GetStorage (preserves remember-me credentials)
  void clearLocalStorage(){
    /// Save remember-me data before erasing
    final savedRememberMe = getBoolValue(rememberMe);
    final savedEmail = getStringValue(rememberEmail);
    final savedPassword = getStringValue(rememberPassword);

    localStorage.erase();

    /// Restore remember-me data after erase
    if (savedRememberMe) {
      setBoolValue(rememberMe, true);
      setStringValue(rememberEmail, savedEmail);
      setStringValue(rememberPassword, savedPassword);
    }

    print("clearLocalStorage");
  }
}