import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_booking/book.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class CustomerBookingDetailsScreen extends StatefulWidget {
  final Book book;
  const CustomerBookingDetailsScreen({Key key, this.book}) : super(key: key);
  @override
  _CustomerBookingDetailsScreenState createState() =>
      _CustomerBookingDetailsScreenState();
}

class _CustomerBookingDetailsScreenState
    extends State<CustomerBookingDetailsScreen> {
  List _bookdetails;
  String titlecenter = "Loading customer booking details...";
  double screenHeight, screenWidth;
  String server = "https://yitengsze.com/hcpbs";
  String selectedOption;
  List<String> listType = [
    "Yes",
    "No",
  ];

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
    selectedOption = widget.book.checkedin;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final formatter = new NumberFormat("#,###");
    //final f = new DateFormat('yMd');

    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Booking Details'),
        ),
        body: Center(
          child: Container(
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
                color: Colors.grey[200],
                margin: EdgeInsets.fromLTRB(5, 2, 0, 2),
                //color: Colors.grey[200],
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.book.username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.book.userid,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      )),
                  SizedBox(
                    height: 3,
                  ),
                ]),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 2, 8, 2),
                // //color: Colors.grey[200],
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Booking ID ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              widget.book.bookid,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Booked For ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            widget.book.startdate +
                                " " +
                                widget.book.starttime +
                                " - " +
                                widget.book.endtime,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text("Checked In",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      SizedBox(width: 125),
                      Flexible(
                        child: Container(
                          height: 45,
                          child: DropdownButton(
                            isExpanded: true,
                            //sorting dropdownoption
                            hint: Text(
                              'Checked In',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            value: selectedOption,
                            onChanged: (newValue) {
                              setState(() {
                                selectedOption = newValue;
                                print(selectedOption);
                              });
                            },
                            items: listType.map((selectedOption) {
                              return DropdownMenuItem(
                                value: selectedOption,

                                // fit: BoxFit.contain,
                                // width: 200.0,
                                child: new Text(selectedOption,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                //  fit: BoxFit.fitWidth,
                              );
                            }).toList(),
                          ),
                          width: 80.0,
                        ),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                        textColor: Colors.white,
                        padding: EdgeInsets.all(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.lightBlue[200],
                                Colors.blueAccent,
                              ],
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 8.0),
                        ),
                        onPressed: () {
                          updateStatusDialog();
                          print('Check-in button is clicked');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Bill No. ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            widget.book.billid,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Paid On " + widget.book.date,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
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
                          itemCount: _bookdetails == null
                              ? 0
                              : _bookdetails.length + 1,
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 25,
                                                        child: Text(
                                                            "Store Wallet Used ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 25,
                                                      child: Text(
                                                          "RM " +
                                                              widget
                                                                  .book.wallet,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 25,
                                                        child: Text(
                                                            "Total Payment ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 25,
                                                      child: Text(
                                                          "RM " +
                                                              widget.book.total,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 25,
                                                        child: Text(
                                                            "Total Package Price ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 25,
                                                      child: Text(
                                                          "RM " +
                                                                  int.parse(widget
                                                                          .book
                                                                          .tpprice)
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
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
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                          "http://yitengsze.com/hcpbs/conferenceimage/${_bookdetails[index]['packageid']}.jpg?"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                _bookdetails[index]
                                                    ['packageid'],
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
                                                          MainAxisAlignment
                                                              .start,
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
                                                        Text(
                                                          _bookdetails[index][
                                                                  'startdate'] +
                                                              "  " +
                                                              _bookdetails[
                                                                      index][
                                                                  'starttime'] +
                                                              " - " +
                                                              _bookdetails[
                                                                      index]
                                                                  ['endtime'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        Text(
                                                          _bookdetails[index]
                                                              ['hotelname'],
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
                                                                      [
                                                                      'pquantity'],
                                                              style: TextStyle(
                                                                height: 2.0,
                                                                color: Colors
                                                                    .black,
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
        ));
  }

  _loadBookDetails() async {
    //  downpayment = 0;
    //  unitSelected = 0;
    String urlLoadBookDetails =
        server + "/php/load_customerbookingshistory.php";
    await http.post(urlLoadBookDetails, body: {
      "startdate": widget.book.startdate,
      // "starttime": widget.book.starttime,
      // "endtime": widget.book.endtime,
      "bookid": widget.book.bookid,
      // "date": widget.book.date,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _bookdetails = null;
          titlecenter = "No Any Customer Booking Yet";
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

  updateStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Status Checked In?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
              onPressed: () {
                updateStatus();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateStatus() {
    http.post(server + "/php/checked_in.php", body: {
      "bookid": widget.book.bookid,
      "startdate": widget.book.startdate,
      "checkedin": selectedOption,
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show("Updated status checked in", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Updated failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
