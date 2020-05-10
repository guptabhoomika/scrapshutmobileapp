import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'home.dart';
class ScrapCoin extends StatefulWidget {
  @override
  _ScrapCoinState createState() => _ScrapCoinState();
}

class _ScrapCoinState extends State<ScrapCoin> {
  String scrapCoins;
   _makeGetRequest() async {
    String bvalue = await storage.read(key: 'btoken');
  // make GET request
  String url = 'https://backend.scrapshut.com/user/profile/';
   Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};


  Response response = await http.get(url,headers: headers);
  // sample info available in response
  int statusCode = response.statusCode;
  print(statusCode);
  print(response.body);
  Map<String,dynamic> val =jsonDecode(response.body);
  List<dynamic> results = val['results'];
  setState(() {
      scrapCoins = results[0]["Scrapcoins"].toString();
  });

  print(scrapCoins);
  
}
@override
  void initState() {
    // TODO: implement initState
    _makeGetRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        
        children: <Widget>[
            Container(
    
            child: Text(
                "For Organiation's or student's who wants to use opensource  dataset's \n  please update your tags \n Visit: \"Developers.scrapshut.com\"\n For more INFO ",
          textAlign: TextAlign.center,
    
        ),
            padding: new EdgeInsets.all(50.0),
              height: 200,
              width: 200,
             
),
          Center(
            child: 
            Padding(
              padding: const EdgeInsets.all(60),
              child: scrapCoins == null ? CircularProgressIndicator() :
              Container(
                width:200,
                height: 100,

                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle
                ),

                
               child: Center(child: 
                Text(scrapCoins == null ? " " : scrapCoins,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
              ),
            ),
          )
        ],
      ),
      
    );
  }
}