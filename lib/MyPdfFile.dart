import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class MyPdf extends StatefulWidget {
  @override
  _MyPdfState createState() => _MyPdfState();
}

class _MyPdfState extends State<MyPdf> {
  final imgUrl = "https://chewteng.github.io/purchaseorder.pdf";

  var dio = Dio();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.lightBlue, Colors.blue[700]],
  ).createShader(Rect.fromLTWH(10.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reservation & Booking',
                    style: new TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient),
                  ))
            ],
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: '✅ ',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                    text: 'For reservation and booking, kindly check with our ',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                TextSpan(
                    text: 'latest available packages. ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Please take note reservation & booking must be placed '),
                TextSpan(
                    text: 'one weeks (7 days) before the arrival date. ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'CP Hotel '),
                TextSpan(
                    text: 'will not process any application ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'of reservation/booking submitted less then one weeks before the arrival date. '),
              ],
            ),
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: '✅ ',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                    text:
                        'No personal contact or phone call reservation is allowed ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'to avoid any miscommunication & crash booking. Booking can only be done '),
                TextSpan(
                    text: 'online. ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: '✅ ',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: "Reservation and booking "),
                TextSpan(
                    text:
                        'cannot be changed ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'and price is '),
                TextSpan(
                    text: 'non-refundable ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "once the payment is completed successfully. "),
              ],
            ),
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: '✅ ',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                  text: 'Please click the ',
                ),
                TextSpan(
                    text: 'button ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'below to download the '),
                TextSpan(
                    text: 'invoice ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'of local/purchase order. Complete and submit back with email to '),
                TextSpan(
                    text: 'admin@cphotelbooking.com ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ],
            ),
          ),
          RaisedButton.icon(
              onPressed: () async {
                String path =
                    await ExtStorage.getExternalStoragePublicDirectory(
                        ExtStorage.DIRECTORY_DOWNLOADS);
                String fullPath = "$path/invoice.pdf";
                download2(dio, imgUrl, fullPath);
              },
              icon: Icon(Icons.file_download, color: Colors.white),
              color: Colors.green,
              textColor: Colors.white,
              
              label: Text("Download",style: TextStyle(fontWeight: FontWeight.bold))),
              
          SizedBox(height: 10),
          Text("********************************************************* "),
          RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: 'A '),
                TextSpan(
                    text: 'CONFIRMATION EMAIL ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'will be sent '),
                TextSpan(
                    text: 'within 3 working days ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'with attached Official Quotation for payment process. '),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: 'Payment should be payable to '),
                TextSpan(
                    text: 'CP Hotel (',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'Payment Account No.: '),
                TextSpan(
                    text: '403.G.CHALET.432004',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ') '),
                TextSpan(text: 'and please submit the original invoice along with payment receipt back to our office for booking confirmation.'),
              ],
            ),
          ),
          Text("********************************************************* "),
          SizedBox(height:10),
          Text("********************************************************* "),
          RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: 'All prices are '),
                TextSpan(
                    text: 'fixed ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'and '),
                TextSpan(
                    text: 'not negotiable. ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                    text: 'Full payment ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'is required in order to '),
                TextSpan(
                    text: 'proceed reservation successfully. ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                
              ],
            ),
          ),
          Text("********************************************************* "),
          SizedBox(height:10),
          Text("********************************************************* "),
          RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                
                TextSpan(
                    text: 'CP Hotel ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'reserves the right to '),
                TextSpan(
                    text: 'approve ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                   
                TextSpan(text: 'or '),
                TextSpan(
                    text: 'reject ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'any reservation booking, change or cancellation request.'),
              ],
            ),
          ),
          Text("********************************************************* ")
        ],
      )),
    ));
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    print("Manual Payment Page");
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future download2(Dio dio, String url, String savePath) async {
    //get pdf from link
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      //write in download folder
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      Toast.show("Invoice downloaded successfully. Please check your downloaded file there.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print("Downloaded Successfully");
    } catch (e) {
      print("error");
      print("e");
    }
  }

  //progress bar

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
