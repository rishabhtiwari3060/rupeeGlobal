import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Portifolio",style: TextStyle(fontSize: 20.sp),),
    );
  }
}
