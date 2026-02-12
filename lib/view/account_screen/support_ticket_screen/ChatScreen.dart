import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/model/ChatDetailModel.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/CommonWidget.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../../util/Injection.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  AccountController accountController = Get.find<AccountController>();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String ticketId = "",chatStatus = "";


  @override
  void initState() {
    super.initState();
    if(Get.parameters["id"]!= null){
      ticketId = Get.parameters["id"]??"";
      chatStatus = Get.parameters["status"]??"";
    }


    Future.delayed(Duration.zero,() {
      accountController.getChatDetail(ticketId).then((value) {
        print(accountController.chatList.length);
      },);
    },);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Obx(
           () =>  Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount:accountController.chatList.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message:accountController.chatList[index]);
                },
              ),
            ),
          ),

          chatStatus == "close"?
    Container(
      width: 100.w,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical:13),
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
    color: Colors.red.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
    "This ticket is closed. \nYou can change the status to \"Pending\" above to reopen this ticket.",
      textAlign: TextAlign.center,
      style: DI<CommonWidget>()
        .myTextStyle(Colors.red, 15.sp, FontWeight.w600),
    ),
    )
              :
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: DI<CommonWidget>().myTextFormField(
                  controller: _messageController,
                  'Type a message...')
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 22,
              backgroundColor: DI<ColorConst>().redColor,
              child: IconButton(
                icon:  Icon(Icons.send,color: DI<ColorConst>().whiteColor,),
                onPressed:(){
                  _sendMessage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _sendMessage()async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await accountController.sendChatMessage(ticketId,text).then((value) {

      print(value);
      if(value){
        accountController.chatList.add(
            Message(id: accountController.chatList.length,
                message: text,
                isAdmin: false,
                userName: DI<MyLocalStorage>().userName,
                createdAt: DateTime.now()));

        accountController.chatList.refresh();
        _messageController.clear();

        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    },);


  }

}


class ChatBubble extends StatelessWidget {
  final Message message;


  const ChatBubble({Key? key, required this.message}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final alignment = !message.isAdmin ? Alignment.centerRight : Alignment.centerLeft;
    final color = !message.isAdmin ? DI<ColorConst>().redColor : DI<ColorConst>().chatAdminBubbleColor;
    final textColor = !message.isAdmin ? Colors.white : DI<ColorConst>().chatAdminTextColor;


    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: !message.isAdmin ? const Radius.circular(16) : Radius.zero,
            bottomRight: !message.isAdmin ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              "${DI<CommonFunction>().formatDateTime(message.createdAt)}",
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

