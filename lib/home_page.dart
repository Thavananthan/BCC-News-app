




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nreader/article_view.dart';
import 'package:nreader/category_news.dart';
import 'package:nreader/helper/data.dart';
import 'package:nreader/helper/news.dart';
import 'package:nreader/models/article_model.dart';
import 'package:nreader/models/categori_model.dart';
import 'firebase_auth_util.dart';
import 'profile.dart';


class HomaPage extends StatefulWidget {

  Authfunc auth;
  VoidCallback onSignOut;
  String userId,userEmail;


  HomaPage({Key key, this.auth, this.onSignOut,this.userId,this.userEmail}): super(key :key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomaPage> {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    List<CategoryModel> categories = new List <CategoryModel>();
    List <ArticleModel> articles = new List<ArticleModel>();
    bool _isEmailVerified = false;
    bool _loading = true;


  @override
     void initState(){
       super.initState();
       _checkEmailVerification();
       categories = getCategories();
       getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

     return new Scaffold(
       appBar: new AppBar(
          backgroundColor: Colors.red,
           title : Text('BBC NEWS'),
           actions:<Widget>[
             FlatButton.icon(onPressed:(){
               Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage() ), );
             },icon:Icon(Icons.person_outline, color:Colors.white), label: Text('profile',
               style:TextStyle(
                 fontWeight: FontWeight.bold,
                 color:Colors.white
               ),)),
             FlatButton.icon(onPressed: _signOut,
             icon:Icon(Icons.phonelink_lock, color:Colors.white), label: Text('SignOut',
               style:TextStyle(
                   fontWeight: FontWeight.bold,
                   color:Colors.white
               ),)),
           ],

     ),
     body:_loading ? Center(
         child:Container(
       child: CircularProgressIndicator(),
     )): SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical:5 ),
          child: Column(
         children: <Widget>[


           /// Categories
           Container(
             padding: EdgeInsets.symmetric(horizontal: 16,vertical:5 ),
             height: 70,
             child: ListView.builder(
                itemCount : categories.length,
                shrinkWrap: true,
               scrollDirection: Axis.horizontal,
               itemBuilder: (context, index){
                  return CategoryTitle(
                    imageUrl: categories[index].imageUrl,
                    categoryName:categories[index].categoryName,
                  );
               },
             )
           ),
           /// Blogs
         Container (
           padding: EdgeInsets.only(top:16),
         child: ListView.builder(
            itemCount: articles.length,
             shrinkWrap: true,
             physics: ClampingScrollPhysics(),
             itemBuilder: (context, index){
              return BlogTitle(
                imageUrl: articles[index].urlToImage,
                title: articles[index].title,
                desc: articles[index].description,
                url: articles[index].url,
              );
            }),
       )
         ],
       ),
     )
     )


     );
  }

  void _checkEmailVerification() async {

    _isEmailVerified = await widget.auth.IsEmailVerified();
    
    if(!_isEmailVerified)
          _showVerifyEmailDialog();
    
  }

  void _showVerifyEmailDialog() {
    
    showDialog( context: context ,
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




  void _signOut() async{
    try{
      await widget.auth.SignOut();
      widget.onSignOut();
    }catch(e){
       print(e);
    }

  }
}
 class CategoryTitle extends StatelessWidget {
  final String imageUrl, categoryName;

  CategoryTitle({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
       onTap: () {
         Navigator.push( context, MaterialPageRoute(builder:(context) => CategoryNews(
            category: categoryName.toString().toLowerCase(),
         )
         ));
       },
       child: Container(
         margin: EdgeInsets.only( right: 16),
         child: Stack(
           children: <Widget>[
             ClipRRect(
               borderRadius: BorderRadius.circular(6),
               child: CachedNetworkImage( imageUrl: imageUrl, width: 120, height:60, fit: BoxFit.cover,)
            ),
             Container(
               alignment: Alignment.center,
               width: 120, height: 60,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(6),
                 color: Colors.black26,
               ),

               child: Text(categoryName, style: TextStyle(
                 color: Colors.white,
                 fontSize: 14,
                 fontWeight: FontWeight.w500
               )),
             )
           ],
         ),
       ),
     );
  }
 }
 
 class BlogTitle extends StatelessWidget {

  final String imageUrl, title, desc, url;
  BlogTitle({@required this.imageUrl, @required this.title, @required this.desc, @required this.url});

  @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: () {
          Navigator.push( context, MaterialPageRoute(builder:(context) => ArticleView(
               blogUrl: url,
          )
          ));
       },
         child: Container(
       margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
           ClipRRect(
             borderRadius: BorderRadius.circular(6),
            child: Image.network(imageUrl),
            ),
            SizedBox(height: 8,),
            Text(title, style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w600
            ),),
            Text(desc, style: TextStyle(
              color: Colors.black54
            ),)

          ],
        ),
     ),
     );
   }
 }
 
