import 'package:pocket_doctor/BMIModel.dart';
import 'package:pocket_doctor/ResultScreen.dart';
import 'package:flutter/material.dart';
import 'package:pocket_doctor/user.dart';

class BMICalculatorScreen extends StatefulWidget {
  final User user;

  const BMICalculatorScreen({Key key, this.user}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double userHeight = 100.0;
  double userWeight = 40.0;
  double screenHeight, screenWidth;
  double _bmi = 0;

  BMIModel _bmiModel;

  @override
  Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          //padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                      children: <Widget>[
                        Container(
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight/4.8,
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
                              Text("BMI Calculator",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ])),
                      ],
                    ),
              /*Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/images/heart.png",
                  fit: BoxFit.contain,
                ),
              ),*/
              SizedBox(
                height: screenHeight/10,
              ),
              Text(
                "Height (cm)",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  min: 80.0,
                  max: 250.0,
                  onChanged: (height) {
                    setState(() {
                      userHeight = height;
                    });
                  },
                  value: userHeight,
                  divisions: 170,
                  activeColor: Colors.pink,
                  label: "$userHeight",
                ),
              ),
              Text(
                "$userHeight cm",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Weight (kg)",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  min: 30.0,
                  max: 150.0,
                  onChanged: (height) {
                    setState(() {
                      userWeight = height;
                    });
                  },
                  value: userWeight,
                  divisions: 120,
                  activeColor: Colors.pink,
                  label: "$userWeight",
                ),
              ),
              Text(
                "$userWeight kg",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: screenHeight/10,
              ),
              Container(
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _bmi = userWeight /
                          ((userHeight / 100) * (userHeight / 100));

                      if (_bmi >= 18.5 && _bmi <= 25) {
                        _bmiModel = BMIModel(
                            bmi: _bmi,
                            isNormal: true,
                            comments: "You are Totaly Fit");
                      } else if (_bmi < 18.5) {
                        _bmiModel = BMIModel(
                            bmi: _bmi,
                            isNormal: false,
                            comments: "You are Underweighted");
                      } else if (_bmi > 25 && _bmi <= 30) {
                        _bmiModel = BMIModel(
                            bmi: _bmi,
                            isNormal: false,
                            comments: "You are Overweighted");
                      } else {
                        _bmiModel = BMIModel(
                            bmi: _bmi,
                            isNormal: false,
                            comments: "You are Obesed");
                      }
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultScreen(
                                user: widget.user, 
                                bmiModel: _bmiModel,height: userHeight,
                                weight: userWeight,)));
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  label: Text("CALCULATE"),
                  textColor: Colors.white,
                  color: Colors.pink,
                ),
                width: double.infinity,
                padding: EdgeInsets.only(left: screenWidth/15, right: screenWidth/15, bottom:screenWidth/8),
              ),
              SizedBox(
                height: screenHeight*0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
