import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
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
  AccountController accountController = Get.find();

  String? selectedStatusValue, selectedPriorityValue, createPriorityValue = "";

  List<String> statusList = ['All Status', 'Pending', 'Closed'];
  List<String> priorityList = ['All Priority', 'Low', 'Urgent', 'High'];
  List<String> createPriorityList = ['Low', 'Urgent', 'High'];

  late TextEditingController messageCtrl;
  late ScrollController _scrollController;

  int _ticketPage = 1;
  bool _canScrollMore = true;

  @override
  void initState() {
    super.initState();
    messageCtrl = TextEditingController();
    _scrollController = ScrollController()..addListener(_scrollListener);
    Future.delayed(Duration.zero, () {
      accountController.getTicketList("allstatus", "allpriority", "1");
    });
  }

  @override
  void dispose() {
    messageCtrl.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (_canScrollMore && !accountController.isLoading.value) {
        _ticketPage++;
        accountController.getTicketList(
          selectedStatusValue?.toLowerCase() ?? "pending",
          selectedPriorityValue?.toLowerCase() ?? "high",
          _ticketPage.toString(),
        );
      }
    }
  }

  void _resetAndFetch() {
    _ticketPage = 1;
    _canScrollMore = true;
    accountController.getTicketList(
      selectedStatusValue?.toLowerCase() ?? "",
      selectedPriorityValue?.toLowerCase() ?? "",
      "1",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: DI<ColorConst>().blackColor),
        ),
        title: Text(
          DI<StringConst>().support_ticket_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 19.sp, FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          /// Filter Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _filterDropdown('All Status', statusList, (value) {
                    selectedStatusValue = value;
                    _resetAndFetch();
                  }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child:
                      _filterDropdown('All Priority', priorityList, (value) {
                    selectedPriorityValue = value;
                    _resetAndFetch();
                  }),
                ),
              ],
            ),
          ),

          /// Ticket List
          Expanded(
            child: Obx(
              () => accountController.isLoading.value
                  ? SizedBox()
                  : accountController.ticketList.isEmpty
                      ? _emptyState()
                      : ListView.separated(
                          controller: _scrollController,
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          itemCount: accountController.ticketList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final ticket = accountController.ticketList[index];
                            return _ticketCard(ticket);
                          },
                        ),
            ),
          ),
        ],
      ),

      /// Bottom loading indicator for pagination
      bottomNavigationBar: Obx(
        () => accountController.isBottomLoading.value
            ? SizedBox(
                height: kBottomNavigationBarHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: DI<ColorConst>().secondColorPrimary,
                  ),
                ),
              )
            : SizedBox(),
      ),

      /// FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: DI<ColorConst>().secondColorPrimary,
        onPressed: () => _createTicketDialog(),
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 20),
        label: Text(
          "New Ticket",
          style: DI<CommonWidget>()
              .myTextStyle(Colors.white, 14.sp, FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// ─── Empty State ─────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_outlined,
              size: 60, color: DI<ColorConst>().darkGryColor.withOpacity(0.4)),
          SizedBox(height: 12),
          Text(
            "No tickets found",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// ─── Ticket Card ─────────────────────────────────
  Widget _ticketCard(dynamic ticket) {
    final isPending =
        ticket.adminStatus.toString().toLowerCase() == "pending";
    final statusColor = isPending
        ? Colors.orange
        : DI<ColorConst>().dark_greenColor;

    return InkWell(
      onTap: () {
        var data = {"id": ticket.id.toString(),
        "status" : ticket.adminStatus.toString()
        };
        Get.toNamed(DI<RouteHelper>().getChatScreen(), parameters: data);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DI<ColorConst>().cardBgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: DI<ColorConst>().dividerColor.withOpacity(0.4),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: ID + Priority + Chat
            Row(
              children: [
                /// Ticket icon
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: DI<ColorConst>()
                        .secondColorPrimary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.confirmation_number_outlined,
                      color: DI<ColorConst>().secondColorPrimary, size: 18),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ticket #${ticket.id}",
                        style: DI<CommonWidget>().myTextStyle(
DI<ColorConst>().blackColor,
                                            14.sp,
                                            FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 12,
                              color: DI<ColorConst>().darkGryColor),
                          SizedBox(width: 3),
                          Text(
                            "${DI<CommonFunction>().formatDate(ticket.createdAt)}",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().darkGryColor,
                                12.sp,
                                FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Priority badge
                _badge(
                  ticket.priority.toString().toUpperCase(),
                  _priorityColor(ticket.priority.toString()),
                ),
              ],
            ),
            SizedBox(height: 12),

            /// Message
            Text(
              ticket.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 14.sp, FontWeight.w400),
            ),
            SizedBox(height: 12),

            Divider(
              height: 0,
              thickness: 0.6,
              color: DI<ColorConst>().dividerColor.withOpacity(0.4),
            ),
            SizedBox(height: 10),

            /// Footer: Status + Chat button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _badge(
                  ticket.adminStatus.toString().toUpperCase(),
                  statusColor,
                ),
                Row(
                  children: [
                    if (ticket.messagesCount != null &&
                        ticket.messagesCount > 0)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: DI<ColorConst>().darkGryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 13,
                                color: DI<ColorConst>().darkGryColor),
                            SizedBox(width: 3),
                            Text(
                              "${ticket.messagesCount}",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().darkGryColor,
                                  12.sp,
                                  FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: DI<ColorConst>().darkGryColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ─── Badge Widget ────────────────────────────────
  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: DI<CommonWidget>()
            .myTextStyle(color, 12.sp, FontWeight.w600),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return DI<ColorConst>().redColor;
      case 'high':
        return Colors.orange;
      case 'low':
        return DI<ColorConst>().dark_greenColor;
      default:
        return DI<ColorConst>().darkGryColor;
    }
  }

  /// ─── Filter Dropdown ─────────────────────────────
  Widget _filterDropdown(
      String hint, List<String> items, ValueChanged<String?>? onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.5),
          width: 0.8,
        ),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
        ),
        dropdownColor: DI<ColorConst>().cardBgColor,
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: DI<ColorConst>().darkGryColor),
        style: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().blackColor, 14.sp, FontWeight.w400),
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// ─── Create Ticket Dialog ────────────────────────
  void _createTicketDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: DI<ColorConst>().dialogBgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create New Ticket",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor, 19.sp, FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        createPriorityValue = "";
                        messageCtrl.clear();
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: DI<ColorConst>().darkGryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 18, color: DI<ColorConst>().darkGryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                /// Priority
                Text(
                  "Priority",
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
                ),
                SizedBox(height: 6),
                _filterDropdown('Select Priority', createPriorityList, (value) {
                  createPriorityValue = value;
                }),
                SizedBox(height: 16),

                /// Message
                Text(
                  "Message",
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
                ),
                SizedBox(height: 6),
                DI<CommonWidget>().myTextFormField(
                  controller: messageCtrl,
                  "Enter message",
                  maxLine: null,
                  minLine: 4,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 24),

                DI<CommonWidget>().myButton(DI<StringConst>().save_text, () {
                  if (_validation()) {
                    accountController.createTicket(
                        createPriorityValue?.toLowerCase() ?? "",
                        messageCtrl.text.trim());
                    Get.back();

                    createPriorityValue = "";
                    messageCtrl.clear();
                  }

                }),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validation() {
    if (createPriorityValue?.isEmpty ?? false) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_select_prority_text);
      return false;
    } else if (messageCtrl.text.isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_message_text);
      return false;
    } else if (messageCtrl.text.length <5) {
      DI<CommonFunction>()
          .showErrorSnackBar("please enter more 5 character in message");
      return false;
    }
    return true;
  }
}
