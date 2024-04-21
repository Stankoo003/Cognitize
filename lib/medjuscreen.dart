import 'package:flutter/material.dart';
import 'package:video/main.dart';
import 'package:video/pitanja.dart';

class medjuScreen extends StatelessWidget {
  final String ime;

  const medjuScreen({super.key,required this.ime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      appBar: AppBar(
        backgroundColor: Color(0xFF292a3e),
        title: Text(
          ime,
          style: TextStyle(
              fontSize: 30.0,
              color: Color(0xFFC99750),
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: Text("Materijal"),
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC99750),
                padding: EdgeInsets.all(20.2),
                fixedSize: Size(300, 80),
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                shadowColor: Color(0xFFC99750),
                elevation: 15,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: Text("Podseċanje"),
              onPressed: () {
           
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(name: ime),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC99750),
                padding: EdgeInsets.all(20.2),
                fixedSize: Size(300, 80),
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                shadowColor: Color(0xFFC99750),
                elevation: 15,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: Text("Postavi pitanje?"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PitanjaScreen(ime: ime),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC99750),
                padding: EdgeInsets.all(20.2),
                fixedSize: Size(300, 80),
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                shadowColor: Color(0xFFC99750),
                elevation: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
