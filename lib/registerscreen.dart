import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_booking/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_booking/eula_dialog.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight, screenWidth;
  bool _isChecked = false;
  bool _validate = false;
  String urlRegister = "http://yitengsze.com/hcpbs/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String name, email, password, phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  String pathAsset = 'assets/images/profile.png';
  bool passwordVisible = false;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            //backgroundColor: Colors.black,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Stack(
                    children: <Widget>[
                      upperHalf(context),
                      lowerHalf(context),
                    ],
                  )),
            )));
  }

  Widget upperHalf(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60),
          GestureDetector(
              onTap: _choose,
              child: Center(
                child: Container(
                  height: screenHeight / 4.8,
                  width: screenWidth / 2.4,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      )),
                ),
              )),
          SizedBox(height: 10),
          Text('Click on image above to take profile picture',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ]);
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
        height: 550,
        margin: EdgeInsets.only(top: screenHeight / 3.4),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //  Card(
              //  shape: RoundedRectangleBorder(
              //    borderRadius: BorderRadius.circular(10.0)),
              //  elevation: 10,
              // child:
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: <Widget>[
                    // Align(
                    //    alignment: Alignment.center,
                    //   child: Text(
                    //     "Register",
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 26,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //     ),
                    //   ),
                    SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus0);
                      },
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
                            fontSize: 15, fontStyle: FontStyle.italic),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        hintText: 'Enter you name',
                        prefixIcon: Icon(Icons.person, color: Colors.blue[400]),
                        // icon: Icon(Icons.person)
                      ),
                      maxLength: 32,
                      validator: validateName,
                      onSaved: (String val) {
                        name = val;
                      },
                    ),
                    TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: focus0,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
                        },
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[400], width: 2.0),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          hintText: 'Enter your complete email address',
                          prefixIcon:
                              Icon(Icons.email, color: Colors.blue[400]),
                        ),
                        maxLength: 50,
                        //validator: validateEmail,
                        onSaved: (String val) {
                          email = val;
                        }),
                    TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _phoneEditingController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        focusNode: focus1,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[400], width: 2.0),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          labelText: 'Phone',
                          labelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          hintText: 'Enter your complete phone number',
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.blue[400]),
                        ),
                        maxLength: 10,
                       // validator: validatePhone,
                        onSaved: (String val) {
                          phone = val;
                        }),
                    TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _passEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        maxLength: 32,
                        obscureText:
                            passwordVisible, //This will obscure text dynamically
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[400], width: 2.0),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        // validator: validatePassword,
                        onSaved: (String val) {
                          password = val;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Checkbox(
                          checkColor: Colors.blue[400], // color of tick Mark
                          activeColor: Colors.blue[400],
                          value: _isChecked,
                          onChanged: (bool value) {
                            toggleEula();
                          },
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              // ignore: missing_required_param
                              return EulaDialog(toggleEula: toggleEula);
                            },
                          ),
                          child: Text('Agree to Terms',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 155,
                          height: 50,
                          child: Text('Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          color: Colors.blue[400],
                          textColor: Colors.black,
                          elevation: 10,
                          onPressed: _onRegister,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already a member? ",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  GestureDetector(
                    onTap: _loginScreen,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  String validateName(String value) {
    //String patttern = r'(^[a-zA-Z ]*$)';
    // RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    }
    return null;
  }

  String validateEmail(String value) {
    // String pattern =
    ///     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    }
    return null;
  }

  String validatePhone(String value) {
    //String patttern = r'(^[0-9]*$)';
    //RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (value.length != 10) {
      return "Phone number must 10 digits";
    }
    return null;
  }

  Future<bool> _onBackPressed() {
    _image = null;
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text('Are you sure?',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            content: new Text('Do you want to exit register screen?',
                style: TextStyle(
                    fontSize: 16.0,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black)),
            actions: <Widget>[
              Icon(
                MdiIcons.menuRight,
                size: 40,
                color: Colors.black,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
                child: Text("Yes",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            ],
          ),
        ) ??
        false;
  }

  void _choose() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
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

  void _onRegister() {
    name = _nameEditingController.text;
    email = _emailEditingController.text;
    phone = _phoneEditingController.text;
    password = _passEditingController.text;

    if ((_isEmailValid(email)) &&
        (validatePassword(password)) &&
        (_image != null) &&
        (phoneNumberIsValid(phone)) &&
        _isChecked) {
      // validation error
      Toast.show("Registration in progress", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlRegister, body: {
        "encoded_string": base64Image,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      }).then((res) {
        Toast.show("Register Successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print("Register Successfully.");
        // print("Verify email first before login!");
        _image = null;
        // savepref(_email, _password);
        _nameEditingController.text = '';
        _phoneEditingController.text = '';
        _emailEditingController.text = '';
        _passEditingController.text = '';
        //pr.dismiss();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      }).catchError((err) {
        print(err);
      });
    } else {
      //setState(() {
      //    _validate = true;
      // });
      if (_image == null) {
        Toast.show("Please insert your profile image", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (name.length < 1) {
        Toast.show("Please enter your name", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (email.length < 1) {
        Toast.show("Please enter your email address", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (phone.length < 1) {
        Toast.show("Please enter your phone number", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (password.length < 1) {
        Toast.show("Please enter your password", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (!_isChecked) {
        Toast.show("Please accept the terms of the EULA", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
      }

      if (!_isEmailValid(email)) {
        Toast.show("Please insert your email address correctly", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }

      if (!phoneNumberIsValid(phone)) {
        Toast.show("Please insert phone number correctly", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }

      if (!validatePassword(password)) {
        Toast.show(
            "Password must be minimum eight characters (at least one uppercase letter, one lowercase letter, one number and one special character)",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        return;
      }
      // Toast.show("Please check your information", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool phoneNumberIsValid(String phone) {
    return RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(phone);
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _loginScreen() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text('Are you sure?',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        content: new Text('Do you want to back to LoginScreen?',
            style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                color: Colors.black)),
        actions: <Widget>[
          //   Icon(
          //     MdiIcons.menuRight,
          //     size: 40,
          //     color: Colors.black,
          //  ),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
            },
            child: Text("Yes",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600])),
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
    );
  }

  void toggleEula({bool boolean}) {
    setState(() {
      if (boolean != null) {
        _isChecked = boolean;
      } else {
        _isChecked = !_isChecked;
      }
    });
  }
}
