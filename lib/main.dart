import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rupeeglobal/controller/theme/ThemeController.dart';
import 'package:rupeeglobal/util/BindingClass.dart';
import 'package:rupeeglobal/util/Injection.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();

  setup();
  configLoading();
  runApp(const MyApp());
}


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return Sizer(builder: (context, orientation, screenType) {
        return GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            title: 'Rupee Global',
            debugShowCheckedModeBanner: false,

            /// Light Theme
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Color(0xffffffff),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              cardTheme: CardThemeData(
                color: Color(0xffffffff),
                elevation: 0.5,
              ),
              dividerTheme: DividerThemeData(
                color: Color(0xffe0e0e0),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color(0xffffffff),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Color(0xffffffff),
              ),
            ),

            /// Dark Theme
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Color(0xff121220),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                iconTheme: IconThemeData(color: Color(0xffe0e0e0)),
                titleTextStyle: TextStyle(color: Color(0xffe0e0e0), fontSize: 18, fontWeight: FontWeight.w500),
              ),
              cardTheme: CardThemeData(
                color: Color(0xff1c1c2e),
                elevation: 0.5,
              ),
              dividerTheme: DividerThemeData(
                color: Color(0xff3a3a4e),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color(0xff1c1c2e),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Color(0xff252538),
              ),
            ),

            /// Follows system setting (light/dark)
            themeMode: ThemeMode.dark,

            initialRoute: DI<RouteHelper>().getSplashscreen(),
            getPages: DI<RouteHelper>().routes,
            initialBinding: BindingClass(),
            builder: EasyLoading.init(),
          ),
        );
      }
    );
  }
}
