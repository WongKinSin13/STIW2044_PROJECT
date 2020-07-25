import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_doctor/productscreen.dart';
import 'package:pocket_doctor/profilescreen2.dart';
import 'package:pocket_doctor/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'paymenthistoryscreen.dart';
import 'profilescreen2.dart';
import 'BMICalculatorScreen.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List productdata;
  List bmidata;
  bool noBmi = false;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading products...";
  String server = "https://pdoc1.000webhostapp.com";
  int _selectedIndex = 0;
  var parsedBmi;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadBmi();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@pocket_doctor.com") {
      _isadmin = true;
    }
  }

  /*void onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //var bmi = Bmis.fromJson(parsedBmi);
    //print(bmi.email.toString());
    TextEditingController _prdController = new TextEditingController();
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: mainDrawer(context),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: screenHeight / 4.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/nature.jpg'),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 90, 20, 2),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Welcome, " + widget.user.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))
                                ])),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("BMI History",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                            ])),
                    (widget.user.email == 'unregistered@pocket_doctor.com' || noBmi)
                        ? Flexible(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(230, 230, 250, 0.8),
                                    border: Border.all(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Center(
                                    child: Text(
                                  "No record of BMI",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ))))
                        : horizontalListview(context),
                    gotoCalculateBMI(context),
                    SizedBox(height: 20),
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Latest supplemental products",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                            ])),

                    //prodSummary(context),
                    productdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(
                                    child: Text(
                            titlecenter,
                            style: TextStyle(
                                color: Color.fromRGBO(101, 255, 218, 50),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ))))
                        : Flexible(
                            child: GridView.count(
                                crossAxisCount: 3,
                                childAspectRatio:
                                    (screenWidth / screenHeight) / 0.8,
                                children: List.generate(3, (index) {
                                  return Container(
                                      child: Card(
                                          color: Color.fromRGBO(
                                              230, 230, 250, 0.8),
                                          elevation: 8,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ProductScreen(
                                                                  user: widget
                                                                      .user,
                                                                )))
                                                  },
                                                  child: Container(
                                                    //height: screenHeight / 5.9,
                                                    //width: screenWidth / 3.5,
                                                    height: screenHeight / 6.4,
                                                    width: screenWidth / 4,

                                                    child: ClipRect(
                                                        child:
                                                            CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: server +
                                                          "/productimage/${productdata[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenHeight / 40,
                                                ),
                                                Text(productdata[index]['name'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                /*Text(
                                                  "RM " +
                                                      productdata[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),*/
                                                /* MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  minWidth: 100,
                                                  height: 10,
                                                  child: Text(
                                                    'Add to Cart',
                                                  ),
                                                  color: Color.fromRGBO(
                                                      101, 255, 218, 50),
                                                  textColor: Colors.black,
                                                  elevation: 10,
                                                  onPressed: () =>
                                                      _addtocartdialog(index),
                                                ),*/
                                              ],
                                            ),
                                          )));
                                }))),
                  ],
                ),
              )),
          /* bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.home,
                size: 30.0,
              ),
              title: Text('1')),
          BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.search,
                size: 30.0,
              ),
              title: Text('2')),
          BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.gratipay,
                size: 30.0,
              ),
              title: Text('3')),
        ],
        onTap: onTapped,
      ),*/
          /*floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (widget.user.email == "unregistered@pocket_doctor.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@pocket_doctor.com") {
                Toast.show("Admin mode!!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == "0") {
                Toast.show("Cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,
                            )));
                _loadData();
                _loadCartQuantity();
              }
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text(cartquantity),
          ),*/
        ));
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.5,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(server +
                                  "/productimage/${productdata[index]['id']}.jpg")))),
                ],
              ),
            ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadBmi() {
    String urlLoadJobs = server + "/php/load_bmi.php";
    http.post(urlLoadJobs, body: {/*"email": widget.user.email*/}).then((res) {
      if (res.body == "nodata") {
        titlecenter = "No record found";
        setState(() {
          noBmi = true;
        });
      } else {
        setState(() {
          /*parsedBmi = json.decode(res.body);
          //parsedBmi = extractdata["bmis"];
          print(parsedBmi);*/
          /*var extractdata = json.decode(res.body);
          bmidata = extractdata["bmis"];*/
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
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

  Widget prodSummary(BuildContext context) {
    _loadData();
    productdata == null
        ? Flexible(
            child: Container(
                child: Center(
                    child: Text(
            titlecenter,
            style: TextStyle(
                color: Color.fromRGBO(101, 255, 218, 50),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ))))
        : Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (screenWidth / screenHeight) / 0.8,
                children: List.generate(productdata.length, (index) {
                  return Container(
                      child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _onImageDisplay(index),
                                  child: Container(
                                    height: screenHeight / 5.9,
                                    width: screenWidth / 3.5,
                                    child: ClipOval(
                                        child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: server +
                                          "/productimage/${productdata[index]['id']}.jpg",
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    )),
                                  ),
                                ),
                                Text(productdata[index]['name'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(
                                  "RM " + productdata[index]['price'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "Quantity available:" +
                                      productdata[index]['quantity'],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Weight:" +
                                      productdata[index]['weigth'] +
                                      " gram",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minWidth: 100,
                                  height: 30,
                                  child: Text(
                                    'Add to Cart',
                                  ),
                                  color: Color.fromRGBO(101, 255, 218, 50),
                                  textColor: Colors.black,
                                  elevation: 10,
                                  onPressed: () => _addtocartdialog(index),
                                ),
                              ],
                            ),
                          )));
                })));
  }

  Widget horizontalListview(BuildContext context) {
    double listHeight = screenHeight / 6.8;
    double listWidth = screenWidth / 3.5;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 250, 0.8),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      height: listHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red[500],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: listWidth,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Text("BMI:"),
              Text("40"),
              Text("7:30PM 10 July",
                style: TextStyle(fontSize: 10),
              )
            ]),
            //color: Colors.red,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red[500],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: listWidth,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Text("BMI:"),
              Text("39"),
              Text("12:45PM 11 July",
                style: TextStyle(fontSize: 10),
              )
            ]),
            //color: Colors.red,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red[500],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: listWidth,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Text("BMI:"),
              Text("39"),
              Text("18:47PM 12 July",
                style: TextStyle(fontSize: 10),
              )
            ]),
            //color: Colors.red,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red[500],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: listWidth,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Text("BMI:"),
              Text("38"),
              Text("12:10PM 14 July",
                style: TextStyle(fontSize: 10),
              )
            ]),
            //color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget gotoCalculateBMI(BuildContext context) {
    return RaisedButton.icon(
      color: Colors.pink,
      elevation: 10,
      icon: Icon(MdiIcons.calculator),
      label: Text("Calculate BMI"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BMICalculatorScreen(
                      user: widget.user,
                    )))
      },

      /*child: Text(
          "Calculate BMI",
          style: TextStyle(color: Colors.black),
        )*/
    );
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text("RM " + widget.user.credit,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              backgroundImage: NetworkImage(
                  server + "/profileimages/${widget.user.email}.jpg?"),
            ),
          ),
          ListTile(
              title: Text(
                "Product List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                    gotoProd(),
                  }),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: _paymentScreen),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen2(
                                  user: widget.user,
                                )))
                  }),
         
        ],
      ),
    );
  }

  _addtocartdialog(int index) {
    if (widget.user.email == "unregistered@pocket_doctor.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@pocket_doctor.com") {
      Toast.show("Admin Mode!!!", context,
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
                "Add " + productdata[index]['name'] + " to Cart?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.white,
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
                              color: Color.fromRGBO(101, 255, 218, 50),
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(productdata[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Color.fromRGBO(101, 255, 218, 50),
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
                      _addtoCart(index);
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
            );
          });
        });
  }
 gotoProd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductScreen(
                  user: widget.user,
                )));
  }
  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@pocket_doctor.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@pocket_doctor.com") {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int cquantity = int.parse(productdata[index]["quantity"]);
      print(cquantity);
      print(productdata[index]["id"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": productdata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            productdata = null;
            curtype = type;
            titlecenter = "No product found";
          });
          pr.hide();
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            productdata = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.hide();
          });
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No product found";
                curtype = "search for " + "'" + prname + "'";
                productdata = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["products"];
                FocusScope.of(context).requestFocus(new FocusNode());
                //curtype = prname;
                curtype = "search for " + "'" + prname + "'";
                pr.hide();
              });
            }
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@pocket_doctor.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
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
        ) ??
        false;
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@pocket_doctor.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@pocket_doctor.com") {
      Toast.show("Admin mode!!!", context,
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }
}
