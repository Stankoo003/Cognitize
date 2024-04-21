import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:video/profile.dart'; // it will allows us to get the pi constant

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String name;

  HomePage({required this.name});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 static String uri = "http://192.168.0.108:5000/pitanja/";

  String front = "";
  String back = "";
  int listElementCounter = 0;
  int dynamicDuration=700;

  Future<List<Map<String, dynamic>>> fetchQuestionData() async {
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          "Error fetching data: Status code ${response.statusCode}");
    }
  }

  //declare the isBack bool
  bool isBack = true;
  double angle = 0;
  int _selectedIndex = 1;
  List<Map<String, dynamic>> listaPredmeta = [];
  int currentQuestionIndex = 0;
  //late List<Map<String, String>> listaPredmeta;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
      dynamicDuration = 500;
    });
  }

  void changeQuestion() {}

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      if (listaPredmeta.length -1 > listElementCounter) {
        
        if (index == 0) {
          if(angle>3)
          _flip();
          dynamicDuration=400;
            
          listElementCounter++;
          print("Lako selected!");
           front = listaPredmeta[listElementCounter]["prednja"];
        back = listaPredmeta[listElementCounter]["zadnja"];
        } else if (index == 1) {
          dynamicDuration=400;
           if(angle>3)
            _flip();
          listElementCounter++;
          print("Tesko selected!");
          front = listaPredmeta[listElementCounter]["prednja"];
          back = listaPredmeta[listElementCounter]["zadnja"];
        }
       
      }
    });
  }

  @override
  void initState() {
    uri = "http://192.168.0.108:5000/pitanja/"+widget.name;
    
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      listaPredmeta = await fetchQuestionData();
      if (listaPredmeta.isNotEmpty) {
        _setInitialQuestion(); // Set initial question values
      } else {
        print("Lista pitanja je prazna.");
      }
    } catch (error) {
      print("Error fetching data: $error");
      // Consider showing a user-friendly error message here
    }
  }

  void _setInitialQuestion() {
    if (listaPredmeta.isNotEmpty) {
      setState(() {
        
        front = listaPredmeta[0]["prednja"]!;
        back = listaPredmeta[0]["zadnja"]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292a3e),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFC99750)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ),
      backgroundColor: Color(0xFF292a3e),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _flip,
                child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: angle),
                    duration: Duration(milliseconds: dynamicDuration),
                    builder: (BuildContext context, double val, __) {
                      if (val >= (pi / 2)) {
                        isBack = false;
                      } else {
                        isBack = true;
                      }
                      return (Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(val),
                        child: Container(
                            width: 309,
                            height: 474,
                            child: isBack
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: AssetImage("assets/back.png"),
                                      ),
                                    ),
                                    
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                        
                                          front,
                                          
                                          style: TextStyle(
                                              overflow: TextOverflow.fade,
                                              fontSize: 25.0,
                                              color: Color(0xFFC99750),
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    
                                  )
                                : Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(pi),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: AssetImage("assets/face.png"),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                        
                                          back,
                                          
                                          style: TextStyle(
                                              overflow: TextOverflow.fade,
                                              fontSize: 20.0,
                                              color: Color(0xFFC99750),
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  )),
                      ));
                    }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFC99750),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: "Lako"),
          BottomNavigationBarItem(icon: Icon(Icons.thumb_down), label: "Tesko"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "Preuzmi"),
        ],
      ),
    );
  }
}
