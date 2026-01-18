import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("WatchList Screen",style: TextStyle(fontSize: 20.sp),),
    );
  }
}
