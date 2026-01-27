import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  AccountController accountController =Get.find();

  String? selectedStatusValue, selectedPriorityValue,createPriorityValue = "";

  List<String> statusList = ['All Status', 'Pending', 'Closed'];
  List<String> priorityList = ['All Priority', 'Low', 'Urgent','High'];
  List<String> createPriorityList = ['Low', 'Urgent','High'];

  late TextEditingController messageCtrl;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    messageCtrl = TextEditingController();
   Future.delayed(Duration.zero,() {
     accountController.getTicketList("pending","high","1");
   },);
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
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: dropDown('All Status', statusList,  (value) {
                    selectedStatusValue = value;
                    print('Selected value: $value');

                    accountController.getTicketList(selectedStatusValue?.toLowerCase()??"",selectedPriorityValue?.toLowerCase()??"","1");
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
                    accountController.getTicketList(selectedStatusValue?.toLowerCase()??"",selectedPriorityValue?.toLowerCase()??"","1");
                  },),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Obx(() => accountController.isLoading.value?SizedBox(): listView())

          ],
        ),
      ),

      floatingActionButton:  FloatingActionButton.extended(
        backgroundColor: DI<ColorConst>().darkBlueColor,
        onPressed: () {
          createTicketDialog();
          },

        label: Text(
          DI<StringConst>().create_new_ticket_text,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().whiteColor,
              18,
              FontWeight.w700),
        ),

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


    );
  }


  Widget listView(){
    return ListView.separated(
      itemCount: accountController.ticketList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
      return  ClipPath(
        clipper: TicketClipper(),
        child: Container(
          width: double.infinity,
          height: 50.sp,
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DI<ColorConst>().redColor.withOpacity(0.5),
                DI<ColorConst>().redColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children:  [
                  Text(
                    "Ticket ID #${accountController.ticketList[index].id}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().whiteColor,
                        18,
                        FontWeight.w700),
                  ),
                  Spacer(),
                  Icon(Icons.money, color: Colors.white),
                  Spacer(),
                  Text(
                    accountController.ticketList[index].priority,
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().whiteColor,
                        18,
                        FontWeight.w700),
                  ),
                ],
              ),

              const Spacer(),

              /// Bottom Row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountController.ticketList[index].message,
                    maxLines: 3,
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().whiteColor,
                        17,
                        FontWeight.w400),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        flex :2,
                        child: Text(
                          "${accountController.ticketList[index].createdAt}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().greenColor,
                              15,
                              FontWeight.w400),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal:00, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child:  Text(
                              accountController.ticketList[index].adminStatus.toUpperCase(),
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10,); },);
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


  void createTicketDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: DI<ColorConst>().whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: const Icon(Icons.cancel),
                    onTap: () {

                      createPriorityValue = "";
                      messageCtrl.clear();
                      Get.back();
                    },
                  ),
                ),

                const SizedBox(height: 5),
                Text("Create New Ticket ", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 17.sp, FontWeight.w500),),
                const SizedBox(height: 10),
                Text("Priority ", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 14.sp, FontWeight.w500),),
                dropDown('Select Priority', createPriorityList,  (value) {
                  createPriorityValue = value;
                  print('Selected value: $value');

                },),



                SizedBox(
                  height: 10,
                ),

                Text("Message ", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 14.sp, FontWeight.w500),),
                DI<CommonWidget>().myTextFormField(
                  controller: messageCtrl,
                    "Enter message",
                    maxLine:null,
                    minLine: 5,

                    textInputAction: TextInputAction.done),
                SizedBox(
                  height: 10.w,
                ),
                DI<CommonWidget>().myButton(DI<StringConst>().save_text,(){

                  if(validation()){
                    accountController.createTicket(createPriorityValue?.toLowerCase()??"", messageCtrl.text.trim());
                    Get.back();

                  }
                  createPriorityValue = "";
                  messageCtrl.clear();
                }),
              ],
            ),
          ),
        );
      },
    );
  }


  bool validation(){

    if(createPriorityValue?.isEmpty??false){

      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_select_prority_text);

      return false;
    }else if(messageCtrl.text.isEmpty){
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_message_text);

      return false;
    }

    return true;

  }
}





class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const cutRadius = 12.0;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 2 - cutRadius);

    path.arcToPoint(
      Offset(size.width, size.height / 2 + cutRadius),
      radius: const Radius.circular(cutRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height / 2 + cutRadius);

    path.arcToPoint(
      Offset(0, size.height / 2 - cutRadius),
      radius: const Radius.circular(cutRadius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
