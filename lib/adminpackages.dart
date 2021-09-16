import 'dart:async';
import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_booking/editpackages.dart';
import 'package:hotel_booking/mainscreen.dart';
import 'package:hotel_booking/newpackage.dart';
import 'package:hotel_booking/package.dart';
import 'package:hotel_booking/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AdminPackages extends StatefulWidget {
  final User user;

  const AdminPackages({Key key, this.user}) : super(key: key);

  @override
  _AdminPackagesState createState() => _AdminPackagesState();
}

class _AdminPackagesState extends State<AdminPackages> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List packagedata;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Package Lists";
  String packagequantity = "0";
  int quantity = 1;
  var _tapPosition;
  String titlecenter = "Loading packages...";
  String server = "https://yitengsze.com/hcpbs";
  DateTime _dateTime;
  var myFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
   // imageCache.clear();
   //imageCache.clearLiveImages();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    //final f = new DateFormat('yMd');

    if (packagedata == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Manage Packages'),
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
        ))),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Manage Packages'),
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
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.center,
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
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            color: Colors.blue[400],
                            textColor: Colors.black,
                            onPressed: () => {
                              _sortPackagebyAddress(_prdController.text),
                              _sortPackagebyName(_prdController.text),
                              _sortPackagebyPackageType(_prdController.text),
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
                      fit: FlexFit.tight,
                      child: ListView(
                          children: List.generate(packagedata.length, (index) {
                        return Card(
                            child: InkWell(
                          onTap: () => _showPopupMenu(index),
                          onTapDown: _storePosition,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                //  onTap: () => _onImageDisplay(index),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 8),
                                  height: 290,
                                  decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 3,
                                            spreadRadius: 2)
                                      ]),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                      left: 2,
                                      top: 8,
                                      bottom: 5,
                                      child: Container(
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "http://yitengsze.com/hcpbs/conferenceimage/${packagedata[index]['id']}.jpg?"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 15,
                                        left: 168,
                                        bottom: 10,
                                        right: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                            Text(packagedata[index]['address'],
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
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            Text(
                                              "RM " +
                                                  packagedata[index]['price'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                            SizedBox(height: 3),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                                      ['starttime'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "-" +
                                                      packagedata[index]
                                                          ['endtime'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(MdiIcons.cropLandscape),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    packagedata[index]['area'] +
                                                        " Sqm",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                ]),
                                          ],
                                        ))
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          // )
                        ));
                      })))
                ],
              ),
            )),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                label: "New Package",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                labelBackgroundColor: Colors.white,
                onTap: createNewPackage),
          ],
        ),
      );
    }
  }

  _onPackageDetail(int index) async {
    print(packagedata[index]['name']);
    Package package = new Package(
        id: packagedata[index]['id'],
        name: packagedata[index]['name'],
        address: packagedata[index]['address'],
        price: packagedata[index]['price'],
        quantity: packagedata[index]['quantity'],
        packagetype: packagedata[index]['packagetype'],
        startdate: packagedata[index]['startdate'],
        starttime: packagedata[index]['starttime'],
        endtime: packagedata[index]['endtime'],
        area: packagedata[index]['area'],
        type: packagedata[index]['type'],
        description: packagedata[index]['description'],
        //nightstay: packagedata[index]['nightstay'],
        latitude: packagedata[index]['latitude'],
        longitude: packagedata[index]['longitude'],
        url: packagedata[index]['url'],
      //  contact: packagedata[index]['contact'],
        date: packagedata[index]['date']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditPackages(
                  user: widget.user,
                  package: package,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _onPackageDetail(index)},
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Update Pacakge Details?",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deletePackageDialog(index)},
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        MdiIcons.deleteSweep,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Delete Pacakage?",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deletePackageDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Package ID " + packagedata[index]['id'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePackage(index);
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePackage(int index) {
    http.post("https://yitengsze.com/hcpbs/php/delete_package.php", body: {
      "id": packagedata[index]['id'],
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show("Deleted package successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Deleted failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadData() async {
    //imageCache.clear();
    String urlLoadPackages =
        "https://yitengsze.com/hcpbs/php/load_packages.php";
    await http.post(urlLoadPackages, body: {}).then((res) {
      if (res.body == "nodata") {
        packagedata = null;
        titlecenter = "No packages found";

        Toast.show("No packages available in this location", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
    String urlLoadPackages =
        "https://yitengsze.com/hcpbs/php/load_packages.php";
    http.post(urlLoadPackages, body: {
      "type": type,
    }).then((res) {
      setState(() {
        if (res.body == "nodata") {
          packagedata = null;
          titlecenter = "No packages found";
          Toast.show("No packages available in this location", context,
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
  Future<void> createNewPackage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NewPackage(
                   user: widget.user,
                //   house: house,
                )));
    _loadData();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
   // imageCache.clear();
    return null;
  }
}
