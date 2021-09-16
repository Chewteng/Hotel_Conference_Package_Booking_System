import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_booking/storecredit.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class WalletScreen extends StatefulWidget {
  final User user;

  const WalletScreen({Key key, this.user}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List _paymentdata;
  String server = "https://yitengsze.com/hcpbs";
  String titlecenter = "Loading CP Hotel Wallet...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  TextEditingController creditController = TextEditingController();
  var parsedDate;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadWalletTopUp();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('CP Hotel Booking Wallet'),
        backgroundColor: Colors.blue[400],
      ),
      body: RefreshIndicator(
                key: refreshKey,
                color: Color.fromRGBO(101, 255, 218, 50),
                onRefresh: () async {
                  await refreshList();
                },
      
      
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                height: 245.0,
                color: Colors.blue[400],
                child: Center(
                    child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
                      Text(
                        "Balance",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "RM ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 24),
                          ),
                          Text(
                            widget.user.credit,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
              // Container(color: Colors.white,),

              Container(
                color: Colors.white,
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 120,
                              width: 5,
                            ),
                            Text("Transactions",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ])),
                ]),
              ),

              _paymentdata == null
                  ? Flexible(
                      child: Container(
                          color: Colors.white,
                          child: Center(
                              child: Column(children: <Widget>[
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 50, 10, 10),
                                child: Image.asset(
                                  'assets/images/sad.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              titlecenter = "No Top Up Transaction",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ]))))
                  : Expanded(
                      child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ListView.builder(

                              //Step 6: Count the data
                              itemCount: _paymentdata == null
                                  ? 0
                                  : _paymentdata.length,
                              itemBuilder: (context, index) {
                                SizedBox(
                                  height: 500,
                                );

                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 3, 10, 1),
                                    child: Container(
                                      color: Colors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 10,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        (index + 1).toString() +
                                                            ".",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Receipt ID: " +
                                                            _paymentdata[index]
                                                                ['billid'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          "+ RM " +
                                                              _paymentdata[
                                                                      index]
                                                                  ['total'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 18,
                                                      ),
                                                      Text(
                                                        f.format(DateTime.parse(
                                                            _paymentdata[index]
                                                                ['date'])),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "Successful",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ));
                              })))
            ],
          ),

          Positioned(
            top: 155.0,
            //left: 50, // (background container size) - (circle height / 2)
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                color: Colors.grey[700],
                padding: EdgeInsets.fromLTRB(10, 5, 70, 85),
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter Top Up Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white)),
                    ),
                    TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: creditController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter RM',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Input Top Up Amount',
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 14),
                          icon: Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 280,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[400],
              ),
              child: new MaterialButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.payment,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Pay Now",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                color: Colors.blue[400],
                textColor: Colors.white,
                elevation: 10,
                onPressed: () => _topUpWallet(creditController.text.toString()),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadWalletTopUp();
    return null;
  }

  Future<void> _loadWalletTopUp() async {
    String urlLoadWalletTopUp = server + "/php/load_wallethistory.php";
    await http.post(urlLoadWalletTopUp,
        body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Any Transaction Made";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _topUpWallet(String cr) {
    print("RM " + cr);
    if (cr.length <= 0) {
      Toast.show("Please enter correct amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Top Up Amount RM ' + cr,
          style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StoreCreditScreen(
                              user: widget.user,
                              val: cr,
                            )));
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.blue[600],fontWeight: FontWeight.bold
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.blue[400],fontWeight: FontWeight.bold
                ),
              )),
        ],
      ),
    );
  }
}
