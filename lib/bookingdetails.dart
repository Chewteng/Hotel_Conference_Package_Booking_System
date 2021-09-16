import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book.dart';
import 'package:http/http.dart' as http;

class BookingDetailsScreen extends StatefulWidget {
  final Book book;

  const BookingDetailsScreen({Key key, this.book}) : super(key: key);
  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  List _bookdetails;
  String titlecenter = "Loading booking details...";
  double screenHeight, screenWidth;
  String server = "https://yitengsze.com/hcpbs";
  //int downpayment = 0;
  // int unitSelected;
  //double servicecharge;

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final formatter = new NumberFormat("#,###");
    //final f = new DateFormat('yMd');

    return Scaffold(
      appBar: AppBar(
        title: Text('Package Booking Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          // Text(
          //    "Booking Details",
          //      style: TextStyle(
          //         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          SizedBox(
            height: 5,
          ),
          Card(
            //color: Colors.grey[200],
            child: Column(children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Booking ID :   ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.book.bookid,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      )),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Paid on " + widget.book.date,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  )),
              SizedBox(
                height: 10,
              ),
            ]),
          ),

          _bookdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _bookdetails == null ? 0 : _bookdetails.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _bookdetails.length) {
                          return Container(
                              decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Colors.grey[200],
                                        Colors.grey[400]
                                      ]),
                                  border: new Border.all(
                                      color: Colors.white, width: 3.50),
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              child: Card(
                                color: Colors.grey[200],
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(35, 0, 50, 0),
                                      child: Table(
                                          defaultColumnWidth:
                                              FlexColumnWidth(1.0),
                                          columnWidths: {
                                            0: FlexColumnWidth(5),
                                            1: FlexColumnWidth(3),
                                          },
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Store Wallet Used ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM " + widget.book.wallet,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Total Payment ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM " + widget.book.total,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 25,
                                                    child: Text(
                                                        "Total Package Price ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 25,
                                                  child: Text(
                                                      "RM " + int.parse(widget.book.tpprice).toStringAsFixed(
                                                                    2) ??
                                                        "0.0",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                          ]),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ));
                        }

                        index -= 0;
                        return Container(
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.grey[200],
                                      Colors.grey[400]
                                    ]),
                                border: new Border.all(
                                    color: Colors.white, width: 3.50),
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                elevation: 10,
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(children: <Widget>[
                                      Text(
                                        (index + 1).toString() + ".",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            height: screenWidth / 3,
                                            width: screenWidth / 3,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[400],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "http://yitengsze.com/hcpbs/conferenceimage/${_bookdetails[index]['id']}.jpg?"),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            _bookdetails[index]['id'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          child: Container(
                                        height: screenWidth / 4,
                                        color: Colors.grey,
                                      )),
                                      Container(
                                          width: screenWidth / 1.8,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _bookdetails[index]
                                                              ['packagetype'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(height:3),
                                                    Text(
                                                      _bookdetails[index]
                                                              ['startdate'] +
                                                          "  " +
                                                          _bookdetails[index]
                                                              ['starttime'] +
                                                          " - " +
                                                          _bookdetails[index]
                                                              ['endtime'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(height:6),
                                                    Text(
                                                      _bookdetails[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "RM " +
                                                          (formatter.format(
                                                              double.parse(
                                                                  _bookdetails[
                                                                          index]
                                                                      [
                                                                      'price']))),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        height: 1.5,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "x" +
                                                              _bookdetails[
                                                                      index]
                                                                  ['pquantity'],
                                                          style: TextStyle(
                                                            height: 2.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    ]))));
                      }))
        ]),
      ),
    );
  }

  _loadBookDetails() async {
    //  downpayment = 0;
    //  unitSelected = 0;
    String urlLoadBookDetails = server + "/php/load_bookinghistory.php";
    await http.post(urlLoadBookDetails, body: {
      "bookid": widget.book.bookid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _bookdetails = null;
          titlecenter = "No Any Payment Made";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _bookdetails = extractdata["bookhistory"];

          // servicecharge = double.parse(widget.book.total) - downpayment;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
