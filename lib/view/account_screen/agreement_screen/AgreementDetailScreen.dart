import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class AgreementDetailScreen extends StatefulWidget {
  const AgreementDetailScreen({super.key});

  @override
  State<AgreementDetailScreen> createState() => _AgreementDetailScreenState();
}

class _AgreementDetailScreenState extends State<AgreementDetailScreen> {
  AccountController accountController = Get.find();
  int? agreementId;
  String? selectedFilePath;
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['id'] != null) {
      agreementId = args['id'];
      Future.delayed(Duration.zero, () {
        accountController.getAgreementDetail(agreementId!);
      });
    }
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
        title: Obx(() => Text(
          accountController.selectedAgreement.value?.title ?? DI<StringConst>().agreements_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 16.sp, FontWeight.w600),
        )),
      ),
      body: Obx(() {
        if (accountController.isAgreementLoading.value) {
          return SizedBox();
        }

        final agreement = accountController.selectedAgreement.value;
        if (agreement == null) {
          return _emptyState();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Status Card
              _buildStatusCard(agreement),
              SizedBox(height: 16),

              /// Action Buttons
              _buildActionButtons(agreement),
              SizedBox(height: 16),

              /// Agreement Content
              if (agreement.content != null && agreement.content!.isNotEmpty) ...[
                _buildContentSection(agreement),
                SizedBox(height: 16),
              ],

              /// Upload Section (only if pending)
              if (agreement.isPending) _buildUploadSection(),
            ],
          ),
        );
      }),
    );
  }

  /// Status Card
  Widget _buildStatusCard(dynamic agreement) {
    final isPending = agreement.isPending;
    final statusColor = isPending ? Colors.orange : DI<ColorConst>().dark_greenColor;
    final statusText = isPending 
        ? DI<StringConst>().pending_text 
        : DI<StringConst>().signed_text;

    return Container(
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
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPending ? Icons.pending_actions : Icons.check_circle_outline,
                  color: statusColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().darkGryColor, 11.sp, FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    Text(
                      statusText.toUpperCase(),
                      style: DI<CommonWidget>().myTextStyle(
                          statusColor, 14.sp, FontWeight.w600),
                    ),
                  ],
                ),
              ),
              _badge(statusText.toUpperCase(), statusColor),
            ],
          ),
          SizedBox(height: 12),
          Divider(
            height: 0,
            thickness: 0.6,
            color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          ),
          SizedBox(height: 12),
          _infoRow(DI<StringConst>().created_at_text, agreement.createdAt),
          if (agreement.signedAt != null) ...[
            SizedBox(height: 8),
            _infoRow(DI<StringConst>().signed_at_text, agreement.signedAt!),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
        ),
        Text(
          value,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().blackColor, 12.sp, FontWeight.w500),
        ),
      ],
    );
  }

  /// Action Buttons
  Widget _buildActionButtons(dynamic agreement) {
    return Container(
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
          Text(
            "Actions",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 14.sp, FontWeight.w600),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  Icons.download_rounded,
                  DI<StringConst>().download_pdf_text,
                  DI<ColorConst>().secondColorPrimary,
                  () => _downloadAgreement(),
                ),
              ),
              SizedBox(width: 10),
              if (agreement.isSigned && agreement.hasSignedDocument)
                Expanded(
                  child: _actionButton(
                    Icons.visibility_rounded,
                    DI<StringConst>().view_signed_agreement_text,
                    DI<ColorConst>().dark_greenColor,
                    () => _viewSignedAgreement(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: DI<CommonWidget>().myTextStyle(color, 11.sp, FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Agreement Content Section
  Widget _buildContentSection(dynamic agreement) {
    return Container(
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
          Text(
            DI<StringConst>().agreement_content_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 14.sp, FontWeight.w600),
          ),
          SizedBox(height: 12),
          Html(
            data: agreement.content ?? "",
            style: {
              "body": Style(
                fontSize: FontSize(13.sp),
                color: DI<ColorConst>().blackColor,
                fontFamily: "Roboto",
              ),
              "p": Style(
                margin: Margins.only(bottom: 8),
              ),
              "h1, h2, h3, h4": Style(
                fontWeight: FontWeight.w600,
                color: DI<ColorConst>().blackColor,
              ),
            },
          ),
        ],
      ),
    );
  }

  /// Upload Section
  Widget _buildUploadSection() {
    return Container(
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
          Text(
            DI<StringConst>().upload_signed_agreement_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 14.sp, FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            DI<StringConst>().pdf_only_max_5mb_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 11.sp, FontWeight.w400),
          ),
          SizedBox(height: 16),

          /// File picker area
          InkWell(
            onTap: _pickPdfFile,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: DI<ColorConst>().secondColorPrimary.withOpacity(0.3),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: selectedFilePath == null
                  ? Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: DI<ColorConst>().secondColorPrimary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          DI<StringConst>().select_pdf_file_text,
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().secondColorPrimary,
                              13.sp,
                              FontWeight.w500),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 36,
                          color: DI<ColorConst>().redColor,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedFileName ?? "Selected file",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().blackColor,
                                    12.sp,
                                    FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Tap to change",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    10.sp,
                                    FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedFilePath = null;
                              selectedFileName = null;
                            });
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: DI<ColorConst>().darkGryColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 16),

          /// Upload Button
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedFilePath == null || accountController.isUploadingAgreement.value
                  ? null
                  : _uploadSignedAgreement,
              style: ElevatedButton.styleFrom(
                backgroundColor: DI<ColorConst>().secondColorPrimary,
                disabledBackgroundColor: DI<ColorConst>().secondColorPrimary.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (accountController.isUploadingAgreement.value)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(Icons.upload_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    accountController.isUploadingAgreement.value
                        ? DI<StringConst>().uploading_text
                        : DI<StringConst>().upload_text,
                    style: DI<CommonWidget>().myTextStyle(
                        Colors.white, 14.sp, FontWeight.w600),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  /// Empty State
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined,
              size: 60, color: DI<ColorConst>().darkGryColor.withOpacity(0.4)),
          SizedBox(height: 12),
          Text(
            "Agreement not found",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 15.sp, FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Badge Widget
  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: DI<CommonWidget>().myTextStyle(color, 10.sp, FontWeight.w600),
      ),
    );
  }

  /// Pick PDF File
  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        
        // Check file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
          DI<CommonFunction>().showErrorSnackBar("File size must be less than 5MB");
          return;
        }

        setState(() {
          selectedFilePath = file.path;
          selectedFileName = file.name;
        });
      }
    } catch (e) {
      DI<CommonFunction>().showErrorSnackBar("Error picking file: $e");
    }
  }

  /// Download Agreement PDF
  Future<void> _downloadAgreement() async {
    if (agreementId == null) return;

    try {
      final url = await accountController.getAgreementDownloadUrl(agreementId!);
      final token = DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken);
      
      // Open in browser with auth (for download, we open the URL)
      final uri = Uri.parse("$url?token=$token");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        DI<CommonFunction>().showErrorSnackBar("Could not open download link");
      }
    } catch (e) {
      DI<CommonFunction>().showErrorSnackBar("Error downloading: $e");
    }
  }

  /// View Signed Agreement
  Future<void> _viewSignedAgreement() async {
    if (agreementId == null) return;

    try {
      final url = await accountController.getAgreementViewSignedUrl(agreementId!);
      final token = DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken);
      
      final uri = Uri.parse("$url?token=$token");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        DI<CommonFunction>().showErrorSnackBar("Could not open signed agreement");
      }
    } catch (e) {
      DI<CommonFunction>().showErrorSnackBar("Error viewing signed agreement: $e");
    }
  }

  /// Upload Signed Agreement
  Future<void> _uploadSignedAgreement() async {
    if (agreementId == null || selectedFilePath == null) return;

    final success = await accountController.uploadSignedAgreement(agreementId!, selectedFilePath!);
    
    if (success) {
      DI<CommonFunction>().showSuccessSnackBar("Agreement uploaded successfully");
      setState(() {
        selectedFilePath = null;
        selectedFileName = null;
      });
      // Refresh the agreement detail
      accountController.getAgreementDetail(agreementId!);
    }
  }
}
