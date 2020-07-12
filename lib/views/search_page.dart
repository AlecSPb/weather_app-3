import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/elements/search_element.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String address = ' ';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color color = theme.textTheme.headline1.color;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Provider.of<WeatherProvider>(context).secondAccent,
        title: Text(
          'Поиск',
          style: TextStyle(color: theme.accentColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
          color: theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: color),
                    cursorColor: theme.accentColor,
                    onSubmitted: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Найти',
                        labelStyle: TextStyle(color: color),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: color)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: color),
                        )),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: Provider.of<WeatherProvider>(context)
                        .openCageCall(address),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Provider.of<WeatherProvider>(context)
                                        .secondAccent),
                              )),
                        );
                      }
                      if (snapshot.data == null) {
                        return Container(
                          height: 100,
                          child: Text(
                            'Здесь появятся результаты',
                            style: TextStyle(color: color),
                          ),
                        );
                      }
                      int len = snapshot.data.length;
                      print(len);
                      return ListView.separated(
                        itemCount: len + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Text(
                              'Результатов: $len',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: color),
                            );
                          }
                          Map data = snapshot.data[index - 1];
                          Provider.of<WeatherProvider>(context).subDisplayName =
                              (data["formatted"] as String).split(',')[0];
                          return SearchElement(
                            index: index,
                            description: data["formatted"],
                            lat: data["geometry"]["lat"],
                            lon: data["geometry"]["lng"],
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
