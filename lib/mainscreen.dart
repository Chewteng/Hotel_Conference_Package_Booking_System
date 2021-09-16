import 'dart:async';
import 'dart:convert';
import 'package:hotel_booking/adminpackages.dart';
import 'package:hotel_booking/customerbookings.dart';
import 'package:hotel_booking/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/favscreen.dart';
import 'package:hotel_booking/infopage.dart';
import 'package:hotel_booking/loginscreen.dart';
import 'package:hotel_booking/package.dart';
import 'package:hotel_booking/paymenthistory.dart';
import 'package:hotel_booking/profilescreen.dart';
import 'package:hotel_booking/registerscreen.dart';
import 'package:hotel_booking/user.dart';
import 'package:hotel_booking/wallethistory.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List packagedata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Package Lists";
  String packagequantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  bool _isstaff = false;
  String titlecenter = "Loading Packages...";
  String server = "https://yitengsze.com/hcpbs";
  DateTime _dateTime;
  var myFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadPackageQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@cphotelbooking.com") {
      _isadmin = true;
    }
    if (widget.user.email == "staff@cphotelbooking.com") {
      _isstaff = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //imageCache.clear();
   // imageCache.clearLiveImages();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    // final formatter = new NumberFormat("#,###");
    //final f = new DateFormat('yMd');

    if (packagedata == null) {
      return Scaffold(
          appBar: AppBar(title: Text('CP Hotel Booking')
              //backgroundColor: Color.fromRGBO(101, 255, 218, 50),
              ),
          body: Container(
            child: Center(
                child: Text(
              titlecenter,
              style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )),
          ));
    } else {
      return WillPopScope(
          onWillPop: () async {
            return await DialogHelper.exit(context);
          },
          child: Scaffold(
            drawer: mainDrawer(context),
            appBar: AppBar(
              title: Text('CP Hotel Booking'),
              // backgroundColor: Color.fromRGBO(101, 255, 218, 50),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        MdiIcons.calendar,
                        size: 27,
                        color: Colors.grey[850],
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate:
                              _dateTime == null ? DateTime.now() : _dateTime,
                          firstDate: DateTime(2021, 4),
                          lastDate: DateTime(2021, 8),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                  //  primarySwatch: buttonTextColor,//OK/Cancel button text color
                                  primaryColor:
                                      const Color(0xFF4A5BF6), //Head background
                                  accentColor:
                                      const Color(0xFF4A5BF6) //selection color
                                  //dialogBackgroundColor: Colors.white,//Background color
                                  ),
                              child: child,
                            );
                          },
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            _sortPackagebyCalendar(myFormat.format(_dateTime));
                            print(_dateTime);
                          });
                        });
                      },
                    ),
                    IconButton(
                      icon: _visible
                          ? new Icon(Icons.expand_more)
                          : new Icon(Icons.expand_less),
                      onPressed: () {
                        setState(() {
                          if (_visible) {
                            _visible = false;
                          } else {
                            _visible = true;
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            body: RefreshIndicator(
                key: refreshKey,
                color: Color.fromRGBO(101, 255, 218, 50),
                onRefresh: () async {
                  await refreshList();
                },
                child: Container(
                  child: Column(
                   // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Visibility(
                        visible: _visible,
                        child: Card(
                            elevation: 10,
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                   // mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("Recent"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.home,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "Recent",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("Auditorium"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.theater,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "Auditorium",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("Classroom"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.rectangleOutline,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "Classroom",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("U-Shape"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.borderBottom,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "U-Shape",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("Banquet"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.circleOutline,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "Banquet",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              onPressed: () =>
                                                  _sortPackage("Hollow Square"),
                                              color: Colors.blue[400],
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.borderAllVariant,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    "Hollow Square",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))),
                      ),
                      Card(
                        color: Colors.grey[100],
                        elevation: 5,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                          child: Row(
                           // mainAxisSize: MainAxisSize.min,
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                color: Colors.blue[400],
                                textColor: Colors.black,
                                onPressed: () => {
                                  _sortPackagebyAddress(_prdController.text),
                                  _sortPackagebyName(_prdController.text),
                                  _sortPackagebyPackageType(
                                      _prdController.text),
                                  _sortPackagebyStartDate(_prdController.text),
                                  _sortPackagebyStartTime(_prdController.text),
                                  _sortPackagebyEndTime(_prdController.text)
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
                      Flexible(
                         // fit: FlexFit.tight,
                          child: ListView(
                              children:
                                  List.generate(packagedata.length, (index) {
                            return Card(
                              child: Column(
                               // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _onImageDisplay(index),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 8),
                                      height: 295,
                                      decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 3,
                                                spreadRadius: 2)
                                          ]),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          left: 2,
                                          top: 8,
                                          bottom: 5,
                                          child: Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[400],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: server +
                                                        "/conferenceimage/${packagedata[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ))),
                                        ),
                                        Positioned(
                                            top: 15,
                                            left: 160,
                                            bottom: 10,
                                            right: 2,
                                            child: Column(
                                              //mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                        
                                                Text(
                                                    packagedata[index]
                                                            ['packagetype'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                SizedBox(height: 8),
                                                Text(packagedata[index]['name'],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    packagedata[index]
                                                        ['address'],
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                SizedBox(height: 6),
                                                Text(
                                                  "Price per Package:",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                Row(children: <Widget>[
                                                  Text(
                                                  "RM " +
                                                      packagedata[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                      IconButton(
                                                          icon: Icon(Icons
                                                              .favorite_border),
                                                          onPressed: () =>
                                                              _addtofavdialog(
                                                                  index)),
                                                ],),
                                                
                                                SizedBox(height: 5),
                                                Row(
                                               //   mainAxisSize:
                                                //      MainAxisSize.min,
                                                  children: <Widget>[
                                                    //    Icon(MdiIcons
                                                    //        .roomServiceOutline),
                                                    Text(
                                                      "Setup Style: " +
                                                          packagedata[index]
                                                              ['type'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                //  SizedBox(height: 3),
                                                Row(
                                                //  mainAxisSize:
                                                 //     MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(MdiIcons.calendar),
                                                    Text(
                                                      packagedata[index]
                                                          ['startdate'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      packagedata[index]
                                                              ['starttime'] +
                                                          "-" +
                                                          packagedata[index]
                                                              ['endtime'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(height: 2),
                                                Row(
                                                  //  mainAxisSize:
                                                    //    MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(MdiIcons
                                                          .cropLandscape),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        packagedata[index]
                                                                ['area'] +
                                                            " Sqm",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      
                                                    ]),
                                              ],
                                            ))
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                              // )
                            );
                          })))
                    ],
                  ),
                )),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FavScreen(
                              user: widget.user,
                            )));
                _loadData();
                _loadPackageQuantity();
              },
              icon: Icon(Icons.favorite),
              label: Text(packagequantity),
            ),
          ));
    }
  }

  _onImageDisplay(int index) async {
    Package package = new Package(
      id: packagedata[index]["id"],
      price: packagedata[index]["price"],
      type: packagedata[index]["type"],
      quantity: packagedata[index]["quantity"],
      area: packagedata[index]["area"],
      packagetype: packagedata[index]["packagetype"],
      startdate: packagedata[index]["startdate"],
      starttime: packagedata[index]["starttime"],
      endtime: packagedata[index]["endtime"],
      name: packagedata[index]["name"],
      description: packagedata[index]["description"],
      nightstay: packagedata[index]["nightstay"],
      buffet: packagedata[index]["buffet"],
      coffee: packagedata[index]["coffee"],
      latitude: packagedata[index]["latitude"],
      longitude: packagedata[index]["longitude"],
      url: packagedata[index]["url"],
      contact: packagedata[index]["contact"],
      address: packagedata[index]["address"],
      imagename: packagedata[index]["imagename"],
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InfoPage(
                  package: package,
                  user: widget.user,
                )));

    _loadData();
  }

  void _loadData() async {
    String urlLoadPackages = server + "/php/load_packages.php";
    await http.post(urlLoadPackages, body: {}).then((res) {
      if (res.body == "nodata") {
        packagequantity = "0";
        titlecenter = "No packages found";
        setState(() {
          packagedata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          packagedata = extractdata["packages"];
          packagequantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _sortPackage(String type) {
    try {
      String urlLoadPackages = server + "/php/load_packages.php";
      http.post(urlLoadPackages, body: {
        "type": type,
      }).then((res) {
        setState(() {
          if (res.body == "nodata") {
            packagedata = null;
            //titlecenter = "No packages found";
            // titletop = "Carian menjumpai sebarang produk";
            curtype = type;
            Toast.show("No available packages", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            //pr.dismiss();
          } else {
            curtype = type;
            var extractdata = json.decode(res.body);
            packagedata = extractdata["packages"];
            FocusScope.of(context).requestFocus(new FocusNode());
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

  void _sortPackagebyCalendar(String startdate) {
    try {
      String urlLoadPackages = server + "/php/load_packages.php";
      http.post(urlLoadPackages, body: {
        "startdate": startdate.toString(),
      }).then((res) {
        setState(() {
          if (res.body == "nodata") {
            Toast.show("No available packages found", context,
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
            packagedata = extractdata["packages"];
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

  void _sortPackagebyAddress(String pradd) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http.post(urlLoadPackages, body: {
      "address": pradd.toString(),
    }).then((res) {
      if (res.body != "nodata") {
        setState(() {
          var extractdata = json.decode(res.body);
          packagedata = extractdata["packages"];
          FocusScope.of(context).requestFocus(new FocusNode());
          curtype = "Search for " + "'" + pradd + "'";
        });
      }
    }).catchError((err) {
      Toast.show("Not relevant information found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //pr.dismiss();
      FocusScope.of(context).requestFocus(new FocusNode());
      return;
    });
  }

  void _sortPackagebyName(String pradd1) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http
        .post(urlLoadPackages, body: {
          "name": pradd1.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              packagedata = extractdata["packages"];
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

  void _sortPackagebyPackageType(String pradd2) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http
        .post(urlLoadPackages, body: {
          "packagetype": pradd2.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              packagedata = extractdata["packages"];
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

  void _sortPackagebyStartDate(String pradd3) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http
        .post(urlLoadPackages, body: {
          "startdate": pradd3.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              packagedata = extractdata["packages"];
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

  void _sortPackagebyStartTime(String pradd4) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http
        .post(urlLoadPackages, body: {
          "starttime": pradd4.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              packagedata = extractdata["packages"];
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

  void _sortPackagebyEndTime(String pradd5) {
    String urlLoadPackages = server + "/php/load_packages.php";
    http
        .post(urlLoadPackages, body: {
          "endtime": pradd5.toString(),
        })
        .timeout(const Duration(seconds: 4))
        .then((res) {
          if (res.body != "nodata") {
            setState(() {
              var extractdata = json.decode(res.body);
              packagedata = extractdata["packages"];
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  void _loadPackageQuantity() async {
    String urlLoadFavQuantity = server + "/php/load_savequantity.php";
    await http.post(urlLoadFavQuantity, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    imageCache.clear();
    return Drawer(
        child: Container(
      color: Colors.blue[300],
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: new BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/drawer.jpg',
                    ),
                    fit: BoxFit.cover)),
            accountName: Text(widget.user.name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            accountEmail: Text(widget.user.email,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                )),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.black87
                      : Colors.black87,
              //child:
              //Text(
              //   widget.user.name.toString().substring(0, 1).toUpperCase(),
              //   style: TextStyle(fontSize: 40.0, color: Colors.black),
              // ),
              backgroundImage: NetworkImage(
                  "http://yitengsze.com/hcpbs/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
          Card(
            child: ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 44,
                    maxHeight: 44,
                  ),
                  child:
                      Image.asset("assets/images/main.png", fit: BoxFit.cover),
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Back to main page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                dense: true,
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                      _loadData(),
                    }),
          ),
          Card(
            child: ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 44,
                    maxHeight: 44,
                  ),
                  child: Image.asset("assets/images/favorite.png",
                      fit: BoxFit.cover),
                ),
                title: Text(
                  "Favourites",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Saved preferences listing here",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                dense: true,
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pop(context);
                  gotoFav();
                }),
          ),
          Card(
            child: ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 44,
                  maxHeight: 44,
                ),
                child:
                    Image.asset("assets/images/booking.png", fit: BoxFit.cover),
              ),
              title: Text(
                "Package Booking",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Package booking details & payment history here",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              isThreeLine: true,
              dense: true,
              trailing: Icon(Icons.arrow_forward),
              onTap: _paymentScreen,
            ),
          ),
          Card(
            child: ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 44,
                  maxHeight: 44,
                ),
                child:
                    Image.asset("assets/images/wallet.png", fit: BoxFit.cover),
              ),
              title: Text(
                "Wallet TopUp",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Wallet balance & its transactions",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              isThreeLine: true,
              dense: true,
              trailing: Icon(Icons.arrow_forward),
            onTap: () => _walletScreen(),
            ),
          ),
           Card(
            child: ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 44,
                  maxHeight: 44,
                ),
                child:
                    Image.asset("assets/images/help.png", fit: BoxFit.cover),
              ),
              title: Text(
                "Help Centre",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Get help or assistance here",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              isThreeLine: true,
              dense: true,
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _whatsupPhone(context),
            ),
          ),
          Card(
            child: ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 44,
                    maxHeight: 44,
                  ),
                  child: Image.asset("assets/images/settings.png",
                      fit: BoxFit.cover),
                ),
                title: Text(
                  "User Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "App and privacy settings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                dense: true,
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfileScreen(
                                    user: widget.user,
                                  )))
                    }),
          ),
          Card(
            child: ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 44,
                    maxHeight: 44,
                  ),
                  child: Image.asset("assets/images/register.png",
                      fit: BoxFit.cover),
                ),
                title: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Register new account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                dense: true,
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterScreen()))
                    }),
          ),
          Card(
              child: ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 44,
                      maxHeight: 44,
                    ),
                    child: Image.asset("assets/images/logout.png",
                        fit: BoxFit.cover),
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Back to loginscreen",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  isThreeLine: true,
                  dense: true,
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                  })),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 10,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  child: ListTile(
                      title: Text(
                        "Manage Package",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AdminPackages(
                                          user: widget.user,
                                        )))
                          }),
                ),
                Card(
                  child: ListTile(
                      title: Text(
                        "Customer Booking",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                       CustomerBookingsScreen(
                                          user: widget.user,
                                        )))
                          }),
                ),
              ],
            ),
          ),
           Visibility(
            visible: _isstaff,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 10,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    "Staff Menu",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  child: ListTile(
                      title: Text(
                        "Customer Booking",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                       CustomerBookingsScreen(
                                          user: widget.user,
                                        )))
                          }),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  _whatsupPhone(BuildContext context) {
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
          'Ask for Help' + '?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + "0107835251",
                    "I'm  ");
              },
              child: Text(
                "Yes",
                style: TextStyle(
                    color: Colors.blue[600], fontWeight: FontWeight.w700),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No",
                style: TextStyle(
                    color: Colors.blue[300], fontWeight: FontWeight.w700),
              )),
        ],
      ),
    );
  }


  _addtofavdialog(int index) {
    if (widget.user.email == "unregistered@cphotelbooking.com") {
      Toast.show("Please signup to unlock this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Save " + packagedata[index]['name'] + "'s package?",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: server +
                        "/conferenceimage/${packagedata[index]['id']}.jpg",
                    width: 220,
                    height: 180,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Select package quantity",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.blue[400],
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(
                                        packagedata[index]['quantity']))) {
                                  quantity++;
                                } else {
                                  Toast.show("Sold Out", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.blue[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoFav(index);
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
            );
          });
        });
  }

  void _addtoFav(int index) {
    if (widget.user.email == "unregistered@cphotelbooking.com") {
      Toast.show("Please signup to unlock this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    try {
      int fquantity = int.parse(packagedata[index]["quantity"]);
      print(fquantity);
      print(packagedata[index]["id"]);
      print(widget.user.email);
      if (fquantity > 0) {
        String urlInsertFav = server + "/php/insert_fav.php";
        http.post(urlInsertFav, body: {
          "email": widget.user.email,
          "packageid": packagedata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to fav", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            //pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              packagequantity = respond[1];
              widget.user.quantity = packagequantity;
            });
            Toast.show("Save Successfully", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        Toast.show("Sold Out", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to fav", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoFav() async {
    
    if (widget.user.email == "unregistered@cphotelbooking.com") {
      Toast.show("Please signup to unlock this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Saved Package List Empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => FavScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadPackageQuantity();
    }
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@cphotelbooking.com") {
      Toast.show("Please signup to unlock this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryScreen(
                  user: widget.user,
                )));
  }

  void _walletScreen() {
    if (widget.user.email == "unregistered@cphotelbooking.com") {
      Toast.show("Please signup to unlock this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WalletScreen(
                  user: widget.user,
                )));
  }
}
