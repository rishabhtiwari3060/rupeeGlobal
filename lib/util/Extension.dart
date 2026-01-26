import 'Injection.dart';
import 'local_storage.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }


}



Map<String,dynamic> mainHeader(){
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken)}",// "Bearer 3|jZ1bM6CGgIa5kBpFjPk3MudGboP9xwoxGgItCaMGcc451485"
  };
}