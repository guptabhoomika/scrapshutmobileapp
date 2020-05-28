import 'package:flutter/material.dart';
class Monetize extends StatelessWidget {
 final List<String> _data = List<String>();
 //list to check if data is being transfered to first pg
 additem()
 {
   _data.add("Bhoomika");
   _data.add("Gupta");
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     
      backgroundColor: Colors.white,
      body: ListView(
      padding: EdgeInsets.all(8),
          
      
           
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  height: 150,
                   decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
                'assets/images/wiringbridge.png'),
          //fit: BoxFit.fitWidth,
        ),
        shape: BoxShape.rectangle,
      ),
                 
                ),
              ),
              
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Title*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.url,
                      
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                            
                                hintText: 'Title',
                                

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
              
              
               SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("URL*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: "URL",

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
               SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Content*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 85,
                      //color: Colors.green,
                      width: 250,
                      child: TextField(
                      
                      maxLines: 7,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: 'Content ',
                               

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
              SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  
                  //height: 200,
                  //width: 300,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    
                    color: Colors.blue,
                    onPressed: (){
                      additem();
                     Navigator.pop(context,_data);
                    },
                    child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              )
   
            
               
               
            ]
      )  
    );
  }
}