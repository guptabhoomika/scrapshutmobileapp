import 'package:flutter/material.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interestafterSignIn.dart';
import 'package:sssocial/pages/msg.dart';
import 'package:sssocial/pages/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}
TabController _tabController;
bool img = false; 
//these bool values check whether the full screen dialog have been shown in the msg and img tab they will be true if the dialog is shown

bool msg = false;

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin{
  List<Tab> _listTab = List();
  @override
  void initState() {
    // TODO: implement initState
    _listTab.add(new Tab(text: "URL",));
    _listTab.add(new Tab(text:"Message"));
    _listTab.add(new Tab(text: "Image",));
    // TODO: implement initState
    _tabController = new TabController(length: _listTab.length,initialIndex: 0, vsync: this);
    _tabController.addListener(move);
    super.initState();
  }
   move() async
  {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Tab change");
    print(msg.toString() + " msg");
    print(img.toString() + " img");
    print(prefs.getBool("first_time").toString() + " first time");
    if(_tabController.index>0 && prefs.getBool("first_time")!=false)
    {
      if(_tabController.index == 1 && !msg)
      {
          Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog(type: "msg")));
    
    setState(() {
      msg = true;
    });
      }
    }
    if(_tabController.index == 2 && !img && prefs.getBool("first_time")!=false)
    {
        Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog(type  : "img")));
        setState(() {
          img = true;

        });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
                                      child: SingleChildScrollView(
                                        child: Column(
                      

                                          children: <Widget>[
                                            
                                          
                                            
                                        
              
         Padding(
           padding: const EdgeInsets.only(top:10),
          
             child: new TabBar(

                  controller: _tabController,
                  tabs: _listTab,
                 unselectedLabelColor: Colors.blue,
                  labelColor: Colors.blue,
                  indicatorColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  
                ),
          
         ),
            
    Container(
      height: MediaQuery.of(context).size.height,
      child: TabBarView
  
                            (
  
                              
  
                              controller: _tabController,
  
                            children: <Widget>[
  
                              URL(),
  
                              Msg(),  
  
                              Img(),
  
                              
  
                            ],
  
                                           ),
    ),
                                         //SideBar()
],
                      ),
                    ),
                  )
                
               
                

      
    );
  }
}