import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final String url;
  final PageFinishedCallback onPageFinished;
  const WebViewWidget({
    Key? key,
    required this.url,
    required this.onPageFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late WebViewController controllerGlobal;

    Future<bool> _exitApp(BuildContext context) async {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return false;
      } else {
        return Future.value(true);
      }
    }

    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: WebView(
        initialUrl: url,
        onPageFinished: onPageFinished,
        gestureNavigationEnabled: true,
        onWebViewCreated: (controller) {
          controllerGlobal = controller;
        },
      ),
    );
  }
}
