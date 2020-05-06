





import 'package:flutter/material.dart';
import 'firebase_auth_util.dart';


enum STATE{
  SIGNIN,SIGNUP
}

class SignInSignUpPage extends StatefulWidget {


  Authfunc auth;
  VoidCallback onSignedIn;


  SignInSignUpPage({this.auth, this.onSignedIn});
  

  @override
  State<StatefulWidget> createState() => new  _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {

  final _formkey = new GlobalKey<FormState>();
  String _email,_password,_errrorMessage;
  STATE _formState=STATE.SIGNIN;

  bool _isIos,_isLoading;

  bool _ValidateAndSave(){
    final form = _formkey.currentState;
    if(form.validate()){
        form.save();
        return true;
    }
    return false;
  }

  void _ValidateAndSubmit() async{
    setState(() {
         _errrorMessage = "";
         _isLoading= true;

    });

    if(_ValidateAndSave()){
      String userId ="";

      try{
        if(_formState == STATE.SIGNIN){
          userId= await widget.auth.SignIn(_email, _password);
        }
         else{
           userId= await widget.auth.SignUp(_email, _password);
           widget.auth.sendEmailVerfication();
           _showVerifyEmailSentDialog();

        }
         setState(() {
            _isLoading=false;
         });

         if(userId.length > 0 && userId!= null && _formState == STATE.SIGNIN)
           widget.onSignedIn();
      }catch(e){
        print(e);

        setState(() {
            _isLoading = false;
            if(_isIos)
              _errrorMessage = e.details;
            else
              _errrorMessage= e.message;

        });
      }
    }
  }

  @override
    void initState(){
    super.initState();
    _errrorMessage = "";
    _isLoading= false;
  }

  void  _changeFormToSignUp(){
     _formkey.currentState.reset();
     _errrorMessage = "";

     setState(() {
        _formState = STATE.SIGNUP;
     });
  }

  void _changeFormSignIn(){
    _formkey.currentState.reset();
    _errrorMessage = "";

    setState(() {
      _formState = STATE.SIGNIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
      body:Stack(
        children: <Widget>[
          showBody(),
          showCircularProgress(),
        ]
      )
    );
  }



  void _showVerifyEmailSentDialog() {
    showDialog( context: context ,
        builder:( BuildContext context){
          return AlertDialog(
              title: new Text('Thank you'),
              content: new Text('Link verify has been sent to your email'),
              actions:<Widget>[
          new FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('OK'))
          ],
          );
        }

    );

  }

  showCircularProgress() {
    if(_isLoading)
      return Center ( child : CircularProgressIndicator(),);
      return Container( height: 0.0, width: 0.0,);

  }

  showBody() {
      return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formkey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showText(),
              _showEmailInput(),
              _showPasswordInput(),
              _showButton(),
              _showAskQuestion(),
              _showErrorMessage(),
            ],
          )
        )
      );
  }

 Widget _showErrorMessage() {

    if(_errrorMessage.length > 0 && _errrorMessage != null){
          return new Text(_errrorMessage, style: TextStyle( fontSize: 14.0,
                          color:Colors.red,
                          height:1.0,
                          fontWeight: FontWeight.w300),);
    }else {

       return new Container(height:0.0, width:0.0);
      }
    }

  Widget _showAskQuestion() {

    return new FlatButton(onPressed: _formState == STATE.SIGNIN
                        ? _changeFormToSignUp
                        :_changeFormSignIn,
                       child: _formState == STATE.SIGNIN
                        ? new Text('Create an account',
                           style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.w300))
                         : new Text(
                            'Already ? Just Sign In',
                            style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300),
                          ));

  }

 Widget _showButton() {

    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height:40.0,
          child:RaisedButton(onPressed: _ValidateAndSubmit,
          elevation: 5.0,
              shape: new RoundedRectangleBorder( borderRadius: new BorderRadius.circular(30)),
              color:Colors.red,
              child: _formState == STATE.SIGNIN ? new Text('BBC News', style:TextStyle(fontSize: 20.0, color:Colors.white),)
                  : new Text('SIGN  UP',style:TextStyle(fontSize: 20.0,color:Colors.white),)
          ),
        ),
        );
 }

  _showPasswordInput() {

    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
            maxLines: 1,
            keyboardType:TextInputType.emailAddress,
            obscureText: true,
            autofocus:false,
            decoration: new InputDecoration(
            hintText: 'Enter password',
            icon:Icon(Icons.lock, color:Colors.grey)),
          validator:(value) => value.isEmpty ? 'password can not be empty':null,
          onSaved: (value) =>_password=value.trim(),
    ),
    );
  }

  _showEmailInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType:TextInputType.emailAddress,
        autofocus:false,
        decoration: new InputDecoration(
            hintText: 'Enter Email',
            icon:Icon(Icons.mail, color:Colors.grey)),
        validator:(value) => value.isEmpty ? 'email can not be empty':null,
        onSaved: (value) =>_email=value.trim(),
      ),
    );
  }

  _showText() {
    return new Hero(
      tag:'here',
      child:Padding(
        padding:EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child:_formState == STATE.SIGNIN ? Center( child: Text(
          'SIGN IN',
          style:TextStyle(fontSize: 40.0,
          color:Colors.red,
          fontWeight: FontWeight.bold),
        ),): Center(child :Text(
          'SIGN UP',
          style:TextStyle(fontSize: 40.0,
           color:Colors.red,
          fontWeight: FontWeight.bold)
        ),),
      ),
    );
  }
  


  }

