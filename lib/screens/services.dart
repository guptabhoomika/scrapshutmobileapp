import 'package:sssocial/pages/home.dart';

logout(){
    googlesignin.signOut();

   storage.delete(key: 'btoken');
   storage.delete(key: 'token');
   
  
   
   


    
}