import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_booking/book.dart';
import 'package:hotel_booking/customerbookingdetails.dart';
import 'package:hotel_booking/newcustomerbooking.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomerBookingsScreen extends StatefulWidget {
  final User user;

  const CustomerBookingsScreen({Key key, this.user}) : super(key: key);

  @override
  _CustomerBookingsScreenState createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen> {
  List _customerdata;
  //List _bookdetails;
  String server = "https://yitengsze.com/hcpbs";
  String titlecenter = "Loading customer bookings...";
  var parsedDate;
  double screenHeight, screenWidth;
  TextEditingController _prdController = new TextEditingController();
  String curtype = "Customer Booking Lists";
  DateTime _dateTime;
  var myFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadCustomerBookings();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Bookings'),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              MdiIcons.calendar,
              size: 27,
              color: Colors.grey[850],
            ),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                firstDate: DateTime(2020, 12),
                lastDate: DateTime(2021, 8),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                        //  primarySwatch: buttonTextColor,//OK/Cancel button text color
                        primaryColor: const Color(0xFF4A5BF6), //Head background
                        accentColor: const Color(0xFF4A5BF6) //selection color
                        //dialogBackgroundColor: Colors.white,//Background color
                        ),
                    child: child,
                  );
                },
              ).then((date) {
                setState(() {
                  _dateTime = date;
                  _sortCBookingsbyCalendar(myFormat.format(_dateTime));
                  print(_dateTime);
                });
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(children: <Widget>[
          Card(
            color: Colors.grey[100],
            elevation: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 230.0,
                    height: 35,
                    child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        autofocus: false,
                        controller: _prdController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic),
                            icon: Icon(Icons.search),
                            labelText: "Search by Keywords",
                            border: OutlineInputBorder())),
                  ),
                  SizedBox(width: 40),
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    color: Colors.blue[400],
                    textColor: Colors.black,
                    onPressed: () => {
                      _sortCBookingsbyBookId(_prdController.text),
                      _sortCBookingsbyBillId(_prdController.text),
                      _sortCBookingsbyStartDate(_prdController.text),
                      _sortCBookingsbyStartTime(_prdController.text),
                      _sortCBookingsbyEndTime(_prdController.text)
                    },
                    child: Text("Search",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(curtype,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 5),
          // Text(
          //   "Payment History",
          //   style: TextStyle(
          //        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          //  ),
          _customerdata == null
              ? Flexible(
                  child: Container(
                      color: Colors.white,
                      child: Center(
                          child: Column(children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 200, 10, 10),
                            child: Image.asset(
                              'assets/images/sad.png',
                              height: 150,
                              width: 100,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          titlecenter = "No Customer Bookings Yet",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )
                      ]))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _customerdata == null ? 0 : _customerdata.length,
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
                                        width: 10,
                                      ),
                                      //  Text(
                                      //     (index + 1).toString() + ".",
                                      //    style: TextStyle(
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 16,
                                      //        color: Colors.black),
                                      //  ),
                                      //   SizedBox(width: 16),
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
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    _customerdata[index]
                                                        ['userid'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Booked for " +
                                                        _customerdata[index]
                                                            ['startdate'] +
                                                        "  " +
                                                        _customerdata[index]
                                                            ['starttime'] +
                                                        "-" +
                                                        _customerdata[index]
                                                            ['endtime'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  Icon(Icons.arrow_forward_ios)
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Booking ID: " +
                                                    _customerdata[index]
                                                        ['bookid'],
                                                style: TextStyle(
                                                    //fontWeight: FontWeight.w900,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Bill No. " +
                                                        _customerdata[index]
                                                            ['billid'],
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w900,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "Placed on " +
                                                        convertDateTimeDisplay(
                                                            _customerdata[index]
                                                                ['date']),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                label: "New Customer Booking",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                labelBackgroundColor: Colors.white,
                onTap: createNewBooking),
          ],
        ),
    );
  }

   Future<void> createNewBooking() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
           builder: (BuildContext context) => NewCustomerBooking(
        
        )));
    _loadCustomerBookings();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('MMMM d, yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future<void> _loadCustomerBookings() async {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    await http.post(urlLoadCustomerBookings, body: {
      // "email": widget.user.email
    }).then((res) {
      print(res.body);
      if (res.body != "nodata") {
        setState(() {
          var extractdata = json.decode(res.body);
          _customerdata = extractdata["bookings"];
        });
      }
    }).catchError((err) {
      print(err);
      Toast.show("No customer bookings found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //pr.dismiss();
      FocusScope.of(context).requestFocus(new FocusNode());
      return;
    });
  }

  void _sortCBookingsbyCalendar(String startdate) {
    try {
      String urlLoadCustomerBookings =
          server + "/php/load_customerbookings.php";
      http.post(urlLoadCustomerBookings, body: {
        "startdate": startdate.toString(),
      }).then((res) {
        setState(() {
          if (res.body == "nodata") {
            Toast.show("No booking packages found", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            FocusScope.of(context).requestFocus(new FocusNode());
            return;
            // packagedata = null;
            //titlecenter = "No packages found";
            // titletop = "Carian menjumpai sebarang produk";
            //  curtype = type1;
            //
            //pr.dismiss();
          } else {
            var extractdata = json.decode(res.body);
            _customerdata = extractdata["bookings"];
            FocusScope.of(context).requestFocus(new FocusNode());
            curtype = "Search for " + "'" + startdate + "'";
          }
        });
      }).catchError((err) {
        print(err);
      });
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortCBookingsbyBookId(String pradd1) {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    http
        .post(urlLoadCustomerBookings, body: {
          "bookid": pradd1.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              _customerdata = extractdata["bookings"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = "Search for " + "'" + pradd1 + "'";
            });
          }
        })
        .catchError((err) {
          Toast.show("Not relevant information found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        });
  }

  void _sortCBookingsbyBillId(String pradd2) {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    http
        .post(urlLoadCustomerBookings, body: {
          "billid": pradd2.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              _customerdata = extractdata["bookings"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = "Search for " + "'" + pradd2 + "'";
            });
          }
        })
        .catchError((err) {
          Toast.show("Not relevant information found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        });
  }

  void _sortCBookingsbyStartDate(String pradd3) {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    http
        .post(urlLoadCustomerBookings, body: {
          "startdate": pradd3.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              _customerdata = extractdata["bookings"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = "Search for " + "'" + pradd3 + "'";
            });
          }
        })
        .catchError((err) {
          Toast.show("Not relevant information found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        });
  }

  void _sortCBookingsbyStartTime(String pradd4) {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    http
        .post(urlLoadCustomerBookings, body: {
          "starttime": pradd4.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              _customerdata = extractdata["bookings"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = "Search for " + "'" + pradd4 + "'";
            });
          }
        })
        .catchError((err) {
          Toast.show("Not relevant information found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        });
  }

  void _sortCBookingsbyEndTime(String pradd5) {
    String urlLoadCustomerBookings = server + "/php/load_customerbookings.php";
    http
        .post(urlLoadCustomerBookings, body: {
          "endtime": pradd5.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              _customerdata = extractdata["bookings"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = "Search for " + "'" + pradd5 + "'";
            });
          }
        })
        .catchError((err) {
          Toast.show("Not relevant information found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        });
  }

  loadBookDetails(int index) {
    Book book = new Book(
        billid: _customerdata[index]['billid'],
        bookid: _customerdata[index]['bookid'],
        total: _customerdata[index]['total'],
        startdate: _customerdata[index]['startdate'],
        starttime: _customerdata[index]['starttime'],
        endtime: _customerdata[index]['endtime'],
        packageprice: _customerdata[index]['packageprice'],
        quantity: _customerdata[index]['quantity'],
        userid: _customerdata[index]['userid'],
        username: _customerdata[index]['username'],
        checkedin: _customerdata[index]['checkedin'],
        wallet: _customerdata[index]['wallet'],
        tpprice: _customerdata[index]['tpprice'],
        date: _customerdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CustomerBookingDetailsScreen(
              book:book,
            )));
  }
}
