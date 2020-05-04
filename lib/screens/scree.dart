import 'package:flutter/material.dart';
import 'package:sssocial/pages/interest.dart';

import '../pages/img.dart';
import '../pages/url.dart';
import '../pages/msg.dart';
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
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
          //logout();
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
