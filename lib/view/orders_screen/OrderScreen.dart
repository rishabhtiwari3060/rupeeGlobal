import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Order Screen",style: TextStyle(fontSize: 20.sp),),
    );
  }
}
