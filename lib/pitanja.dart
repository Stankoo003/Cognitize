import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/main.dart';
import 'package:video/profile.dart';

class PitanjaScreen extends StatefulWidget {
  final String ime;

  const PitanjaScreen({super.key, required this.ime});
  static const String uri = "http://192.168.0.108:5000/pitaj/";

  @override
  State<PitanjaScreen> createState() => _PitanjaScreenState();
}

class _PitanjaScreenState extends State<PitanjaScreen> {
  String pitanje = "";
  bool poslato = false;

  Future<String> SaljiPoruku(String string) async {
      final response =
          await http.get(Uri.parse(PitanjaScreen.uri+"/"+widget.ime + "/" + string));
      if (response.statusCode == 200) {
        print(PitanjaScreen.uri);
        return response.body;
      } else {
        throw Exception(
            "Error fetching data: Status code ${response.statusCode}");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      appBar: AppBar(
        backgroundColor: Color(0xFF292a3e),
        title: Text(
          "Pitanja",
          style: TextStyle(
              fontSize: 30.0,
              color: Color(0xFFC99750),
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      pitanje = value;
                    },
                    style: TextStyle(color: Color(0xFFC99750)),
                    decoration: InputDecoration(
                      fillColor: Color(0xFFC99750),
                      hintText: "Šta je RAM?",
                      focusColor: Color(0xFFC99750),
                      labelText: "Unesite Vaše pitanje",
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Pošalji poruku!"),
                  onPressed: () {
                    setState(() {
                      poslato = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC99750),
                    padding: EdgeInsets.all(20.2),
                    fixedSize: Size(300, 80),
                    textStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    shadowColor: Color(0xFFC99750),
                    elevation: 15,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 64,
            thickness: 0.6,
            color: Color(0xFFC99750),
            indent: 16,
            endIndent: 16,
          ),
          DonjiProstor(),
        ],
      ),
    );
  }

  Widget DonjiProstor() {
    if(poslato) {
    return FutureBuilder<String>(
          future: SaljiPoruku(pitanje),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, bottom: 24.0),
                  child: Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                        overflow: TextOverflow.fade,
                        fontSize: 10.0,
                        color: Color(0xFFC99750),
                        fontWeight: FontWeight.w800),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else
              return CircularProgressIndicator();
          },
        );
    }
    else
    {
      return SizedBox();
    }
  }
}
