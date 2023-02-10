import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidgetComponent extends StatefulWidget {

  final String urlString;
  final DashboardModel model;

  const WebViewWidgetComponent({super.key, required this.urlString, required this.model});

  @override
  State<WebViewWidgetComponent> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidgetComponent> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.model.accentColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlString));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Web View'),
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),
        elevation: 0,
        iconTheme: IconThemeData(
          color: widget.model.paletteColor
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}