





import 'package:flutter/material.dart';
import 'firebase_auth_util.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signin_signup_page.dart';
import 'profile.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final routes = <String, WidgetBuilder>{

    'Profile Page': (context) => ProfilePage()
  };
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BBC News Reader',
        home: new MyAppHome(auth : new  MyAuth()),
    );
  }
}

class MyAppHome extends StatefulWidget{

  MyAppHome({this.auth});

  Authfunc auth;


  @override
  State<StatefulWidget> createState()  => new _MyAppHomeState();
}

enum AuthStatus{
  NOT_LOGIN,
  NOT_DETERMINED,
  LOGIN

}

class _MyAppHomeState extends State<MyAppHome> {

  AuthStatus authStatus =AuthStatus.NOT_DETERMINED;
  String _userId="", _userEmail="";

  @override
  void initState(){
    super.initState();
    widget.auth.getCurrentUser().then((user){
        setState(() {
          if(user!=null){
            _userId=user?.uid;
            _userEmail=user?.email;
          }
          authStatus = user?.uid== null ? AuthStatus.NOT_LOGIN:AuthStatus.LOGIN;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.NOT_DETERMINED: return _showLoading();
       break;
      case AuthStatus.NOT_LOGIN:
            return new SignInSignUpPage(auth:widget.auth, onSignedIn: _onSignedIn);
             break;
      case AuthStatus.LOGIN:
            if(_userId.length > 0 && _userId!=null)
                    return new HomaPage(
                      userId:_userId,
                      userEmail:_userEmail,
                      auth:widget.auth,
                      onSignOut:_onSignOut
                    );
            else
              return _showLoading();
            break;
      default:
            return _showLoading();
            break;
    }
  }


  void _onSignOut(){
      setState(() {
        authStatus = AuthStatus.NOT_LOGIN;
        _userId=_userEmail="";
      });
  }

  void _onSignedIn(){
    widget.auth.getCurrentUser().then((user){
           setState(() {
             _userId= user.uid.toString();
             _userEmail= user.email.toString();
           });

           setState(() {
               authStatus = AuthStatus.LOGIN;
           });
    });
  }

}




Widget _showLoading() {
     return Scaffold(
            body:Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
     );
}
