import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../genre_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import './movie_page.dart';

class queryData extends StatefulWidget {
  @override
  _queryDataState createState() => _queryDataState();
}

class _queryDataState extends State<queryData> {
  Map queryData;

  getQueryData(String query) async {
    //put your registered api key in place of {your_api_key_here} in url below
    http.Response response = await http.get(
        "https://api.themoviedb.org/3/search/movie?query=$query&api_key={your_api_key_here}&language=en-US&page=1&include_adult=false");
    setState(() {
      this.queryData = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            FittedBox(
              child: Center(
                child: Text("SEARCH MOVIES",
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    cursorColor: Colors.black54,
                    onSubmitted: (value) {
                      getQueryData(value);
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Container(
              color: Colors.cyanAccent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 174,
              child: queryData == null
                  ? ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(80),
                          child: Text(
                            "Enter a movie name to Search...",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SpinKitFadingCircle(color: Colors.black, size: 50),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MoviePage(
                                  data: queryData["results"][index]);
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                  height: 230,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 170,
                                  height: 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: queryData["results"][index]
                                                ["poster_path"] ==
                                            null
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
                                            "http://image.tmdb.org/t/p/w500${queryData["results"][index]["poster_path"]}",
                                            fit: BoxFit.fill),
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                          0.97) -
                                      190,
                                  height: 230,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: FittedBox(
                                          child: Text(
                                              queryData["results"][index]
                                                          ["title"] !=
                                                      null
                                                  ? queryData["results"][index]
                                                      ["title"]
                                                  : queryData["results"][index]
                                                      ["original_name"],
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: queryData["results"][index]
                                                  ["genre_ids"]
                                              .length,
                                          itemBuilder: (context, ind) {
                                            return Container(
                                              height: 43,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  getGenre(
                                                          id: queryData[
                                                                      "results"]
                                                                  [index][
                                                              "genre_ids"][ind])
                                                      .genreName(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(FontAwesome.star,
                                              size: 30,
                                              color: Colors.yellowAccent),
                                          SizedBox(width: 10),
                                          Text(
                                              queryData["results"][index]
                                                          ["vote_average"] ==
                                                      null
                                                  ? "Null"
                                                  : "${queryData["results"][index]["vote_average"].toString()} / 10",
                                              style: TextStyle(fontSize: 17)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: queryData["results"].length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
