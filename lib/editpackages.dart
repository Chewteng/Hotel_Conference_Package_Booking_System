import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotel_booking/mainscreen.dart';
import 'package:hotel_booking/package.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class EditPackages extends StatefulWidget {
  final User user;
  final Package package;

  const EditPackages({Key key, this.user, this.package}) : super(key: key);

  @override
  _EditPackagesState createState() => _EditPackagesState();
}

class _EditPackagesState extends State<EditPackages> {
  String server = "https://yitengsze.com/hcpbs";
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController addressEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController startdateEditingController =
      new TextEditingController();
  TextEditingController starttimeEditingController =
      new TextEditingController();
  TextEditingController endtimeEditingController = new TextEditingController();
  TextEditingController areaEditingController = new TextEditingController();
  TextEditingController descEditingController = new TextEditingController();
  TextEditingController latEditingController = new TextEditingController();
  TextEditingController logEditingController = new TextEditingController();
  TextEditingController urlEditingController = new TextEditingController();
  //TextEditingController contactEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  final maxLines = 5;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();
  final focus8 = FocusNode();
  final focus9 = FocusNode();
  final focus10 = FocusNode();
  final focus11 = FocusNode();
  //final focus12 = FocusNode();
  static File newImageFile;
  static bool changedImage = false;
  String selectedType;
  String selectedPackageType;
  //String selectedNightStay;
  File _image;
  bool _takepicture = true;
  //bool _takepicturelocal = false;
  List<String> listType = [
    "Auditorium",
    "Classroom",
    "U-Shape",
    "Banquet",
    "Hollow Square",
    "Others",
  ];
  List<String> listPType = [
    "Full Day Meeting Package",
    "Half Day Meeting Package A",
    "Half Day Meeting Package B"
  ];
  List<String> listNStay = [
    "Yes",
    "No",
  ];

  @override
  void initState() {
    super.initState();
    print("In Update Package Details");
    nameEditingController.text = widget.package.name;
    addressEditingController.text = widget.package.address;
    priceEditingController.text = widget.package.price;
    qtyEditingController.text = widget.package.quantity;
    selectedPackageType = widget.package.packagetype;
    startdateEditingController.text = widget.package.startdate;
    starttimeEditingController.text = widget.package.starttime;
    endtimeEditingController.text = widget.package.endtime;
    areaEditingController.text = widget.package.area;
    selectedType = widget.package.type;
    descEditingController.text = widget.package.description;
    //selectedNightStay = widget.package.nightstay;
    latEditingController.text = widget.package.latitude;
    logEditingController.text = widget.package.longitude;
    //contactEditingController.text = widget.package.contact;
    urlEditingController.text = widget.package.url;
   // selectedType = widget.package.type;
    //selectedPackageType = widget.package.packagetype;
    //selectedNightStay = widget.package.nightstay;
  }

  @override
  Widget build(BuildContext context) {
   // imageCache.clearLiveImages();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Package Details'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(
                          user: widget.user,
                        )));
              }),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                onTap: () => {_choose()},
                child: Column(children: [
                  Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.2,
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: changedImage
                                ? FileImage(newImageFile)
                                : CachedNetworkImageProvider(
                                    server +
                                        "/conferenceimage/${widget.package.id}.jpg?",
                                  ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )),
                ])),
            SizedBox(height: 6),
            Text("Click the above image to replace picture of conference room",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
                width: screenWidth / 1.1,
                //height: screenHeight / 2,

                child: Column(
                  children: <Widget>[
                    Table(
                        defaultColumnWidth: FlexColumnWidth(2.0),
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
                                  child: Text("Package ID",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ))),
                            ),
                            TableCell(
                                child: Container(
                              height: 45,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text(
                                    " " + widget.package.id,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )),
                            )),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text("Hotel Name",
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
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    maxLines: maxLines,
                                    controller: nameEditingController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus0);
                                    },
                                    decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      fillColor: Colors.black,
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    )),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 70,
                                  child: Text("Hotel Address",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: maxLines * 14.0,
                                child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      //height: 30.0,
                                    ),
                                    maxLines: maxLines,
                                    controller: addressEditingController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus0,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus1);
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
                                    )),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text("Package Price (RM)",
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
                                    controller: priceEditingController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus1,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus2);
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
                                  child: Text("Quantity Available (Unit)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 50,
                                child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    controller: qtyEditingController,
                                    keyboardType: TextInputType.number,
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
                                  child: Text("Conference Room Setup",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 50,
                                child: Center(
                                  //height: 40,
                                  child: DropdownButton(
                                    isExpanded: true,

                                    //sorting dropdownoption
                                    hint: Text(
                                      'Conference Room Type',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue[400]),
                                    ), // Not necessary for Option 1
                                    value: selectedType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedType = newValue;
                                        print(selectedType);
                                      });
                                    },
                                    items: listType.map((selectedType) {
                                      return DropdownMenuItem(
                                        child: new Text(selectedType,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        value: selectedType,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text("Package Type",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 45,
                                child: Container(
                                  height: 45,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    //sorting dropdownoption
                                    hint: Text(
                                      'Package Type',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue[400]),
                                    ), // Not necessary for Option 1
                                    value: selectedPackageType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedPackageType = newValue;
                                        print(selectedPackageType);
                                      });
                                    },
                                    items: listPType.map((selectedPackageType) {
                                      return DropdownMenuItem(
                                        value: selectedPackageType,

                                        // fit: BoxFit.contain,
                                        // width: 200.0,
                                        child: new Text(selectedPackageType,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        //  fit: BoxFit.fitWidth,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text("Package Issued Date",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: startdateEditingController,
                                    keyboardType: TextInputType.datetime,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus3,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus4);
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
                                  height: 45,
                                  child: Text("Package Start Time",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: starttimeEditingController,
                                    keyboardType: TextInputType.datetime,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus4,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus5);
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
                                  height: 45,
                                  child: Text("Package End Time",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: endtimeEditingController,
                                    keyboardType: TextInputType.datetime,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus5,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus6);
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
                                  height: 45,
                                  child: Text("Area (Sqm) of Conference Room",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: areaEditingController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus6,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus7);
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
                                  height: 120,
                                  child: Text("Hotel Description",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: maxLines * 24.0,
                                child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    controller: descEditingController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: maxLines,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus7,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus8);
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
                                    )),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  child: Text("Address Latitude",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: latEditingController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus8,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus9);
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
                                  height: 45,
                                  child: Text("Address Longitude",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
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
                                    controller: logEditingController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus9,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus10);
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
                                  height: 60,
                                  child: Text("Hotel Package URL",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ))),
                            ),
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: maxLines * 10.0,
                                child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    controller: urlEditingController,
                                    keyboardType: TextInputType.url,
                                    maxLines: maxLines,
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus10,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus11);
                                    },
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(5),
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
                        ]),
                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minWidth: screenWidth / 1.9,
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Update Package Details",
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
                      elevation: 2,
                      onPressed: () => updateHouseDialog(),
                    ),
                  ],
                )),
          ],
        )),
      ),
    );
  }

  updateHouseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Package ID " + widget.package.id,
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
                Navigator.of(context).pop();
                updateHouse();
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

  updateHouse() {
    if (nameEditingController.text.length < 1) {
      Toast.show("Please enter hotel name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter available package quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (addressEditingController.text.length < 1) {
      Toast.show("Please enter hotel address", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter package price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (areaEditingController.text.length < 1) {
      Toast.show("Please enter area of conference room", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (startdateEditingController.text.length < 1) {
      Toast.show("Please enter package issued date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (starttimeEditingController.text.length < 1) {
      Toast.show("Please enter package start time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (endtimeEditingController.text.length < 1) {
      Toast.show("Please enter package end time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (descEditingController.text.length < 1) {
      Toast.show("Please enter hotel brief description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (latEditingController.text.length < 1) {
      Toast.show("Please enter hotel address latitude", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (logEditingController.text.length < 1) {
      Toast.show("Please enter hotel address longitude", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (urlEditingController.text.length < 1) {
      Toast.show("Please enter hotel package url", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (selectedType == null) {
      Toast.show("Please choose conference room setup", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (selectedPackageType == null) {
      Toast.show("Please choose package type", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());

      http.post(server + "/php/update_package.php", body: {
        "id": widget.package.id,
        "name": nameEditingController.text,
        "address": addressEditingController.text,
        "quantity": qtyEditingController.text,
        "price": priceEditingController.text,
        "packagetype": selectedPackageType,
        "startdate": startdateEditingController.text,
        "starttime": starttimeEditingController.text,
        "endtime": endtimeEditingController.text,
        "type": selectedType,
        "area": areaEditingController.text,
        "description": descEditingController.text,
        //"nightstay": selectedNightStay,
        "latitude": latEditingController.text,
        "longitude": logEditingController.text,
        "url": urlEditingController.text,
       // "contact": contactEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);

        if (res.body == "success") {
          print("Updated package details successfully");
          Toast.show("Updated package details successfully", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Updated failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      http.post(server + "/php/update_package.php", body: {
        "id": widget.package.id,
        "name": nameEditingController.text,
        "address": addressEditingController.text,
        "quantity": qtyEditingController.text,
        "price": priceEditingController.text,
        "packagetype": selectedPackageType,
        "startdate": startdateEditingController.text,
        "starttime": starttimeEditingController.text,
        "endtime": endtimeEditingController.text,
        "type": selectedType,
        "area": areaEditingController.text,
        "description": descEditingController.text,
        //"nightstay": selectedNightStay,
        "latitude": latEditingController.text,
        "longitude": logEditingController.text,
        "url": urlEditingController.text,
     //   "contact": contactEditingController.text,
      }).then((res) {
        print(res.body);

        if (res.body == "success") {
          Toast.show("Updated package details successfully", context,
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

  void _choose() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    if (_image != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  "Upload New Conference Image?",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                          color: Colors.blue[600], fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      uploadImage(image);
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text(
                      "No",
                      style: TextStyle(
                          color: Colors.blue[400], fontWeight: FontWeight.w700),
                    ),
                    onPressed: () => {Navigator.of(context).pop()},
                  ),
                ]);
          });
    }
  }

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(server + "/php/upload_conference_image.php", body: {
      "encoded_string": base64Image,
      "id": widget.package.id,
    }).then((res) {
      if (res.body == "Upload Successful") {
        Toast.show("Successfully Updated Conference Picture", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          DefaultCacheManager manager = new DefaultCacheManager();
          manager.emptyCache();
          newImageFile = imageFile;
          // UserDrawer.newImageFile = imageFile;
          changedImage = true;
          //UserDrawer.changedImage = true;
        });
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
