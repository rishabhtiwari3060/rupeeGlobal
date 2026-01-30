import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';
import 'CompoundResult.dart';
import 'CompoundResultScreen.dart';

class PmsScreen extends StatefulWidget {
  const PmsScreen({super.key});

  @override
  State<PmsScreen> createState() => _PmsScreenState();
}

class _PmsScreenState extends State<PmsScreen> {
  final startCtrl = TextEditingController(text: "1000");
  final monthlyCtrl = TextEditingController(text: "500");
  final rateCtrl = TextEditingController(text: "5");
  final durationCtrl = TextEditingController(text: "12");

  InterestApplyType selectedType = InterestApplyType.perMonth;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: DI<ColorConst>().blackColor,
            )),
        title: Text(
          DI<StringConst>().pms_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 7.w,
            ),
            SizedBox(
              width: 100.w,
              child: Card(
                color: DI<ColorConst>().whiteColor,
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DI<StringConst>().starting_balance_text,
                        style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
                      DI<CommonWidget>().myTextFormField(
                        controller: startCtrl,
                          textInputType: TextInputType.number,
                          ""),
                      SizedBox(
                        height: 10,
                      ),
                      Text(DI<StringConst>().monthly_contribution_text,
                        style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
                      DI<CommonWidget>().myTextFormField(
                          controller: monthlyCtrl,
                          textInputType: TextInputType.number,
                          ""),
                      SizedBox(
                        height: 10,
                      ),



                      SizedBox(
                        height: 10,
                      ),
                      StatefulBuilder(
                          builder: (context, setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DI<StringConst>().interest_rate_text,
                                      style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
                                    DI<CommonWidget>().myTextFormField(
                                        controller: rateCtrl,
                                        textInputType: TextInputType.number,
                                        ""),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<InterestApplyType>(
                                  value: selectedType,
                                  decoration: InputDecoration(
                                    labelText: "Apply Rate",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: InterestApplyType.perMonth,
                                      child: Text("Per month"),
                                    ),
                                    DropdownMenuItem(
                                      value: InterestApplyType.perYear,
                                      child: Text("Per year"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => selectedType = value!);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text(DI<StringConst>().duration_text,
                        style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
                      DI<CommonWidget>().myTextFormField(
                        controller: durationCtrl,
                          textInputType: TextInputType.number,
                          ""),


                      SizedBox(
                        height: 15.w,
                      ),

                      DI<CommonWidget>().myButton(DI<StringConst>().calculate_text,(){
                        final result = calculateCompound(
                          startingBalance: double.parse(startCtrl.text),
                          monthlyContribution: double.parse(monthlyCtrl.text),
                          interestRate: double.parse(rateCtrl.text),
                          months: int.parse(durationCtrl.text),
                          applyType: selectedType,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompoundResultScreen(result: result,
                              startInvest:double.parse(startCtrl.text) ,
                              durationCtrl:int.parse(durationCtrl.text) ,
                              interestRate: double.parse(rateCtrl.text),
                            ),
                          ),
                        );
                      }),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );




      Scaffold(
      appBar: AppBar(title: const Text("Compounding Interest")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field("Starting Balance", startCtrl),
            _field("Monthly Contribution", monthlyCtrl),
            Row(
              children: [
                Expanded(
                  child: _field("Interest Rate (%)", rateCtrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<InterestApplyType>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: "Apply Rate",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: InterestApplyType.perMonth,
                        child: Text("Per month"),
                      ),
                      DropdownMenuItem(
                        value: InterestApplyType.perYear,
                        child: Text("Per year"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedType = value!);
                    },
                  ),
                ),
              ],
            ),
            _field("Duration (months)", durationCtrl),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                final result = calculateCompound(
                  startingBalance: double.parse(startCtrl.text),
                  monthlyContribution: double.parse(monthlyCtrl.text),
                  interestRate: double.parse(rateCtrl.text),
                  months: int.parse(durationCtrl.text),
                  applyType: selectedType,
                );

              /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompoundResultScreen(result: result),
                  ),
                );*/
              },
              child: const Text("CALCULATE"),
            )
          ],
        ),
      ),
    );




  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}


