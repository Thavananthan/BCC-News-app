
import 'package:flutter/material.dart';
import 'package:nreader/article_view.dart';
import 'package:nreader/helper/news.dart';
import 'package:nreader/models/article_model.dart';

class CategoryNews extends StatefulWidget {

  final String category;
  CategoryNews({this.category});
  @override
  _CategoryNews createState() => _CategoryNews();
}

class _CategoryNews extends State<CategoryNews> {

  List <ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,

        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text('BBC NEWS'),
            ]
        ),
        actions: <Widget>[
          Opacity(
              opacity: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.save),
              )
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body:_loading ? Center(
    child:Container(
    child: CircularProgressIndicator(),
    )): SingleChildScrollView(
     child: Container(
        child: Column(
          children:<Widget>[
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
          ]
        )
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

