import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountController accountController;

  @override
  void initState() {
    super.initState();
    accountController = Get.find<AccountController>();

    Future.delayed(Duration.zero, () {
      accountController.getUserProfile().then((value) {
        if (accountController.userName.value.isNotEmpty) {
          accountController.firstLetter.value =
              accountController.userName.value[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      body: Obx(
        () => accountController.isLoading.value
            ? SizedBox()
            : SingleChildScrollView(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        "Your Account",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor, 22.sp, FontWeight.w600),
                      ),
                    ),

                    /// Profile Card
                    _buildProfileCard(),

                    SizedBox(height: 20),

                    /// General Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "General",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 8),

                    _buildMenuCard([
                      _menuItem(Icons.person_outline_rounded,
                          DI<StringConst>().edit_profile_text, () {
                        Get.toNamed(DI<RouteHelper>().getEditProfileScreen());
                      }),
                      _menuItem(Icons.support_agent_rounded,
                          DI<StringConst>().support_ticket_text, () {
                        Get.toNamed(DI<RouteHelper>().getSupportTicketScreen());
                      }),
                    ]),

                    SizedBox(height: 20),

                    /// Tools Section - PMS & News as box cards in a row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Tools",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 8),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _boxCard(
                              Icons.calculate_outlined,
                              DI<StringConst>().pms_text,
                              () {
                                Get.toNamed(DI<RouteHelper>().getPmsScreen());
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _boxCard(
                              Icons.newspaper_rounded,
                              DI<StringConst>().news_text,
                              () {
                                Get.toNamed(DI<RouteHelper>().getNewsScreen());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    /// Legal Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Legal",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 8),

                    _buildMenuCard([
                      _menuItem(Icons.assignment_outlined,
                          DI<StringConst>().agreements_text, () {
                        Get.toNamed(DI<RouteHelper>().getAgreementScreen());
                      }),
                      _menuItem(Icons.shield_outlined,
                          DI<StringConst>().privacy_policy_text, () {
                        var data = {
                          "url": "https://www.rupeeglobal.in/legal/privacy-policy",
                          "screenType": "Privacy Policy",
                        };
                        Get.toNamed(DI<RouteHelper>().getWebViewScreen(),
                            parameters: data);
                      }),
                      _menuItem(Icons.description_outlined,
                          DI<StringConst>().terms_conditions_text, () {
                        var data = {
                          "url":
                              "https://www.rupeeglobal.in/legal/terms-and-condition",
                          "screenType": "Terms & Conditions",
                        };
                        Get.toNamed(DI<RouteHelper>().getWebViewScreen(),
                            parameters: data);
                      }),
                    ]),

                    SizedBox(height: 24),

                    /// Logout
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          DI<MyLocalStorage>().clearLocalStorage();
                          Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: DI<ColorConst>().redColor.withOpacity(0.4),
                                width: 1.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: DI<ColorConst>().redColor, size: 20),
                              SizedBox(width: 8),
                              Text(
                                DI<StringConst>().logout_text,
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().redColor,
                                    15.sp,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  /// Profile Card - no arrow
  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            DI<ColorConst>().secondColorPrimary,
            DI<ColorConst>().secondColorPrimary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          /// Avatar
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                accountController.firstLetter.value.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 14),

          /// Name & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountController.userName.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Roboto",
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Manage your account",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontFamily: "Roboto",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Box Card for PMS / News (icon on top, name below)
  Widget _boxCard(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: DI<ColorConst>().cardBgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: DI<ColorConst>().dividerColor.withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: DI<ColorConst>().secondColorPrimary,
                size: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 14.sp, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Grouped Menu Card
  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.5),
          width: 0.8,
        ),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                Divider(
                  height: 0,
                  thickness: 0.6,
                  color: DI<ColorConst>().dividerColor.withOpacity(0.5),
                  indent: 52,
                ),
            ],
          );
        }),
      ),
    );
  }

  /// Single Menu Item
  Widget _menuItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: DI<ColorConst>().secondColorPrimary,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor, 15.sp, FontWeight.w400),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: DI<ColorConst>().darkGryColor,
            ),
          ],
        ),
      ),
    );
  }
}
