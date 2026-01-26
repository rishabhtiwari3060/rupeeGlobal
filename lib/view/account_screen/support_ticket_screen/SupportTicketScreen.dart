import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  String? selectedStatusValue, selectedPriorityValue;

  List<String> statusList = ['All Status', 'Pending', 'Closed'];
  List<String> priorityList = ['All Priority', 'Low', 'Urgent','High'];

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
          DI<StringConst>().support_ticket_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: dropDown('All Status', statusList,  (value) {
                    selectedStatusValue = value;
                    print('Selected value: $value');
                  },),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: dropDown('All Priority', priorityList,  (value) {
                    selectedPriorityValue = value;
                    print('Selected value: $value');
                  },),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }

  Widget dropDown(String hint,List<String> myList, ValueChanged<String?>? onChanged){
   return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().blackColor,
            13,
            FontWeight.w400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: DI<ColorConst>().darkGryColor,width: 0.9),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: DI<ColorConst>().darkGryColor,width: 0.9),
        ),
      ),
      value: selectedStatusValue,
      items: myList.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor,
                13,
                FontWeight.w400),
          ),
        );
      }).toList(),
      onChanged: onChanged
    );
  }
}
