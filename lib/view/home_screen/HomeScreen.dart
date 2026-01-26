import 'package:flutter/material.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/Injection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();

    print("token :-- ${DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken)}");
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Home Screen",style: TextStyle(fontSize: 20.sp),),
    );
  }
}
