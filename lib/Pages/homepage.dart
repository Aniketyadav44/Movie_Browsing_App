import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './movie_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map trendingData;
  Map nowPlayingData;
  Map popularData;
  Map topRatedData;
  Map upcomingData;

  getTrendingData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/trending/all/day?api_key={your_api_key_here}");
    setState(() {
      this.trendingData = json.decode(response.body);
    });
  }

  getNowPlaying() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/now_playing?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.nowPlayingData = json.decode(response.body);
    });
  }

  getPopularData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/popular?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.popularData = json.decode(response.body);
    });
  }

  getTopRated() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/top_rated?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.topRatedData = json.decode(response.body);
    });
  }

  getUpcomingData() async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/movie/upcoming?api_key={your_api_key_here}&language=en-US&page=1");
    setState(() {
      this.upcomingData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    getPopularData();
    getNowPlaying();
    getTopRated();
    getTrendingData();
    getUpcomingData();
    super.initState();
  }

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return popularData == null &&
            nowPlayingData == null &&
            topRatedData == null &&
            trendingData == null &&
            upcomingData == null
        ? Center(child: SpinKitFadingCircle(size: 50, color: Colors.black))
        : AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(isDrawerOpen?20:0),
            ),
            height: double.infinity,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen?20:0),
                          child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 500,
                          child: Image.asset("assets/images/intro_page_img.jpg",
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: double.infinity,
                          height: 450,
                          child: Center(
                            child: Text(
                              "MOVIE TIME",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: isDrawerOpen
                              ? IconButton(
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                    });
                                  })
                              : IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      xOffset =
                                          MediaQuery.of(context).size.width * 0.6;
                                      yOffset =
                                          MediaQuery.of(context).size.height *
                                              0.2;
                                      scaleFactor = 0.6;
                                      isDrawerOpen = true;
                                    });
                                  }),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "TRENDING",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    buildSlideRow(trendingData),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right:20,top:20),
                        child: Divider(color:Colors.grey[900]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "UPCOMING",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    buildSlideRow(upcomingData),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right:20,top:20),
                        child: Divider(color:Colors.grey[900]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "POPULAR",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    buildSlideRow(popularData),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right:20,top:20),
                        child: Divider(color:Colors.grey[900]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "NOW PLAYING",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    buildSlideRow(nowPlayingData),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right:20,top:20),
                        child: Divider(color:Colors.grey[900]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "TOP RATED",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    buildSlideRow(topRatedData),
                  ],
                ),
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
