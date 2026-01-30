import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/view/account_screen/AccountScreen.dart';
import 'package:rupeeglobal/view/home_tab_screen/HomeTabScreen.dart';
import 'package:rupeeglobal/view/orders_screen/OrderScreen.dart';
import 'package:rupeeglobal/view/portfolio_screen/PortfolioScreen.dart';
import 'package:rupeeglobal/view/watchlist_screen/WatchListScreen.dart';

import '../view/account_screen/edit_profile/EditProfileScreen.dart';
import '../view/account_screen/news_screen/NewsScreen.dart';
import '../view/account_screen/news_screen/news_detail_screen.dart';
import '../view/account_screen/pms_screen/PmsScreen.dart';
import '../view/account_screen/support_ticket_screen/ChatScreen.dart';
import '../view/account_screen/support_ticket_screen/SupportTicketScreen.dart';
import '../view/account_screen/webview_screen/WebViewScreen.dart';
import '../view/auth_screen/forgotpassword_screen/ForgotPasswordScreen.dart';
import '../view/auth_screen/login_screen/LoginScreen.dart';
import '../view/auth_screen/reset_password_screen/ResetPasswordScreen.dart';
import '../view/auth_screen/signup_screen/SignUpScreen.dart';
import '../view/auth_screen/verification_screen/VerificationScreen.dart';
import '../view/home_screen/HomeScreen.dart';
import '../view/splash_screen/SplashScreen.dart';




class RouteHelper{

  String splashscreen = "/Splashscreen";
  String homeTabScreen = "/HomeTabScreen";
  String homeScreen = "/HomeScreen";
  String watchlistScreen = "/WatchlistScreen";
  String portfolioScreen = "/PortfolioScreen";
  String orderScreen = "/OrderScreen";
  String accountScreen = "/AccountScreen";
  String loginScreen = "/LoginScreen";
  String signupScreen = "/SignupScreen";
  String forgotPasswordScreen = "/ForgotPasswordScreen";
  String verificationScreen = "/VerificationScreen";
  String resetPasswordScreen = "/ResetPasswordScreen";
  String newsScreen = "/NewsScreen";
  String supportTicketScreen = "/SupportTicketScreen";
  String pmsScreen = "/PmsScreen";
  String newsDetailScreen = "/NewsDetailScreen";
  String webViewScreen = "/WebViewScreen";
  String editProfileScreen = "/EditProfileScreen";
  String chatScreen = "/ChatScreen";







String getSplashscreen() => splashscreen;
String getHomeScreen() => homeScreen;
String getHomeTabScreen() => homeTabScreen;
String getWatchlistScreen() => watchlistScreen;
String getPortfolioScreen() => portfolioScreen;
String getOrderScreen() => orderScreen;
String getAccountScreen() => accountScreen;
String getLoginScreen() => loginScreen;
String getSignupScreen() => signupScreen;
String getForgotPasswordScreen() => forgotPasswordScreen;
String getVerificationScreen() => verificationScreen;
String getResetPasswordScreen() => resetPasswordScreen;
String getNewsScreen() => newsScreen;
String getSupportTicketScreen() => supportTicketScreen;
String getPmsScreen() => pmsScreen;
String getNewsDetailScreen() => newsDetailScreen;
String getWebViewScreen() => webViewScreen;
String getEditProfileScreen() => editProfileScreen;
String getChatScreen() => chatScreen;








List<GetPage> get routes =>[
  GetPage(name: splashscreen, page: () => SplashScreen(),),
  GetPage(name: homeScreen, page: () =>  SafeArea(child:HomeScreen()),),
  GetPage(name: watchlistScreen, page: () =>  SafeArea(child:WatchlistScreen()),),
  GetPage(name: portfolioScreen, page: () =>  SafeArea(child:PortfolioScreen()),),
  GetPage(name: orderScreen, page: () =>  SafeArea(child:OrderScreen()),),
  GetPage(name: accountScreen, page: () =>  SafeArea(child:AccountScreen()),),
  GetPage(name: homeTabScreen, page: () =>  SafeArea(child:HomeTabScreen()),),
  GetPage(name: loginScreen, page: () =>  SafeArea(child:LoginScreen()),),
  GetPage(name: signupScreen, page: () =>  SafeArea(child:SignupScreen()),),
  GetPage(name: forgotPasswordScreen, page: () =>  SafeArea(child:ForgotPasswordScreen()),),
  GetPage(name: verificationScreen, page: () =>  SafeArea(child:VerificationScreen()),),
  GetPage(name: resetPasswordScreen, page: () =>  SafeArea(child:ResetPasswordScreen()),),
  GetPage(name: newsScreen, page: () =>  SafeArea(child:NewsScreen()),),
  GetPage(name: supportTicketScreen, page: () =>  SafeArea(child:SupportTicketScreen()),),
  GetPage(name: pmsScreen, page: () =>  SafeArea(child:PmsScreen()),),
  GetPage(name: newsDetailScreen, page: () =>  SafeArea(child:NewsDetailScreen()),),
  GetPage(name: webViewScreen, page: () =>  SafeArea(child:WebViewScreen()),),
  GetPage(name: editProfileScreen, page: () =>  SafeArea(child:EditProfileScreen()),),
  GetPage(name: chatScreen, page: () =>  SafeArea(child: ChatScreen()),),



];

}