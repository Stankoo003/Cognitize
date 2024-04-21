import 'package:flutter/material.dart';

class PitanjaScreen extends StatelessWidget {
  const PitanjaScreen({super.key});

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
            height: 100,
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Color(0xFFC99750),
                      hintText: "Šta je VHDL?",
                      
                      labelText: "Unesite Vaše pitanje",
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Pošalji poruku!"),
                  onPressed: () {
                    //TODO SLANJE PORUKE
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
          Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: Text(
              "Respond Text",
              style: TextStyle(
                  overflow: TextOverflow.fade,
                  fontSize: 25.0,
                  color: Color(0xFFC99750),
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
