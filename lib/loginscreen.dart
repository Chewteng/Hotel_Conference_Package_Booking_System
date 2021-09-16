import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_booking/mainscreen.dart';
import 'package:hotel_booking/registerscreen.dart';
import 'package:hotel_booking/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking/dialog_helper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:hotel_booking/user.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  final User user;
  const LoginScreen({Key key, this.user}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double padding = 10.0;
  double screenHeight;
  double screenWidth;
  bool _passwordVisible;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  TextEditingController newpassEditingController = new TextEditingController();
  String urlLogin = "http://yitengsze.com/hcpbs/php/login_user.php";
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  //String _email = "";
  String password;
  bool loading = false;
  double loadingOpacity = 1;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    print("Login Page");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          return await DialogHelper.exit(context);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                Form(
                    //    key: _formKey,
                    //  autovalidate: _validate,
                    child: Stack(
                  children: <Widget>[
                    upperHalf(context),
                    lowerHalf(context),
                  ],
                )),
              ],
            )));
  }

  Widget upperHalf(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 70),
          Center(
              child: Container(
            //tag: 'logo',
            // child: Container(
            height: 250,
            child: Image.asset('assets/images/login.png'),
          ))
        ]);
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
        height: 1000,
        margin: EdgeInsets.only(top: screenHeight / 2.2),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Colors.white, width: 4.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(children: <Widget>[
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus0);
                  },
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue[400], width: 2.0),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    //  hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: Colors.blue[400]),
                  ),
                  //maxLength: 32,
                  //validator: validateName,
                  // onSaved: (String val) {
                  //   name = val;
                  //   },
                ),
                SizedBox(
                  height: 19,
                ),

                //holding and releasing the longTap to see the password

                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: !_passwordVisible,
                  controller: _passEditingController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: focus0,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus1);
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue[400], width: 2.0),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue[400]),
                    // icon: Icon(Icons.lock),
                    //hasFloatingPlaceholder: true,
                    suffixIcon: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _passwordVisible = true;
                        });
                      },
                      onLongPressUp: () {
                        setState(() {
                          _passwordVisible = false;
                        });
                      },
                      child: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  // obscureText: true,
                ),
                SizedBox(
                  height: 23,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Checkbox(
                      hoverColor: Colors.black,
                      focusColor: Colors.black,
                      checkColor: Colors.blue[400], // color of tick Mark
                      activeColor: Colors.blue[400],

                      value: rememberMe,
                      onChanged: (bool value) {
                        _onRememberMeChanged(value);
                      },
                    ),
                    Text('Remember Me ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 150,
                      height: 50,
                      child: Text('Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      color: Colors.blue[400],
                      textColor: Colors.black,
                      elevation: 10,
                      onPressed: this._userLogin,
                    ),
                  ],
                ),

                SizedBox(
                  height: 33,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Not yet a member? ",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    GestureDetector(
                      onTap: _registerUser,
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Forgot your password ",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    GestureDetector(
                      onTap: _forgotPassword,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ]))
        ])));
  }

  Future<bool> _registerUser() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text('Are you sure?',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            content: new Text('Do you want to register new account?',
                style: TextStyle(fontSize: 16.0, color: Colors.black)),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RegisterScreen()));
                },
                child: Text("Yes",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600])),
                textColor: Colors.black,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[300])),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(MdiIcons.homeOutline, size: 40, color: Colors.black),
          Text(
            "CP Hotel Booking",
            style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  void _userLogin() async {
    try {
      Toast.show("Login in the progress", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      String _email = _emailEditingController.text;
      String _password = _passEditingController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              credit: userdata[4],
              datereg: userdata[5],
              quantity: userdata[6]);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          Toast.show("Login failed.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text("Forgot Password?",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          content: new Container(
            height: 120,
            child: Column(
              children: <Widget>[
                Text("Enter your registered email to reset password:",
                    style: TextStyle(fontSize: 16.0, color: Colors.black)),
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _emailEditingController,
                  validator: validateEmail,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue[400],
                      ),
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_isEmailValid(_emailEditingController.text)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            title: new Text(
                              "Reset password?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                            content: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    controller: newpassEditingController,
                                    
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'New Password',
                                      icon: Icon(
                                        Icons.lock,
                                        color: Colors.blue[400],
                                      ),
                                    )),
                              ],
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () => updatePassword(
                                    newpassEditingController.text),
                              ),
                              new FlatButton(
                                child: new Text(
                                  "No",
                                  style: TextStyle(
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () => {Navigator.of(context).pop()},
                              ),
                            ]);
                      });
                } else {
                  Toast.show("Please enter complete email address", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
            ),
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue[300],
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateEmail(String value) {
    if (value.length == 0) {
      return "Email is Required";
    } else {
      return null;
    }
  }

  updatePassword(String pass1) {
    if (pass1 == "") {
      Toast.show("Please enter your new password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (!validatePassword(pass1)) {
      Toast.show("Password must be minimum eight characters (at least one uppercase letter, one lowercase letter, one number and one special character)", context,
         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post("http://yitengsze.com/hcpbs/php/forgetpswd.php", body: {
      "email": _emailEditingController.text,
      "password": pass1,
    }).then((res) {
      if (res.body == "success") {
        print('Successfully Reset Password');
        setState(() {
          password = pass1.toString();
        });
        Toast.show("Successfully Reset Password", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //_gotologinPage();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return;
      } else {
        print("error");
      }
    }).catchError((err) {
      print(err);
    });
  }

  bool _isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
  
  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
