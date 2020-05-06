






import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_auth_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';



// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {

  Authfunc auth;
  VoidCallback onSignOut;
  String userId,userEmail;

  ProfilePage({Key key, this.auth, this.onSignOut,this.userId,this.userEmail}): super(key :key);

  @override
  State<StatefulWidget> createState() => new _Profile();

}

class _Profile extends State <ProfilePage> {

  File _image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;
  bool _loading = true;


  @override
  void initState(){
    super.initState();
    _checkEmailVerification();

  }

  @override
  Widget build(BuildContext context) {

      Future getImage() async {
        var image =  await ImagePicker.pickImage(source: ImageSource.gallery);


        setState( () {
          _image=image;
          print('Image path $_image');
        });
      }

      Future uploadPic( BuildContext context) async {
          String fileName = basename(_image.path);
          StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

          setState(() {
            print("Profile Picture uploade");
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
          });
       }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Edit Profile'),
      ),
      body: Builder(
              builder: (context) => Container(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[

                    SizedBox(height:20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children:<Widget>[

                    Align(
                      alignment: Alignment.center,

                      child:CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                        child:SizedBox(
                          width:180.0,
                          height:180.0,
                          child: (_image!= null) ? Image.file(_image, fit:BoxFit.fill)
                           : Image.network("https://images.unsplash.com/photo-1584558611497-c85d2d44741a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=40",
                            fit:BoxFit.fill,
                          ),
                        ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:60.0),
                      child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                        size:30.0,
                      ), onPressed: (){
                               getImage();
                      })
                    )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(top:60.0),
                              child: Column( children: <Widget>[
                              Align(
                                 alignment: Alignment.centerLeft,
                                child: Text('nthava07@gmail.com',
                                style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18.0),
                                )
                              ),

                            ],
                            )
                          )
                        )

                      ],
                    ),

                    SizedBox(
                     height: 20.0,
                   ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0xff476cfb),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          )
                        ),
                        RaisedButton(
                            color: Color(0xff476cfb),
                            onPressed: () {
                              uploadPic(context);
                            },
                            elevation: 4.0,
                            splashColor: Colors.blueGrey,
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white, fontSize: 16.0),
                            )
                        )
                      ],
                    )
                  ],
                ),


              ),
      ),
    );


  }
  void _checkEmailVerification() async {

    _isEmailVerified = await widget.auth.IsEmailVerified();

    if(!_isEmailVerified)
      _showVerifyEmailDialog();

  }

  void _showVerifyEmailDialog() {

    showDialog(
        builder:( BuildContext context){
          return AlertDialog(
            title: new Text('Please verify your email'),
            content: new Text('We need you verify email to continue use this app'),
            actions:<Widget>[
              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
                _sendVerifyEmail();
              },child: Text('Send')),

              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Dismiss'))
            ],
          );
        }

    );
  }

  void _sendVerifyEmail() {
    widget.auth.sendEmailVerfication();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
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

}