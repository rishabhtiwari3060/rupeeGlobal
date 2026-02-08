
import 'package:get_it/get_it.dart';
import 'package:rupeeglobal/network/WebService.dart';
import 'package:rupeeglobal/repo/auth_repo.dart';

import '../network/ApiService.dart';
import '../repo/account_repo.dart';
import '../repo/home_tab_repo.dart';
import 'ColorConst.dart';
import 'CommonFunction.dart';
import 'CommonWidget.dart';
import 'ImageConst.dart';
import 'RouteHelper.dart';
import 'StringConst.dart';
import 'local_storage.dart';


final DI = GetIt.instance;

void setup() {
  DI.registerLazySingleton<RouteHelper>(() => RouteHelper());
  DI.registerLazySingleton<ImageConst>(() => ImageConst());
  DI.registerLazySingleton<ColorConst>(() => ColorConst());
  DI.registerLazySingleton<StringConst>(() => StringConst());
  DI.registerLazySingleton<CommonFunction>(() => CommonFunction());
  DI.registerLazySingleton<CommonWidget>(() => CommonWidget());
  DI.registerLazySingleton<MyLocalStorage>(() => MyLocalStorage());
  DI.registerLazySingleton<ApiService>(() => ApiService());
  DI.registerLazySingleton<WebService>(() => WebService());



  DI.registerLazySingleton<AuthRepo>(() => AuthRepo());
  DI.registerLazySingleton<AccountRepo>(() => AccountRepo());
  DI.registerLazySingleton<HomeTabRepo>(() => HomeTabRepo());



}