import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../lang_model.dart';
import '../genre_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MoviePage extends StatefulWidget {
  Map data;
  MoviePage({this.data});
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Map recommendedData;
  Map similarData;
  Map reviewsData;
  Map trailerData;

  getRecommendedData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.data["id"]}/recommendations?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.recommendedData = json.decode(response.body);
    });
  }

  getSimilarData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.data["id"]}/similar?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.similarData = json.decode(response.body);
    });
  }

  getReviewsData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.data["id"]}/reviews?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.reviewsData = json.decode(response.body);
    });
  }

   getTrailerData() async {
     //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.data["id"]}/videos?api_key={your_api_key_here}&language=en-US");
    setState(() {
      this.trailerData = json.decode(response.body);
    });
  }

  

  @override
  void initState() {
    getRecommendedData();
    getSimilarData();
    getReviewsData();
    getTrailerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: recommendedData == null && similarData == null
          ? Center(child: SpinKitFadingCircle(size: 50, color: Colors.black))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height:MediaQuery.of(context).size.height*0.8,
                        width: double.infinity,
                        child: widget.data["poster_path"] == null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(80),
                                  child: Text(
                                    "Currently No Poster Found",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              )
                            : Image.network(
                                "http://image.tmdb.org/t/p/w500${widget.data["poster_path"]}",
                                fit: BoxFit.fill),
                      ),
                      SafeArea(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName("/"),
                              );
                            },
                            icon: Icon(
                              FontAwesome5Solid.home,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          child: FittedBox(
                            child: Text(
                              widget.data["title"] != null
                                  ? widget.data["title"]
                                  : widget.data["original_name"],
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Watch Trailer",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: IconButton(
                                  icon: Icon(FontAwesome.play,
                                      color: Colors.red, size: 40),
                                  onPressed: (){
                                    trailerData["results"][0]["key"]==null?null:launch("https://www.youtube.com/watch?v=${trailerData["results"][0]["key"]}");
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "RELEASE DATE:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(widget.data["release_date"],
                              style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "LANGUAGE:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                              getString(lang: widget.data["original_language"])
                                  .language(),
                              style: TextStyle(fontSize: 17)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(FontAwesome.star,
                              size: 30, color: Colors.yellowAccent),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "RATING:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                              widget.data["vote_average"] == null
                                  ? "Null"
                                  : "${widget.data["vote_average"].toString()} / 10",
                              style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "TYPE:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                              widget.data["media_type"] == null
                                  ? "Null"
                                  : widget.data["media_type"].toUpperCase(),
                              style: TextStyle(fontSize: 17)),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(
                      "GENRE CATEGORIES:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data["genre_ids"].length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 43,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              getGenre(id: widget.data["genre_ids"][index])
                                  .genreName(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(
                      "OVERVIEW:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.data["overview"] == null
                          ? Text(
                              "Currently no overview can be found for this movie")
                          : widget.data["overview"],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(
                      "SIMILAR MOVIES:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  buildSlideRow(similarData),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(
                      "RECOMMENDED MOVIES:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  buildSlideRow(recommendedData),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Text(
                            "READ REVIEW ONLINE:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch(reviewsData["results"][0]["url"]);
                          },
                          child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesome5Solid.file_alt,
                              color: Colors.blueAccent,
                              size: 80,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget buildSlideRow(Map data) {
  return Container(
    height: 300,
    child: data == null
        ? Center(child: SpinKitFadingCircle(size: 50, color: Colors.black))
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MoviePage(data: data["results"][index]);
                  }));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black26),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 170,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: data["results"][index]["poster_path"] == null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      "Currently No Poster Found",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                              : Image.network(
                                  "http://image.tmdb.org/t/p/w500${data["results"][index]["poster_path"]}",
                                  fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: FittedBox(
                          child: Text(
                              data["results"][index]["title"] != null
                                  ? data["results"][index]["title"]
                                  : data["results"][index]["original_name"],
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: data["results"].length,
          ),
  );
}
