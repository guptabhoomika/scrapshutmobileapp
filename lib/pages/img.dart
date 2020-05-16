import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/loader.dart';
import 'home.dart';

class Img extends StatefulWidget {
  @override
  _ImgState createState() => _ImgState();
}
// importing flutter storage
final storage = new FlutterSecureStorage();
// adding texteditingcontroller to field called tags
TextEditingController _tags;

class _ImgState extends State<Img> {
  // declaring di
  Dio dio = new Dio();
  File img;
  bool isfake = false;
    bool isanonymous = false;
    bool isFetching = false;

  @override
  void initState() {
    // TODO: implement initState
    _tags = TextEditingController();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var imgPicker;
  // snackbar  for showing responses error sucess 
  showSnackBar(int stauscode) {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: stauscode == 201
          ? new Text("Succesful")
          : new Text("There is some error"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black,
      action: new SnackBarAction(
          label: stauscode == 201 ? 'Ok' : "Try Again",
          textColor: Colors.white,
          onPressed: () {}),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showSnackBara() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: new Text("Image Selected.Press submit to continue"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black,
      action: new SnackBarAction(
          label: 'OK', textColor: Colors.white, onPressed: () {}),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // AssetImage assetImage =AssetImage("assets/images/scrap_withoutbg.png");
    // Image image=Image(image:assetImage,width: 150,height: 220,);
    // return Container(child :image);
     Response response;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
// body :<Widget>[]
      body: ListView(
        children: <Widget>[
          Container(
            height: 220,
            width: 150,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new AssetImage('assets/images/scrap_withoutbg.png'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            child: RaisedButton(
              color: Colors.red,
              child:
                  Text("SELECT IMAGE", style: TextStyle(color: Colors.white)),
                  // whenever select image button is clicked Imagepicker will open gallery  and user can pick an image
              onPressed: () async {
                
                imgPicker =
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                if (imgPicker != null) {
                  setState(() {
                    img = imgPicker;
                  });
                  // if the image file isnt empty show the snackbar
                  showSnackBara();
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Tags*", style: TextStyle(color: Colors.grey)),
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
                      //errorText: _validateT ? 'Value Can\'t Be Empty' : null,

                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
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
          // fake checkbox
          CheckboxListTile(
                 dense: true,
                 value: isfake, 
               onChanged: (val){
                 setState(() {
                   isfake = val;
                 });
               },
               title: Text(" Might be Fake"),
               controlAffinity: ListTileControlAffinity.leading
               ),
              //  anonymous checkbox
                CheckboxListTile(
                 dense: true,
                 value: isanonymous, 
               onChanged: (val){
                 setState(() {
                   isanonymous = val;
                 });
               },
               title: Text(" Make this Anonymous"),
               controlAffinity: ListTileControlAffinity.leading
               ),
             
          //submitbutton
          Container(
            alignment: Alignment.center,
            height: isFetching==true ?  200 : 100,
            width: isFetching==true ?  200 : 100,
            child: RaisedButton(
              color: isFetching==true? Colors.white : Colors.blue,
              elevation: 0.0,
              child: isFetching==true? loader(200, 200) : Text("SUBMIT", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() {
                  isFetching = true;
                });
                try {
                  // getting the image by splitting / and storing it in variable called filename
                  String filename = img.path.split("/").last;
                  

                  final mimeTypeData =
                      lookupMimeType(img.path, headerBytes: [0xFF, 0xD8])
                          .split('/');
                  List<String> tags = _tags.text.toString().split(",").toList();
                  var list = jsonEncode(tags);
                  print(list);
                    // making it into form data for endpoint
                  FormData formData = new FormData.fromMap({
                    "picture": await MultipartFile.fromFile(img.path,
                        filename: filename,
                        contentType:
                            MediaType(mimeTypeData[0], mimeTypeData[1])),
                            "tags" : list,
                            "fake": isfake,
                           "anonymous": isanonymous,
                    //print(_tags.
                  });
            
                        String url = "https://backend.scrapshut.com/api/img/";
                  String bvalue = await storage.read(key: 'btoken');

                  Dio dio = new Dio();
                  dio.options.headers['content-Type'] = 'application/json';
                  dio.options.headers["Authorization"] = "JWT ${bvalue}";

                  response = await dio.post(url, data: formData);
                  print(tags);
                 
                

                  //  Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMywidXNlcm5hbWUiOiJteGlvbmhhY2tpbmciLCJleHAiOjE1ODgyMDEyOTksImVtYWlsIjoibXhpb25oYWNraW5nQGdtYWlsLmNvbSJ9.PfdjRrn2who64Es02d7flVLSF4Hp31u9Sw2NigVtlH8",

                  // "Content-Type":"application/json"};

                  // Response response = await dio.post(url,data: formData,options: Options(headers: headers));

                  print(response.statusCode);
                  print(response);
                  setState(() {
                    isFetching = false;
                  });
                  if(response.statusCode == 201)
                  {
                    print(_tags.text.toString().split(",").toList());
                  showSnackBar(response.statusCode);

                  }
                  // if there is status code of 401 then logout will be triggered
                else if(response.statusCode == 401)
   {
     final snackBar = new SnackBar(
        content: Text("Unauthorized access"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "LogOut",textColor: Colors.white, onPressed: (){
          Home().method();
              
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);

   }
     else if(response.statusCode == 500)
   {
     final snackBar = new SnackBar(
        content: Text("Server error please contact team@scrapshut.com"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
         
              
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);

   }
  else if(response.statusCode == 400)
   {
    
   
     final snackBar = new SnackBar(
        content: Text(response.statusMessage),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
              
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);

   }
    
  

            
                  
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
