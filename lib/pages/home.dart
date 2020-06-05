


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sssocial/models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';
import 'package:flutter/cupertino.dart';
// import fit_image;

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interest.dart';
import 'package:sssocial/pages/interestAfterSignIn.dart';
import 'package:sssocial/pages/url.dart';
import 'package:sssocial/screens/scree.dart';


import 'msg.dart';
// declaring storage varaibles
final storage = new FlutterSecureStorage();
String auth="https://backend.scrapshut.com/a/google/";


// declaring signing
final googlesignin= GoogleSignIn();
class Home extends StatefulWidget{ 
 
// this method is called  from scree folder which calls logout function to logout user
  method() => createState().logout();

// login function present in home.dart  
  login() => createState().login();

  @override
_HomeState createState() =>  _HomeState();
  
  

 
}

// class _HomeState {
// }

class _HomeState extends State<Home>{
 
bool isAuth =false;
String token ='';
String value='';
bool g = false;
String gtoken='';
isfirsttime() async
{
  print("method called");
  SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getBool('first_time') == false)
{
  print(prefs.getString("name"));
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Main(name: prefs.getString("name"))));
}
else
{
  print('in else');
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>InterestA()));
}
}
check() async
{
    SharedPreferences prefs = await SharedPreferences.getInstance();

print("isauth    "+prefs.getBool("isAuth").toString());
print("firsttime  " + prefs.getBool('first_time').toString());
if(prefs.getBool("isAuth")==true)
{
    isfirsttime();

}

else 
{
  print("in else");
   
 buildUnAuthScreen();
  print("unauth");
  setState(() {
    g = true;
  });
  
 
 
 
}
}

String name;
@override
// initial state checking if user is authenticated or not 
void initState() {
  
super.initState();

check();

}
// this function is  triggered when ever user uses google to signin
 login() async  {
  googlesignin.signIn().then((result){
        result.authentication.then((googleKey) async {
          var gtoken = googleKey.accessToken;
          // print(gtoken);
          await storage.write(key: 'token', value: gtoken);
          String value = await storage.read(key: 'token');
          print(value);
          print("sucess post");
     
          Map<String,String> headers = {'Content-Type':'application/json'};
          final msg = jsonEncode({"token":"$value"});
          print(msg);

          var response = await http.post(auth ,body:msg,

          headers: headers

          );
 if(response.statusCode == 200) {
   setState(() {
     isAuth = true;
   });
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
     name = responseJson['username'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
      
      setbool();
print("value of g " + g.toString());
if(g)
{
  isfirsttime();
}

      
      
     
      
    }
   else{
     print(response.statusCode);
     print("not success");
   } 
          });
  });
}

// this function is troggered whenever user clicks logout from scree.dart in screens 
 Future logout() async {
    try {
      //await _fireBaseAuthInstance.signOut();
      await  googlesignin.disconnect();
      await googlesignin.signOut();
    } catch (e) {
      print('Failed to signOut' + e.toString());
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAuth", false);
    
      
    g = false;
   
  print(g.toString() + " g");
   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

setbool() async
{
  print("set bool called");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("name", name);
      prefs.setBool("isAuth", true);
      
      print(prefs.getBool("first_time").toString() + " before if");
        if(prefs.getBool("first_time")==null){
            prefs.setBool('first_time',false);
        }
      
      
      //initState();
}

// whenever isAuth=False i.e if user isnt authenticated this screen is showed to him
 Scaffold buildUnAuthScreen(){
 return Scaffold(
    body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/scrap_withoutbg.png"),fit: BoxFit.cover)
                ),
              ),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
     
 );
}
Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        print("Tap");
        login();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

@override

  Widget  build(BuildContext context){
    
// if isAuth value is true then it will call IntrestA which will trigger intrestaftersignin page 
// else it will show the buildUnAuthScreen()
    return isAuth  ? InterestA() : buildUnAuthScreen();
    
  
  }
  
}