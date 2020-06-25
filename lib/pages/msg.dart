import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sssocial/services.dart';


import '../widgets/loader.dart';
import 'home.dart';
import 'monetizePage.dart';

class Msg extends StatefulWidget {
  @override
  _MsgState createState() => _MsgState();
}
final storage = new FlutterSecureStorage();

class _MsgState extends State<Msg> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _message;
  TextEditingController _review;
    List<String> _monteizedata = List<String>();
  TextEditingController _tags;
  int ratings;
   bool _validateU = false;
   bool _validateR = false;
    bool _validateT = false;
    bool isfake = false;
    bool isanonymous = false;
    bool isFetching = false;
    bool ispressed= false;
  
  @override
void initState() {
    _message = TextEditingController();
    _review = TextEditingController();
    _tags = TextEditingController();
  
    // TODO: implement initState
    super.initState();
  }  
  
_showSnackBar(int stauscode) {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: stauscode == 201 ? new Text("Succesful") : new Text("There is some error"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: stauscode == 201 ? 'Ok' : "Try Again",textColor: Colors.white, onPressed: (){
         _review.clear();_tags.clear();;ratings=0;
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  _makePostReq(String content,List<String> tags,int rating,String review) async
  {
    setState(() {
      isFetching = true;
    });
        String bvalue = await storage.read(key: 'btoken');

  String url = 'https://backend.scrapshut.com/api/msg/';
  Map<String, String> headers = {"Authorization":"JWT ${bvalue}",
"Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
  String json = jsonEncode({
			"rate": rating,
            "content": content,
            "review": review,
            // "url": urlC,
            // "tags":tags
            "fake": isfake,
            "anonymous": isanonymous,
});
  //print(json);

  // make POST request

  Response response = await post(url,headers: headers, body: json);
  print(response.body);
  setState(() {
    isFetching =false;
  });
   int statusCode = response.statusCode;
   print(statusCode);
    if(statusCode == 201)
   {
       print("statusCode");
     print(statusCode);
     _showSnackBar(statusCode);

   }
  else
  {
    Services.sendmail(response.body);
  }
  }
  // Widget build(BuildContext context) {
    Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
      padding: EdgeInsets.all(8),
          
      
           
            children: <Widget>[
              Container(
                height: 220,
                width: 150,
                    decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/scrap_withoutbg.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
      ), 
               
              ),
              // Text("The More data you give = the more data you get",style: TextStyle(color: Colors.red),),
              // Text("developers.scrapshut.com",style: TextStyle(color: Colors.red)),
              // SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Message:*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        
                        controller: _message,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                            
                                hintText: 'Message',
                                 errorText: _validateU ? 'Value Can\'t Be Empty' : null,

                                hintStyle: TextStyle(color: Colors.grey,),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   Text("Rating*",style: TextStyle(color: Colors.grey)),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: RatingBar(
   initialRating: 0,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating:false,
   itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: ( rating) {
    ratings = rating.toInt();
   },
),
                   )

                ],
              ),
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Review*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 250,
                      child: TextField(
                        controller: _review,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: "Review helps others identify false comments",
                                 errorText: _validateR ? 'Value Can\'t Be Empty' : null,

                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],
              ),
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Tags*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        controller: _tags,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: 'Use , to seperate tags ',
                                 errorText: _validateT ? 'Value Can\'t Be Empty' : null,

                                hintStyle: TextStyle(color: Colors.grey,),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],

              ),
               CheckboxListTile(
                 dense: true,
                 value: isfake, 
               onChanged: (val){
                 setState(() {
                   isfake = val;
                 });
               },
               title: Text("Might be Fake"),
               controlAffinity: ListTileControlAffinity.leading
               ),
                CheckboxListTile(
                 dense: true,
                 value: isanonymous, 
               onChanged: (val){
                 setState(() {
                   isanonymous = val;
                 });
               },
               title: Text("Make this Anonymous"),
               controlAffinity: ListTileControlAffinity.leading
               ),
             
              Container(
              
                height: isFetching == true ? 200 : 100,
                width: isFetching == true ? 200 : 100,
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 0.0,
                  color: isFetching== true ? Colors.white : Colors.blue,
                  child: isFetching==true ? loader(200, 200) : Text("Submit",style: TextStyle(color: Colors.white),),
                  onPressed: ()  {
                     setState(() {
                  _message.text.isEmpty ? _validateU = true : _validateU = false;
                  _review.text.isEmpty ? _validateR = true : _validateR = false;
                  _tags.text.isEmpty ? _validateT = true : _validateT = false;
                });
                    _makePostReq(_message.text, _tags.text.toString().split(",").toList(),ratings, _review.text);
                  },
                ),
              ),
           Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  
                  //height: 200,
                  //width: 300,
                  alignment: Alignment.center,
                  child: ispressed ? Card(
                    elevation: 2.0,
                                      child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                        children: <Widget>[
                          Text("We are working on it."), 
                          Text("Keep in touch for furhter updates"),
                        ],
                    ),
                      )),
                  ) :
                   RaisedButton(
                    elevation: 3.0,
                    color: Colors.red,
                  //   onPressed: () async{
                  //  final result =    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Monetize()));
                  //      setState(() {
                  //       _monteizedata = result;
                  //      });

                      
                  //   },
                  onPressed: (){
           
                      setState(() {
                        ispressed = true;
                      });
              
                  },
                    child: Text("Monetize this Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
            
          ),
      
      
    );
  }
}



  // margin: const EdgeInsets.only(left: 50.0, right: 20.0),

  //                     decoration: new BoxDecoration(
  //       image: DecorationImage(
  //         image: new AssetImage(
  //             'assets/images/kira.png'),
  //         fit: BoxFit.fill,
  //       ),
  //       shape: BoxShape.rectangle,
  //     ),