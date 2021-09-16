import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_booking/bookingdetails.dart';
import 'package:http/http.dart' as http;
import 'book.dart';
//import 'bookingdetailsscreen.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  //List _bookdetails;
  String server = "https://yitengsze.com/hcpbs";
  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 15,
          ),
          // Text(
          //   "Payment History",
          //   style: TextStyle(
          //        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          //  ),
          _paymentdata == null
              ? Flexible(
                  child: Container(
                          color: Colors.white,
                          child: Center(
                              child: Column(children: <Widget>[
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 200, 10, 10),
                                child: Image.asset(
                                  'assets/images/sad.png',
                                  height: 150,
                                  width: 100,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              titlecenter = "No Package Booking Made Yet",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ]))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Container(
                            //margin: EdgeInsets.all(300.0),
                            // padding: EdgeInsets.fromLTRB(10, 3, 10, 1),
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [Colors.grey[200], Colors.grey]),
                                border: new Border.all(
                                    color: Colors.white, width: 3.50),
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: InkWell(
                                onTap: () => loadBookDetails(index),
                                child: Card(
                                  color: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        (index + 1).toString() + ".",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                          flex: 10,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  
                                                  Text(
                                                    "Booking ID: " +
                                                        _paymentdata[index]
                                                            ['bookid'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                 Icon(Icons.arrow_forward_ios)
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              
Text(
                                                "Receipt ID: " +
                                                    _paymentdata[index]
                                                        ['billid'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                              
                                              
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "RM " +
                                                      _paymentdata[index]
                                                          ['total'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(height: 3,),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text("Placed on " +
                                                  convertDateTimeDisplay(
                                                            _paymentdata[index]
                                                                ['date']),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('MMMM d, yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadPaymentHistory = server + "/php/load_paymenthistory.php";
    await http.post(urlLoadPaymentHistory,
        body: {
          
          "email": widget.user.email
          }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Any Payment Made";
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

  loadBookDetails(int index) {
    Book book = new Book(
        billid: _paymentdata[index]['billid'],
        bookid: _paymentdata[index]['bookid'],
        total: _paymentdata[index]['total'],
        wallet: _paymentdata[index]['wallet'],
        tpprice: _paymentdata[index]['tpprice'],
        date: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BookingDetailsScreen(
                  book: book,
                )));
  }
}
