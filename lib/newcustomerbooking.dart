import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewCustomerBooking extends StatefulWidget {
  @override
  _NewCustomerBookingState createState() => _NewCustomerBookingState();
}

class _NewCustomerBookingState extends State<NewCustomerBooking> {
  final double padding = 10.0;
  TextEditingController idEditingController = new TextEditingController();
  TextEditingController quantityEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController nameEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  String server = "https://yitengsze.com/hcpbs";
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final maxLines = 5;
  DateTime pickedDate;
  var df = DateFormat("h:mma");
  String email;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Customer Booking'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(padding * 1.5),
          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                new Image.asset(
                  'assets/images/cusbooking.png',
                  width: 350.0,
                  height: 250.0,
                ),
                SizedBox(height: 30),
                Container(
                    width: screenWidth / 1.1,
                    //height: screenHeight / 2,

                    child: Column(
                      children: <Widget>[
                        Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            columnWidths: {
                              0: FlexColumnWidth(3.0),
                              1: FlexColumnWidth(5.0),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 45,
                                      child: Text("Book Package ID",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 65,
                                    child: TextFormField(
                                      maxLength: 4,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      controller: idEditingController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus0);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(5),
                                        fillColor: Colors.black,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),

                                        //fillColor: Colors.green
                                      ),
                                      validator: validateID,
                                      // maxLength: 4,
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 45,
                                      child: Text("Book Quantity",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 45,
                                    child: TextFormField(
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: quantityEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus0,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus1);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(5),
                                          fillColor: Colors.black,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 60,
                                      child: Text("Email Address",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: maxLines * 12.0,
                                    child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        maxLines: maxLines,
                                        controller: emailEditingController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus1,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus2);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(5),
                                          fillColor: Colors.black,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 45,
                                      child: Text("Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 45,
                                    child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus2,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus3);
                                        },
                                        decoration: new InputDecoration(
                                          fillColor: Colors.black,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          //fillColor: Colors.green
                                        )),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      child: Text("Payment Date",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                      height: 60,
                                      child: Container(
                                        child: ListTile(
                                          title: Text(
                                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"),
                                          trailing: Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                          ),
                                          onTap: _pickDate,
                                        ),
                                      )),
                                ),
                              ]),
                            ]),
                        SizedBox(height: 8),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          minWidth: screenWidth / 1.9,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                MdiIcons.upload,
                                color: Colors.black,
                                size: 25,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Insert New Booking",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: 30),
                            ],
                          ),
                          color: Colors.blue[400],
                          textColor: Colors.black,
                          elevation: 5,
                          onPressed: _insertNewHouse,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateID(String value) {
    //RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please insert package ID';
    } else if (value.length > 5) {
      return 'Must be not more than 5 charater';
    }
    return null;
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
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
    );
    if (date != null)
      setState(() {
        pickedDate = date;
        // convertDateTimeDisplay(pickedDate.toString());
        print(date);
      });
  }

  void _insertNewHouse() {
    email = emailEditingController.text;

    if (idEditingController.text.length < 3) {
      Toast.show("Booking package ID incomplete", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (idEditingController.text.length > 4) {
      Toast.show("Please enter package ID with 4 numbers only", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (quantityEditingController.text.length < 1) {
      Toast.show("Please enter his/her booking quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (emailEditingController.text.length < 1) {
      Toast.show("Please enter email address of person in charge", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (!_isEmailValid(email)) {
      Toast.show("Please enter email address correctly", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (nameEditingController.text.length < 1) {
      Toast.show("Please enter name of person in charge", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (pickedDate == null) {
      Toast.show("Please choose his/her payment date", context,
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
            "Insert New Customer Booking",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                Navigator.of(context).pop();

                insertHouse();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
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

  bool _isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  insertHouse() {
    http.post(server + "/php/insert_customerbookings.php", body: {
      "packageid": idEditingController.text,
      "username": nameEditingController.text,
      "userid": emailEditingController.text,
      "pquantity": quantityEditingController.text,
      "date": convertDateTimeDisplay(pickedDate.toString()),
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        print("Insert Successfully.");
        Toast.show("Insert new customer booking successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        print("Insert Failed.");
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
