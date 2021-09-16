import 'dart:convert';
import 'package:hotel_booking/MyPdfFile.dart';
import 'package:hotel_booking/mainscreen.dart';
//import 'package:hotel_booking/manualpayment.dart';
import 'package:hotel_booking/payment.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavScreen extends StatefulWidget {
  final User user;

  const FavScreen({Key key, this.user}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List favData;
  double screenHeight, screenWidth;
  //bool _isabellaService = true;
  bool _storeCredit = false;
  //bool _jeffreryService = false;
  //bool _lunaService = false;
  double _totalprice = 0.0;
  // int downpayment = 0;
  int unitSelected;
  // double servicecharge;
  double amountpayable;

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final formatter = new NumberFormat("#,###");
    //final f = new DateFormat('yMd');

    return Scaffold(
        appBar: AppBar(title: Text('My Saved Package'), actions: <Widget>[
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue[500],
            child: IconButton(
              icon: Icon(MdiIcons.deleteEmptyOutline),
              color: Colors.black,
              onPressed: () {
                deleteAll();
              },
            ),
          ),
        ]),
        body: Container(
            child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          // Text(
          //    "Content of saved package",
          //    style: TextStyle(
          //        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          favData == null
              ? Flexible(
                  child: Container(
                      child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 150, 10, 10),
                          child: Image.asset(
                            'assets/images/saved.jpg',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "No saved package shortlisted yet!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Save an available package by tapping on the love icon",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      // SizedBox(height: 2),
                      // Text(
                      //   "icon that locates at the bottom right ",
                      //   style: TextStyle(color: Colors.black, fontSize: 16),
                      // ),
                      // Text(
                      //   " of every package.",
                      //   style: TextStyle(color: Colors.black, fontSize: 16),
                      // ),
                    ],
                  ),
                )))
              : Expanded(
                  child: ListView.builder(
                      itemCount: favData == null ? 1 : favData.length + 1,
                      itemBuilder: (context, index) {
                        if (index == favData.length) {
                          return Container(
                              decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                      colors: [Colors.grey[200], Colors.grey]),
                                  border: new Border.all(
                                      color: Colors.white, width: 3.50),
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              child: Card(
                                color: Colors.grey[200],
                                //  alignment: Alignment.bottomCenter,
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Pre-Book Conference Package Payment",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    SizedBox(height: 15),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 50, 0),
                                        //color: Colors.red,
                                        child: Table(
                                            defaultColumnWidth:
                                                FlexColumnWidth(1.0),
                                            columnWidths: {
                                              0: FlexColumnWidth(8),
                                              1: FlexColumnWidth(4),
                                            },
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "Total Package Price ",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                        "RM " +
                                                                _totalprice
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.0",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "Store Credit - RM " +
                                                              widget
                                                                  .user.credit,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Checkbox(
                                                      checkColor: Colors.blue[
                                                          400], // color of tick Mark
                                                      activeColor:
                                                          Colors.blue[400],
                                                      value: _storeCredit,
                                                      onChanged: (bool value) {
                                                        _onStoreCredit(value);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
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
                                                    height: 30,
                                                    child: Text(
                                                        "RM " +
                                                                amountpayable
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.0",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ]),
                                            ])),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Center(
                                          child: RaisedButton(
                                            textColor: Colors.white,
                                            padding: EdgeInsets.all(2.0),
                                            shape: StadiumBorder(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.lightBlue[100],
                                                    Colors.lightBlueAccent,
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                'Manual Payment',
                                                style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 39.0,
                                                  vertical: 13.0),
                                            ),
                                            onPressed: () {
                                              manualPayment();
                                              print(
                                                  'Manual Payment button is clicked');
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: RaisedButton(
                                            textColor: Colors.white,
                                            padding: EdgeInsets.all(2.0),
                                            shape: StadiumBorder(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.blue[200],
                                                    Colors.blueAccent,
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                'Online Payment',
                                                style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 39.0,
                                                  vertical: 13.0),
                                            ),
                                            onPressed: () {
                                              onlinePayment();
                                              print(
                                                  'Online Payment button is clicked');
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        }

                        index -= 0;
                        return Container(
                            //shape: RoundedRectangleBorder(
                            //    borderRadius:
                            //         BorderRadius.all(Radius.circular(20.0))),
                            //  elevation: 10,
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(children: <Widget>[
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
                                                  "http://yitengsze.com/hcpbs/conferenceimage/${favData[index]['id']}.jpg?"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                          favData[index]['id'] +
                                              " - " +
                                              "RM " +
                                              (formatter.format(double.parse(
                                                  favData[index]['price']))),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                                      child: SizedBox(
                                          //width: 4,
                                          child: Container(
                                        height: screenWidth / 2.5,
                                        color: Colors.grey,
                                      ))),
                                  Container(
                                      width: screenWidth / 1.8,
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  favData[index]
                                                          ['packagetype'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                 
                                                          favData[index]
                                                              ['startdate'] +
                                                      " " + favData[index]
                                                              ['starttime'] +
                                                      " - " +
                                                      favData[index]['endtime'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                // SizedBox(height:5),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        favData[index]
                                                                ['quantity'] +
                                                            " unit",
                                                        style: TextStyle(
                                                          height: 2.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        " Left",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 2.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ]),
                                                SizedBox(height: 5),
                                                Container(
                                                    height: 20,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          onPressed: () => {
                                                            _updateFav(
                                                                index, "add")
                                                          },
                                                          child: Icon(
                                                            MdiIcons.plus,
                                                            color: Colors
                                                                .blue[400],
                                                          ),
                                                        ),
                                                        Text(
                                                          favData[index]
                                                              ['pquantity'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () => {
                                                            _updateFav(
                                                                index, "remove")
                                                          },
                                                          child: Icon(
                                                            MdiIcons.minus,
                                                            color: Colors
                                                                .blue[400],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                        "Total RM " +
                                                            (formatter.format(double
                                                                .parse(favData[
                                                                        index][
                                                                    'yourprice']))),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black)),
                                                    Spacer(),
                                                    FlatButton(
                                                      onPressed: () =>
                                                          {_deleteFav(index)},
                                                      child: Icon(
                                                        MdiIcons.delete,
                                                        color: Colors.blue[400],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ])));
                      }),
                )
        ])));
  }

  void _loadFav() {
    _totalprice = 0.0;
    unitSelected = 0;
    amountpayable = 0.0;
    //servicecharge = 0.0;

    String urlLoadFav = "https://yitengsze.com/hcpbs/php/load_fav.php";
    http.post(urlLoadFav, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      NumberFormat format = NumberFormat("#,###");

      if (res.body == "Favourite List Empty") {
        //Navigator.of(context).pop(false);
        Toast.show("Saved Package List Empty", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        favData = extractdata["favourite"];
        for (int i = 0; i < favData.length; i++) {
          unitSelected = int.parse(favData[i]['pquantity']) + unitSelected;
          _totalprice = double.parse(favData[i]['yourprice']) + _totalprice;
        }

        amountpayable = _totalprice;
        print(format.format(_totalprice));
      });
      Toast.show("Updated package list successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((err) {
      print(err);
    });
  }

  _updateFav(int index, String op) {
    int curquantity = int.parse(favData[index]['quantity']);
    int quantity = int.parse(favData[index]['pquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > curquantity) {
        Toast.show("Sold Out", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteFav(index);
        return;
      }
    }
    String urlUpdateFav = "https://yitengsze.com/hcpbs/php/update_fav.php";
    http.post(urlUpdateFav, body: {
      "email": widget.user.email,
      "packageid": favData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("List Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadFav();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteFav(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        //backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Remove ' + favData[index]['id'] + ' from favourite list?',
          style: TextStyle(
            //fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://yitengsze.com/hcpbs/php/delete_fav.php",
                    body: {
                      "email": widget.user.email,
                      "packageid": favData[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadFav();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              )),
        ],
      ),
    );
  }

  void _onStoreCredit(bool newValue) => setState(() {
        _storeCredit = newValue;
        if (_storeCredit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _updatePayment() {
    // downpayment = 0;
    unitSelected = 0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    setState(() {
      for (int i = 0; i < favData.length; i++) {
        _totalprice = double.parse(favData[i]['yourprice']) + _totalprice;
        unitSelected = int.parse(favData[i]['pquantity']) + unitSelected;
        // downpayment = unitSelected * 200;
      }

      //amountpayable = servicecharge;
      if (_storeCredit) {
        amountpayable = _totalprice - double.parse(widget.user.credit);
      } else {
        amountpayable = _totalprice;
      }
      print(_storeCredit);
      print(_totalprice);
    });
  }

  void onlinePayment() {
    if (widget.user.email == "admin@cphotelbooking.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "staff@cphotelbooking.com") {
      Toast.show("Staff Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
       title: new Text(
            "Online Payment?",
            style: TextStyle(
              color: Colors.black,fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
              )),
        ],
      ),
    );
  }

void manualPayment() {
    if (widget.user.email == "admin@cphotelbooking.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "staff@cphotelbooking.com") {
      Toast.show("Staff Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Manual Payment?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.blue[600],fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyPdf()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.blue[300],fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
               // Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePayment() async {
    if (amountpayable < 0) {
      double newamount = amountpayable * -1;
      print(amountpayable);
      print(newamount);
      await _payusingstorecredit(newamount);
      _loadFav();
      return;
    }

   // var now = new DateTime.now();
    //var formatter = new DateFormat('ddMMyyyyhms');
    String bookid = randomAlphaNumeric(10);
    print(bookid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: amountpayable.toStringAsFixed(2),
                  bookid: bookid,
                )));
    _loadFav();
  }

  String generateBookingID() {
   // var now = new DateTime.now();
   // var formatter = new DateFormat('ddMMyyyyhms');
    String bookid = randomAlphaNumeric(10);
    return bookid;
  }

  Future<void> _payusingstorecredit(double newamount) async {
    //insert carthistory
    //remove cart content
    //update product quantity
    //update credit in user
    var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String updateamount = newamount.toStringAsFixed(2);
    Toast.show("Updating Package List", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    String urlPayment = "https://yitengsze.com/hcpbs/php/paymentwallet.php";
    await http.post(urlPayment, body: {
      "userid": widget.user.email,
      "username": widget.user.name,
      "amount": _totalprice.toStringAsFixed(2),
      "bookid": generateBookingID(),
      "newcr": updateamount,
      "date": formatter.format(now)
    }).then((res) {
      print(res.body);
      if (res.body == "Success pay with store wallet") {
        print("Success pay with store wallet.");
        setState(() {
          widget.user.credit = updateamount;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text('Are you sure?',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        content: new Text('Delete all saved packages?',
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://yitengsze.com/hcpbs/php/delete_fav.php",
                    body: {
                      "email": widget.user.email,
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadFav();
                  } else {
                    Toast.show("Failed to delete house", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              )),
        ],
      ),
    );
  }
}
