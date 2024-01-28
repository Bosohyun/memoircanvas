import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomerPortal extends StatefulWidget {
  const CustomerPortal({required this.url, super.key});

  final String url;
  @override
  State<CustomerPortal> createState() => _CustomerPortalState();
}

class _CustomerPortalState extends State<CustomerPortal> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://cancel.com')) {
              Navigator.of(context).pop('cancel');
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: WebViewWidget(
        controller: _controller,
      )),
    );
  }
}
