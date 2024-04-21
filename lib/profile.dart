import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String uri = "http://192.168.0.100:5000/predmeti";

  
  Future<List<String>> fetchNames() async {
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode==200){
      return List<String>.from(jsonDecode(response.body)['nazivi']);
    }else{
      throw Exception("Doslo je do greske prilikom ucitavanja predmeta");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      appBar: AppBar(
        backgroundColor: Color(0xFF292a3e),
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 30.0,
              color: Color(0xFFC99750),
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Text(
              "Aleksa",
              style: TextStyle(
                  color: Color(0xFFC99750),
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            subtitle: Text("Stankovic",
                style: TextStyle(
                    color: Color(0xFFC99750), fontWeight: FontWeight.w600)),
            leading: CircleAvatar(
              child: Icon(
                Icons.perm_identity,
                color: Colors.white,
              ),
              radius: 50,
            ),
          ),
          Divider(
            height: 64,
            thickness: 0.6,
            color: Color(0xFFC99750),
            indent: 16,
            endIndent: 16,
          ),
          FutureBuilder<List<String>>(
            future: fetchNames(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 10,),
                          ElevatedButton(
                            child: Text(snapshot.data![index].toString()),
                            onPressed: () {
                              Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(name: snapshot.data![index].toString()),
      ),
    );


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
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
          
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}