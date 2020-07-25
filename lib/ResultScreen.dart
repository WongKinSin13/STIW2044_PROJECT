
import 'package:flutter/material.dart';
import 'package:pocket_doctor/BMIModel.dart';
import 'package:pocket_doctor/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResultScreen extends StatefulWidget {

  final BMIModel bmiModel;
  final User user;
  final double height;
  final double weight;

  ResultScreen({this.user, this.bmiModel, this.height, this.weight});

  @override
  _ResultScreenState createState() => _ResultScreenState();
  
}

class _ResultScreenState extends State<ResultScreen> {
  String server = "https://pdoc1.000webhostapp.com";
  double screenHeight, screenWidth;

insertBmi() {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Saving BMI...");
    pr.show();
    http.post(server+"/php/insertBmi.php", body: {
     "email": widget.user.email,
     "bmi": widget.bmiModel.bmi.round().toStringAsFixed(0),
     "height":widget.height.round().toStringAsFixed(0),
     "weight":widget.weight.round().toStringAsFixed(0),
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "bmi added successfully") {
        Toast.show("BMI saved", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Save failedd", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: widget.bmiModel.isNormal ? Image.asset("assets/images/happy.png", fit: BoxFit.contain,) : Image.asset("assets/images/sad.png", fit: BoxFit.contain,) ,
            ),

            SizedBox(
              height: 8,
            ),
            Text("Your BMI is ${widget.bmiModel.bmi.round()}", style: TextStyle(color: Colors.red[700], fontSize: 34, fontWeight: FontWeight.w700),),
            Text("${widget.bmiModel.comments}", style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.w500),),
            /*Text(widget.user.name),
            Text(widget.bmiModel.bmi.round().toStringAsFixed(0)),
            Text(widget.height.round().toStringAsFixed(0)),
            Text(widget.weight.round().toStringAsFixed(0)),
            Text(widget.bmiModel.bmi.round().toStringAsFixed(0)),*/

            SizedBox(height: 16,),

            widget.bmiModel.isNormal ?
            Text("Hurray! Your BMI is Normal.", style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.w700),)
                :
            Text("Sadly! Your BMI is not Normal.", style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.w700),),
            SizedBox(height: 16,),
            Container(
              child: FlatButton.icon(
                onPressed: (){
                  insertBmi();
                },
                icon: Icon(Icons.save, color: Colors.white,),
                label: Text("SAVE BMI RECORD"),
                textColor: Colors.white,
                color: Colors.green,

              ),
              width: double.infinity,
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            Container(
              child: FlatButton.icon(
                onPressed: (){

                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                label: Text("LETS CALCULATE AGAIN"),
                textColor: Colors.white,
                color: Colors.red,

              ),
              width: double.infinity,
              padding: EdgeInsets.only(left: 16, right: 16),
            )
            

          ],
        ),
      )
      
    );
  }
  }

/*int reportBmi(double bmi){
  int bmiFinal;
  if(bmi >= 18.5 && bmi <= 25){
                          _bmiModel = BMIModel(bmi: _bmi, isNormal: true, comments: "You are Totaly Fit");
                        }else if(_bmi < 18.5){
                          _bmiModel = BMIModel(bmi: _bmi, isNormal: false, comments: "You are Underweighted");
                        }else if(_bmi > 25 && _bmi <= 30){
                          _bmiModel = BMIModel(bmi: _bmi, isNormal: false, comments: "You are Overweighted");
                        }else{
                          _bmiModel = BMIModel(bmi: _bmi, isNormal: false, comments: "You are Obesed");
                        }
                        return bmiFinal;
}*/
/*
var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
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
    _loadCart();*/

/*void _gotologinPage() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Go to login page?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
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
  }*/
/*class ResultScreen extends StatelessWidget {
  final bmiModel;
  
  ResultScreen({this.bmiModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              height: 200,
              width: 200,
              child: bmiModel.isNormal ? Image.asset("assets/images/happy.png", fit: BoxFit.contain,) : Image.asset("assets/images/sad.png", fit: BoxFit.contain,) ,
            ),

            SizedBox(
              height: 8,
            ),
            Text("Your BMI is ${bmiModel.bmi.round()}", style: TextStyle(color: Colors.red[700], fontSize: 34, fontWeight: FontWeight.w700),),
            Text("${bmiModel.comments}", style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.w500),),

            SizedBox(height: 16,),

            bmiModel.isNormal ?
            Text("Hurray! Your BMI is Normal.", style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.w700),)
                :
            Text("Sadly! Your BMI is not Normal.", style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.w700),),
            SizedBox(height: 16,),

            Container(
              child: FlatButton.icon(
                onPressed: (){

                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                label: Text("LETS CALCULATE AGAIN"),
                textColor: Colors.white,
                color: Colors.pink,

              ),
              width: double.infinity,
              padding: EdgeInsets.only(left: 16, right: 16),
            )

          ],
        ),
      )
    );
  }
}*/
  /*_changeName(String name) {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "name": rc.titleCase.toString(),
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.name = rc.titleCase;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }*/

