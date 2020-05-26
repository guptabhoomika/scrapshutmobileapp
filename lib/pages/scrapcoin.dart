import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../widgets/loader.dart';
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
                "Reinvent the wheel of advertisements like never before  \n  you can  be an brand influencer and advertise anything for free \n on Wiringbridge APP \n Based on ScrapCoins ",
          textAlign: TextAlign.center,
    
        ),
            padding: new EdgeInsets.all(50.0),
              height: 250,
              width: 200,
             
),
          Center(

            child: 
            Padding(

              padding: const EdgeInsets.all(55),
              
              child: scrapCoins == null ?  loader(200,600) :
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