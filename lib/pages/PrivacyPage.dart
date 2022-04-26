import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String pdfasset = "assets/sample.pdf";
  late PDFDocument document;
  bool _isLoading = true;

  @override
  void initState() {
    loadDocument();
    super.initState();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/files/Terms Of Use_NextOnMap-merged.pdf');

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : PDFViewer(
                  document: document,
                  lazyLoad: false,
                  zoomSteps: 1,
                  enableSwipeNavigation: true,
                ),
        ),
      );
  }
}
