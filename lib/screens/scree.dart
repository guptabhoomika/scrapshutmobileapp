import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interest.dart';
import 'package:sssocial/pages/msg.dart';
import 'package:sssocial/pages/scrapcoin.dart';
import 'package:sssocial/pages/url.dart';
class Main extends StatefulWidget {
  //bool isAuth;
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    
return Scaffold(

  body: Container(
    height: MediaQuery.of(context).size.height,
    width: double.infinity,
    child: DefaultTabController(
      child: Scaffold(
         appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.blue[100],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(25),
                    child: Container(
                      color: Colors.transparent,
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Colors.red
                                        , width: 6.0),
                                    insets: EdgeInsets.fromLTRB(
                                        40.0, 20.0, 40.0, 0)),
                                indicatorWeight: 15,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 12,
                                   
                                    fontWeight: FontWeight.bold),
                                unselectedLabelColor: Colors.white,
                                tabs: [
                                  Tab(
                                    text: "URL",
                                    
                                  ),
                                  Tab(
                                    text: "MESSAGE",
                                   
                                  ),
                                  Tab(
                                    text: "IMAGE",
                                  
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ),
                drawer: Drawer(
                 child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Scrashut For Deeptech'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Logout'),
        onTap: () {
          print("Trying to logout");
          print("Unauth screen should be built");
          Home().method();

         
         
          
         
        
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('Interests'),
        onTap: () {
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Interest()),
  );
        },
      ),
      ListTile(
        title: Text("Scrapcoins"),
        onTap: (){
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScrapCoin()),
  );

        },
      )
    ],
  ),
                ),
                  body: TabBarView(
                  children: <Widget>[
                    URL(),
                    Msg(),  
                    Img(),
                    
                  ],
                )
                ), 
                length: 3,
                )
                )
                
      );
      
      
  
  

  }
}