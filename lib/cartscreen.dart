import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pocket_doctor/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'homescreen.dart';
import 'payment.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String server = "https://pdoc1.000webhostapp.com";
  List cartData;
  double screenHeight, screenWidth;
  bool _selfPickup = true;
  bool _storeCredit = false;
  bool _homeDelivery = false;
  double _weight = 0.0, _totalprice = 0.0;
  Position _currentPosition;
  String curaddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;
  double deliverycharge;
  double amountpayable;
  String titlecenter = "Loading cart items...";

  @override
  void initState() {
    super.initState();
    
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 245, 230, 1),
        appBar: AppBar(title: Text('My Cart'), actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.deleteEmpty),
            onPressed: () {
              deleteAll();
            },
          ),
        ]),
        body: Container(
            child: Column(
          children: <Widget>[
            Text(
              "Cart contents",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            cartData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Color.fromRGBO(101, 255, 218, 50),
                        fontSize: 22,
                        fontFamily: "Aerial",
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartData == null ? 1 : cartData.length + 1,
                        itemBuilder: (context, index) {

                          if (index == cartData.length) {
                            return Container(
                                child: Card(
                            
                                  color: Color.fromRGBO(238, 232, 170, 1),
                                  
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Total",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "Aerial",
                                          fontWeight: FontWeight.w800,
                                          color: Color.fromRGBO(105, 105, 105,1))),
                                  SizedBox(height: 10),
                                  Container(
                                    
                                      padding:
                                          EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: Text(
                                                      "Total: RM" +
                                                              _totalprice
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          "0.0",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                              fontFamily: "Aerial",
                                                          fontSize: 14,
                                                          color: Color.fromRGBO(105, 105, 105,1))),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minWidth: 200,
                                    height: 40,
                                    
                                    child: Text('Checkout',style: TextStyle(fontWeight: FontWeight.w800)),
                                    color: Color.fromRGBO(255, 215, 0,1),
                                    textColor: Colors.black,
                                    elevation: 10,
                                    onPressed: makePayment,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ));
                          }
                          index -= 0;

                          return Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
    color: Colors.black,
    width: 1.0,
  ),
                                  ),
                            color: Color.fromRGBO(253, 245, 230, 1),
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 8,
                                          width: screenWidth / 5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl:
                                                server+"/productimage/${cartData[index]['id']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                        Text(
                                          "RM " + cartData[index]['price'],
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 1.45,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    cartData[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Quantity: " +
                                                        cartData[index]
                                                            ['cquantity'],
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(index,
                                                                  "remove")
                                                            },
                                                            child: Icon(
                                                              MdiIcons.minus,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            cartData[index]
                                                                ['cquantity'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(
                                                                  index, "add")
                                                            },
                                                            child: Icon(
                                                              MdiIcons.plus,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          
                                                          
                                                        ],
                                                      )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          "Total RM " +
                                                              cartData[index]
                                                                  ['yourprice'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ])));
                        })),
          ],
        )));
  }

  void _loadCart() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    deliverycharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = server+"/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _weight = double.parse(cartData[i]['weight']) *
                  int.parse(cartData[i]['cquantity']) +
              _weight;
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
        }
        _weight = _weight / 1000;
        amountpayable = _totalprice;

        print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server+"/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": cartData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server+"/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "prodid": cartData[index]['id'],
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }


  void _updatePayment() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    setState(() {
      for (int i = 0; i < cartData.length; i++) {
        _weight = double.parse(cartData[i]['weight']) *
                int.parse(cartData[i]['cquantity']) +
            _weight;
        _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
      }
      _weight = _weight / 1000;
      print(_selfPickup);
      if (_selfPickup) {
        deliverycharge = 0.0;
      } else {
        if (_totalprice > 100) {
          deliverycharge = 5.00;
        } else {
          deliverycharge = _weight * 0.5;
        }
      }
      if (_homeDelivery) {
        if (_totalprice > 100) {
          deliverycharge = 5.00;
        } else {
          deliverycharge = _weight * 0.5;
        }
      }
      if (_storeCredit) {
        amountpayable =
            deliverycharge + _totalprice - double.parse(widget.user.credit);
      } else {
        amountpayable = deliverycharge + _totalprice;
      }
      print("Dev Charge:" + deliverycharge.toStringAsFixed(3));
      print(_weight);
      print(_totalprice);
    });
  }

  Future<void> makePayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1,4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: _totalprice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }

  void deleteAll() {
     showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server+"/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );

  }
}
