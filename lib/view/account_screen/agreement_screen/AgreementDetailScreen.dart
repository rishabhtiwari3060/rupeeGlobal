import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/model/AgreementModel.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/RouteHelper.dart';
import '../../../util/StringConst.dart';

class AgreementDetailScreen extends StatefulWidget {
  const AgreementDetailScreen({super.key});

  @override
  State<AgreementDetailScreen> createState() => _AgreementDetailScreenState();
}

class _AgreementDetailScreenState extends State<AgreementDetailScreen> {
  final AccountController _ctrl = Get.find<AccountController>();
  int? _agreementId;
  String? _selectedFilePath;
  String? _selectedFileName;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      );

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final id = args?['id'];
    if (id != null) {
      _agreementId = id is int ? id : int.tryParse(id.toString());
      if (_agreementId != null) {
        Future.microtask(() => _ctrl.getAgreementDetail(_agreementId!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: Get.back,
          child: Icon(Icons.arrow_back_ios, color: DI<ColorConst>().blackColor),
        ),
        title: Obx(() => Text(
              _ctrl.selectedAgreement.value?.title ?? DI<StringConst>().agreements_text,
              style: DI<CommonWidget>()
                  .myTextStyle(DI<ColorConst>().blackColor, 17.sp, FontWeight.w600),
            )),
      ),
      body: Obx(() {
        if (_ctrl.isAgreementLoading.value) return const SizedBox.shrink();
        final agreement = _ctrl.selectedAgreement.value;
        if (agreement == null) return _buildEmptyState();

        return SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(agreement),
              SizedBox(height: 16),
              _buildActionButtons(agreement),
              if (agreement.content != null && agreement.content!.isNotEmpty) ...[
                SizedBox(height: 16),
                _buildContentSection(agreement),
              ],
              if (agreement.isPending) ...[
                SizedBox(height: 16),
                _buildUploadSection(),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(Agreement agreement) {
    final isPending = agreement.isPending;
    final statusColor = isPending ? Colors.orange : DI<ColorConst>().dark_greenColor;
    final statusText = isPending ? DI<StringConst>().pending_text : DI<StringConst>().signed_text;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: _cardDecoration,
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
                    Text("Status",
                        style: DI<CommonWidget>()
                            .myTextStyle(DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400)),
                    SizedBox(height: 2),
                    Text(statusText.toUpperCase(),
                        style: DI<CommonWidget>()
                            .myTextStyle(statusColor, 12.sp, FontWeight.w600)),
                  ],
                ),
              ),
              _buildBadge(statusText.toUpperCase(), statusColor),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 0, thickness: 0.6, color: DI<ColorConst>().dividerColor.withOpacity(0.4)),
          SizedBox(height: 12),
          _buildInfoRow(DI<StringConst>().created_at_text, DI<CommonFunction>().formatDate(agreement.createdAt)),
          if (agreement.signedAt != null) ...[
            SizedBox(height: 8),
            _buildInfoRow(DI<StringConst>().signed_at_text, DI<CommonFunction>().formatDate(agreement.signedAt!)),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: DI<CommonWidget>()
                  .myTextStyle(DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400)),
          Text(value,
              style: DI<CommonWidget>()
                  .myTextStyle(DI<ColorConst>().blackColor, 12.sp, FontWeight.w500)),
        ],
      );

  Widget _buildActionButtons(Agreement agreement) {
    final hasSignedDoc = (agreement.signedDocumentUrl ?? '').isNotEmpty ||
        (agreement.isSigned && agreement.hasSignedDocument);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Actions",
              style: DI<CommonWidget>()
                  .myTextStyle(DI<ColorConst>().blackColor, 12.sp, FontWeight.w600)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  Icons.download_rounded,
                  DI<StringConst>().download_pdf_text,
                  DI<ColorConst>().secondColorPrimary,
                  _downloadAgreement,
                ),
              ),
              if (hasSignedDoc) ...[
                SizedBox(width: 10),
                Expanded(
                  child: _buildActionBtn(
                    Icons.visibility_rounded,
                    DI<StringConst>().view_signed_agreement_text,
                    DI<ColorConst>().dark_greenColor,
                    _viewSignedAgreement,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String text, Color color, VoidCallback onTap) =>
      InkWell(
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
                child: Text(text,
                    style: DI<CommonWidget>().myTextStyle(color, 12.sp, FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      );

  Widget _buildContentSection(Agreement agreement) => Container(
        padding: EdgeInsets.all(16),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DI<StringConst>().agreement_content_text,
                style: DI<CommonWidget>()
                    .myTextStyle(DI<ColorConst>().blackColor, 12.sp, FontWeight.w600)),
            SizedBox(height: 12),
            Html(
              data: agreement.content ?? "",
              style: {
                "body": Style(
                  fontSize: FontSize(12.sp),
                  color: DI<ColorConst>().blackColor,
                  fontFamily: "Roboto",
                ),
                "p": Style(margin: Margins.only(bottom: 8)),
                "h1, h2, h3, h4": Style(
                  fontWeight: FontWeight.w600,
                  color: DI<ColorConst>().blackColor,
                ),
              },
            ),
          ],
        ),
      );

  Widget _buildUploadSection() => Container(
        padding: EdgeInsets.all(16),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DI<StringConst>().upload_signed_agreement_text,
                style: DI<CommonWidget>()
                    .myTextStyle(DI<ColorConst>().blackColor, 12.sp, FontWeight.w600)),
            SizedBox(height: 4),
            Text(DI<StringConst>().pdf_only_max_5mb_text,
                style: DI<CommonWidget>()
                    .myTextStyle(DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400)),
            SizedBox(height: 16),
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
                  ),
                ),
                child: _selectedFilePath == null
                    ? Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 40, color: DI<ColorConst>().secondColorPrimary),
                          SizedBox(height: 8),
                          Text(DI<StringConst>().select_pdf_file_text,
                              style: DI<CommonWidget>()
                                  .myTextStyle(DI<ColorConst>().secondColorPrimary, 12.sp, FontWeight.w500)),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(Icons.picture_as_pdf, size: 36, color: DI<ColorConst>().redColor),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_selectedFileName ?? "Selected file",
                                    style: DI<CommonWidget>()
                                        .myTextStyle(DI<ColorConst>().blackColor, 12.sp, FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 2),
                                Text("Tap to change",
                                    style: DI<CommonWidget>()
                                        .myTextStyle(DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              _selectedFilePath = null;
                              _selectedFileName = null;
                            }),
                            icon: Icon(Icons.close_rounded, color: DI<ColorConst>().darkGryColor),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedFilePath == null || _ctrl.isUploadingAgreement.value
                        ? null
                        : _uploadSignedAgreement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DI<ColorConst>().secondColorPrimary,
                      disabledBackgroundColor: DI<ColorConst>().secondColorPrimary.withOpacity(0.5),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_ctrl.isUploadingAgreement.value)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        else
                          Icon(Icons.upload_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          _ctrl.isUploadingAgreement.value
                              ? DI<StringConst>().uploading_text
                              : DI<StringConst>().upload_text,
                          style: DI<CommonWidget>().myTextStyle(Colors.white, 12.sp, FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 60, color: DI<ColorConst>().darkGryColor.withOpacity(0.4)),
            SizedBox(height: 12),
            Text("Agreement not found",
                style: DI<CommonWidget>()
                    .myTextStyle(DI<ColorConst>().darkGryColor, 17.sp, FontWeight.w500)),
          ],
        ),
      );

  Widget _buildBadge(String text, Color color) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text,
            style: DI<CommonWidget>().myTextStyle(color, 12.sp, FontWeight.w600)),
      );

  Future<void> _pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result == null || result.files.single.path == null) return;

      final file = result.files.single;
      if (file.size > 5 * 1024 * 1024) {
        DI<CommonFunction>().showErrorSnackBar("File size must be less than 5MB");
        return;
      }
      setState(() {
        _selectedFilePath = file.path;
        _selectedFileName = file.name;
      });
    } catch (e) {
      DI<CommonFunction>().showErrorSnackBar("Error picking file: $e");
    }
  }

  /// Launch URL in Chrome/external browser; fallback to in-app WebView
  Future<void> _launchPdfUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) _openInAppWebView(url, isPdf: true);
      } else {
        _openInAppWebView(url, isPdf: true);
      }
    } catch (_) {
      _openInAppWebView(url, isPdf: true);
    }
  }

  /// Open URL in WebView. For PDFs, wrap with Google Docs viewer for proper display.
  void _openInAppWebView(String url, {bool isPdf = false}) {
    final displayUrl = isPdf
        ? "https://docs.google.com/viewer?url=${Uri.encodeComponent(url)}&embedded=true"
        : url;
    Get.toNamed(DI<RouteHelper>().getWebViewScreen(), parameters: {
      "url": displayUrl,
      "screenType": "Signed Agreement",
    });
  }

  Future<void> _downloadAgreement() async {
    final agreement = _ctrl.selectedAgreement.value;
    String? url = agreement?.downloadUrl;

    if (url == null || url.isEmpty) {
      if (_agreementId == null) return;
      try {
        final apiUrl = await _ctrl.getAgreementDownloadUrl(_agreementId!);
        final token = DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken);
        url = apiUrl.contains('?') ? "$apiUrl&token=$token" : "$apiUrl?token=$token";
      } catch (e) {
        DI<CommonFunction>().showErrorSnackBar("Error getting download link");
        return;
      }
    }
    await _launchPdfUrl(url);
  }

  Future<void> _viewSignedAgreement() async {
    final agreement = _ctrl.selectedAgreement.value;
    String? url = agreement?.signedDocumentUrl;

    if (url == null || url.isEmpty) {
      if (_agreementId == null) return;
      try {
        final apiUrl = await _ctrl.getAgreementViewSignedUrl(_agreementId!);
        final token = DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken);
        url = apiUrl.contains('?') ? "$apiUrl&token=$token" : "$apiUrl?token=$token";
      } catch (e) {
        DI<CommonFunction>().showErrorSnackBar("Error getting signed document link");
        return;
      }
    }
    // Open PDF in WebView via Google Docs viewer for proper in-app display
    _openInAppWebView(url!, isPdf: true);
  }

  Future<void> _uploadSignedAgreement() async {
    if (_agreementId == null || _selectedFilePath == null) return;

    final success = await _ctrl.uploadSignedAgreement(_agreementId!, _selectedFilePath!);
    if (success) {
      DI<CommonFunction>().showSuccessSnackBar("Agreement uploaded successfully");
      setState(() {
        _selectedFilePath = null;
        _selectedFileName = null;
      });
      Get.back();
    }
  }
}
