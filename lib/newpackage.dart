import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/adminpackages.dart';
import 'package:hotel_booking/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewPackage extends StatefulWidget {
  final User user;

  const NewPackage({Key key, this.user}) : super(key: key);

  @override
  _NewPackageState createState() => _NewPackageState();
}

class _NewPackageState extends State<NewPackage> {
  TextEditingController idEditingController = new TextEditingController();
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController addressEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController areaEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController descEditingController = new TextEditingController();
  TextEditingController latEditingController = new TextEditingController();
  TextEditingController logEditingController = new TextEditingController();
  TextEditingController urlEditingController = new TextEditingController();
  //TextEditingController contactEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  String server = "https://yitengsze.com/hcpbs";
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
  //final focus10 = FocusNode();
  //final focus11 = FocusNode();
  //final focus12 = FocusNode();
  //final focus13 = FocusNode();
  String selectedType;
  String selectedPackageType;
 // String selectedNightStay;
  final maxLines = 5;
  DateTime pickedDate;
  TimeOfDay time, time1;
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
  //List<String> listNStay = [
 //   "Yes",
 //   "No",
//  ];

  var df =  DateFormat("h:mma");

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    time1 = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Package'),
      leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AdminPackages(
                          user: widget.user,
                        )));
              }),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 8),
                GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height: screenHeight / 3.8,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 10),
                Text("Click the above image to take picture of conference room",
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
                                      child: Text("Package ID",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 45,
                                    child: TextFormField(
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
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
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        maxLines: maxLines,
                                        controller: addressEditingController,
                                        keyboardType: TextInputType.text,
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
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: priceEditingController,
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
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: qtyEditingController,
                                        keyboardType: TextInputType.number,
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
                                      height: 55,
                                      child: Text("Conference Room Setup",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 1, 20, 1),
                                    height: 55,
                                    child: Center(
                                      //height: 40,
                                      child: DropdownButton(
                                        isExpanded: true,

                                        //sorting dropdownoption
                                        hint: Text(
                                          'Conference Room Type',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
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
                                      height: 50,
                                      child: Text("Package Type",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 1, 20, 1),
                                    height: 50,
                                    child: Container(
                                      height: 45,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        //sorting dropdownoption
                                        hint: Text(
                                          'Package Type',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ), // Not necessary for Option 1
                                        value: selectedPackageType,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedPackageType = newValue;
                                            print(selectedPackageType);
                                          });
                                        },
                                        items: listPType
                                            .map((selectedPackageType) {
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
                                      height: 50,
                                      child: Text("Package Issued Date",
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
                                      child: Container(
                                        child: ListTile(
                                          title: Text(
                                              "${time1.hour.toString().padLeft(2, '0')}:${time1.minute.toString().padLeft(2, '0')}"),
                                          trailing: Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                          ),
                                          onTap: _pickStartTime,
                                        ),
                                      )),
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
                                      child: Container(
                                        child: ListTile(
                                          title: Text(
                                              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"),
                                          trailing: Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                          ),
                                          onTap: _pickEndTime,
                                        ),
                                      )),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 45,
                                      child: Text(
                                          "Area (Sqm) of Conference Room",
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
                                      //inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                                     // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: areaEditingController,
                                        keyboardType: TextInputType.number,
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
                                        focusNode: focus5,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus6);
                                        },
                                        decoration: new InputDecoration(
                                          // isDense: true,
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
                             // TableRow(children: [
                             //   TableCell(
                             //     child: Container(
                             //         alignment: Alignment.centerLeft,
                            //          height: 55,
                           //           child: Text("Provide Night Stay",
                           //               style: TextStyle(
                           //                   fontSize: 16,
                           //                   fontWeight: FontWeight.bold,
                           //                   color: Colors.black))),
                           //     ),
                           //     TableCell(
                          //        child: Container(
                           //         margin: EdgeInsets.fromLTRB(20, 1, 20, 1),
                           //         height: 55,
                           //         child: Center(
                           //           //height: 40,
                           //           child: DropdownButton(
                             //           isExpanded: true,

                                        //sorting dropdownoption
                              //          hint: Text(
                             //             'Yes',
                            //              style: TextStyle(
                            //                  fontSize: 16,
                            //                  color: Colors.black),
                            //            ), // Not necessary for Option 1
                            //            value: selectedNightStay,
                            //            onChanged: (newValue) {
                            //              setState(() {
                             //               selectedNightStay = newValue;
                            //                print(selectedNightStay);
                            //              });
                             //           },
                             //           items:
                             //               listNStay.map((selectedNightStay) {
                             //             return DropdownMenuItem(
                             //               child: new Text(selectedNightStay,
                             //                   style: TextStyle(
                              //                      fontSize: 16,
                             //                       color: Colors.black)),
                             //               value: selectedNightStay,
                           //               );
                           //             }).toList(),
                          //            ),
                          //          ),
                          //        ),
                         //       ),
                         //     ]),
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
                                     // inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: latEditingController,
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
                                      //inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: logEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus7,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus8);
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
                                    height: maxLines * 12.0,
                                    child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        controller: urlEditingController,
                                        keyboardType: TextInputType.url,
                                        maxLines: maxLines,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus8,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus9);
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
                                "Insert New Package",
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

  void _choose() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Select the image source",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _image = file);
      }
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
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

  _pickStartTime() async {
    TimeOfDay t1 = await showTimePicker(context: context, initialTime: time1,
    
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    
    if (t1 != null)
      setState(() {
        time1 = t1;
        print(t1);
      });
  }

  _pickEndTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (t != null)
      setState(() {
        time = t;
        print(t);
      });
  }

  void _insertNewHouse() {
    if (_image == null) {
      Toast.show("Please take conference room picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (idEditingController.text.length < 3 ) {
      Toast.show("Package ID incomplete", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (idEditingController.text.length > 4 ) {
      Toast.show("Please enter package ID with 4 numbers only", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (nameEditingController.text.length < 1) {
      Toast.show("Please enter hotel name", context,
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
     if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter available package quantity", context,
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
    if (pickedDate == null) {
      Toast.show("Please choose package issued date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (time1 == null) {
      Toast.show("Please choose package start time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (time == null) {
      Toast.show("Please choose package end time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (areaEditingController.text.length < 1) {
      Toast.show("Please enter area of conference room", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (descEditingController.text.length < 1) {
      Toast.show("Please enter hotel brief description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
   //  if (selectedNightStay == null) {
   //   Toast.show("Please choose whether night stay is provided or not", context,
  //        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //    return;
  //  }
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
   // if (contactEditingController.text.length < 1) {
   //   Toast.show("Please enter contact number", context,
   //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //    return;
  //  }
   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Package ID " + idEditingController.text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
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

   //bool phoneNumberIsValid(String phone) {
  //  return RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(phone);
 // }

  insertHouse() {
    if (_image == null) {
      Toast.show("No image is pictured.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    //}
    //if(!phoneNumberIsValid(contactEditingController.text)){
   //      Toast.show("Please insert contact number correctly", context,
    //      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
     //   return;  

    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server + "/php/insert_package.php", body: {
        "id": idEditingController.text,
        "name": nameEditingController.text,
        "address": addressEditingController.text,
        "quantity": qtyEditingController.text,
        "price": priceEditingController.text,
        "packagetype": selectedPackageType,
        "startdate": convertDateTimeDisplay(pickedDate.toString()),
        "starttime": time1.format(context).toString(),
        "endtime": time.format(context).toString(),
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
          print("Insert Successfully.");
          Toast.show("Insert new package successfully", context,
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
}
