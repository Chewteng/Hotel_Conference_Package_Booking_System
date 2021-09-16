import 'package:flutter/material.dart';
import 'package:hotel_booking/package.dart';
import 'package:hotel_booking/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:toast/toast.dart';

class InfoPage extends StatefulWidget {
  final User user;
  final Package package;
  const InfoPage({Key key, this.package, this.user}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List locdata;
  //bool _nightstay = false;

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    double lat = double.parse(widget.package.latitude);
    double log = double.parse(widget.package.longitude);

    setState(() {
      _markers.clear();

      final marker = Marker(
        markerId: MarkerId(widget.package.name),
        position: LatLng(lat, log),
        infoWindow: InfoWindow(
          title: widget.package.name,
          snippet: widget.package.address,
        ),
      );
      _markers[widget.package.name] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    //final f = new DateFormat('yMd');

    return Scaffold(
        appBar: AppBar(
          title: Text('Package Description'),
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Container(
            //alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black26,
                image: DecorationImage(
                    image: NetworkImage(
                        "http://yitengsze.com/hcpbs/conferenceimage/${widget.package.imagename}?"),
                    fit: BoxFit.fill)),
            height: 350,
          ),
          SizedBox(
            height: 6,
          ),
          Card(
            child: Table(defaultColumnWidth: FlexColumnWidth(1.0), children: [
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(widget.package.packagetype,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          alignment: Alignment.topLeft,
                          //height: 150,
                          child: Text(
                              "RM " +
                                  (formatter.format(
                                      int.parse(widget.package.price))) +
                                  " per Day",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(widget.package.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          alignment: Alignment.topLeft,
                          child: Text(widget.package.address,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Conference Room Setup: " + widget.package.type,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  //fontStyle: FontStyle.italic,
                                  color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Conference Room Area: " +
                                  widget.package.area +
                                  " Sqm",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ])),
              ]),
              TableRow(children: [
                TableCell(
                    child:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Icon(
                    MdiIcons.calendar,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                      alignment: Alignment.center,
                      child: Text(
                          widget.package.startdate +
                              "   " +
                              widget.package.starttime +
                              " - " +
                              widget.package.endtime,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  SizedBox(
                    height: 30,
                  ),
                ])),
              ]),
            ]),
          ),
          Card(
              child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
            ),
            _googleMap(context),
            SizedBox(
              height: 10,
            ),
            Card(
                child: Table(
                    defaultColumnWidth: FlexColumnWidth(1.0),
                    columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(6.5),
                },
                    children: [
                  TableRow(children: [
                    TableCell(
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.note,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text("Description: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))),
                        ])),
                    TableCell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.package.description,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          )),
                        ],
                      ),
                    ),
                  ]),
                ])),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Our package is inclusive of: ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 5,
                ),
                
                
                Text("• Welcome meeting refreshment with coffee, tea and cookies."),
                Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("• " + widget.package.coffee)
                  ],
                )
              ],
            ),
                Text("• Choice of theme for coffee breaks."),
                 Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    widget.package.buffet == null
                        ? Container()
                        : new Text("• " + "${widget.package.buffet}")
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    widget.package.nightstay == null
                        ? Container()
                        : new Text("• " + "${widget.package.nightstay}")
                  ],
                )
              ],
            ),
            Text("• Meeting room usage within the time period."),
                Text("• Meeting amenities including mineral water and mints."),
                Text(
                    "• Meeting set-up inclusive of meeting pads, pencils and pens."),
                Text(
                    "• Complimentary one (1) unit of whiteboard and flipchart with markers and eraser set."),
                Text(
                    "• Complimentary use of standard meeting equipment (1 unit of LCD projector & screen, standard PA system with 1 wired microphone)."),
                Text("• Free internet access at designated area."),
                Text(
                    "• Flat rate charge RM10.00 nett for covered carpark each person."),
              ],
            )),
            
            
           
            SizedBox(
              height: 10,
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Optional: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              'Additional coffee / tea to be served inside meeting room is chargeable at RM 25.00+ per pot. Mineral Water is also available at RM 6.00+ per bottle.'),
                    ],
                  ),
                )
              ],
            )),
            SizedBox(
              height: 15,
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Terms & Conditions: ',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                SizedBox(
              height: 7,
            ),
                RichText(
                  text: TextSpan(
                    text:
                        '• The above price is inclusive of government tax. Price is subject to change without prior notice.',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
              height: 5,
            ),
                RichText(
                  text: TextSpan(
                    text: '• Package quoted is based on minimum of 30 persons.',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
              height: 5,
            ),
                RichText(
                  text: TextSpan(
                    text:
                        '• Reservation is subject to availability and can only be done online.',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    text:
                        '• Reservation cannot be changed and price is non-refundable once the payment is completed successfully.',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 8,
                )
              ],
            )),
          ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => _launchInUrl("https://${widget.package.url}?"),
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Icon(
                    MdiIcons.link,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _callPhone(context),
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Icon(
                    MdiIcons.phone,
                    size: 25,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _whatsupPhone(context),
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Icon(
                    MdiIcons.whatsapp,
                    size: 25,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ]))));
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
          'Contact Us via WhatsApp' + '?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + widget.package.contact,
                    "I'm interested to know more about this package.");
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
                    color: Colors.blue[400], fontWeight: FontWeight.w700),
              )),
        ],
      ),
    );
  }

  _callPhone(BuildContext context) {
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
          'Make a phone call' + '?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + widget.package.contact);
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
                    color: Colors.blue[400], fontWeight: FontWeight.w700),
              )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _googleMap(BuildContext context) {
    double lat = double.parse(widget.package.latitude);
    double log = double.parse(widget.package.longitude);
    return Container(
      height: 250,
      width: 400,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, log),
          zoom: 12,
        ),
        markers: _markers.values.toSet(),
        mapType: MapType.normal,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
