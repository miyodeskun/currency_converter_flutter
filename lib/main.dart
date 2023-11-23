// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Currency Converter",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double screenHeight, screenWidth, resWidth;

  // Create Controller
  final textController = TextEditingController();

  // Set Variables
  String selectCur1 = "USD";
  String selectCur2 = "MYR";
  String convert = "_";
  List<String> curList = [
    "MYR",
    "JPY",
    "SGD",
    "USD",
    "THB",
  ];
  // In the list of currencies only 5 different types.

  double result = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          centerTitle: true,
          title: const Text(
            'Converter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.grey.shade400,
                  labelText: "Input your value to convert",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight / 10,
                    width: resWidth / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      itemHeight: 60,
                      value: selectCur1,
                      onChanged: (newValue) {
                        setState(() {
                          selectCur1 = newValue.toString();
                        });
                      },
                      items: curList.map((selectCur1) {
                        return DropdownMenuItem(
                          child: Text(
                            selectCur1,
                          ),
                          value: selectCur1,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 32),
                  FloatingActionButton(
                    onPressed: _loadCurrencies,
                    child: Icon(Icons.swap_horiz),
                    elevation: 0,
                    backgroundColor: Colors.blue.shade900,
                  ),
                  SizedBox(width: 32),
                  Container(
                    height: screenHeight / 10,
                    width: resWidth / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      itemHeight: 60,
                      value: selectCur2,
                      onChanged: (newValue) {
                        setState(() {
                          selectCur2 = newValue.toString();
                        });
                      },
                      items: curList.map((selectCur2) {
                        return DropdownMenuItem(
                          child: Text(
                            selectCur2,
                          ),
                          value: selectCur2,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 90,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Result",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      result.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _loadCurrencies() async {
    var apiKey = 'INSERT YOUR API KEY HERE';
    var url = Uri.parse(
        'https://free.currconv.com/api/v7/convert?q=$selectCur1$convert$selectCur2&apiKey=$apiKey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      double rate =
          parsedJson['results']['$selectCur1$convert$selectCur2']['val'];
      print(rate);

      setState(() {
        result = rate * double.parse(textController.text);
        // Parsing the string into double to calculate the rate
      });
    } else {
      print("Failed to connect API.");
    }
  }
}
