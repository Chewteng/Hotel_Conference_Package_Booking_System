import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String bookid, val;
  PaymentScreen({this.user, this.bookid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      //    title: Text('Payment',style: TextStyle(
       //                                                       //fontSize: 16,
       //                                                       fontWeight:
       //                                                           FontWeight
        //                                                              .w500,
       //                                                       color: Colors
       //                                                           .black)),
       //  backgroundColor: Colors.grey[200],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://yitengsze.com/hcpbs/php/payment.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&bookid=' +
                        widget.bookid +
                        '&date=' +
                        formatter.format(now)
                        ,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}