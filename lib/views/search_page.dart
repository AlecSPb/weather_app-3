import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/elements/search_element.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

//экран поиска
class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //первоначальный адрес
  String address = ' ';

  @override
  Widget build(BuildContext context) {
    //доступ к настройкам темы приложения
    ThemeData theme = Theme.of(context);
    //доступ к цвету текста (который определен в main.dart)
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
                  //поле для ввода текста
                  child: TextField(
                    style: TextStyle(color: color),
                    cursorColor: theme.accentColor,
                    //при отпраке запроса, введеный адрес записывается в переменную address
                    //функция setState перерисовает окно для отображения новых данных
                    //в данном случае в коде ниже, FutureBuilder, выполнится future функция (асинохронная) с новым адресом,
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
                  //FutureBuiler: в future записывается асинхронная функция, которая делает запрос к API, чтобы получить список
                  //населенных пунков и мест с полученным адресом address.
                  //пока значение null, то возвращается текст
                  //если был сделан запрос и future выполняется, то будет возвращаен circularProgressIndicator
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
                      //когда данные получены (возвращается список) (запрос описан в services/api_service.dart),
                      //то находим длину списка и строим listView (список, в данном случае separated, то есть с разделителями)
                      //в данном случае список пролистываемый
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
                          //бывает, что GPS не определяет название населенного пункта (например, если это какая нибудь глубокая деревня),
                          //тогда он берет название из списка
                          Provider.of<WeatherProvider>(context).subDisplayName =
                              (data["formatted"] as String).split(',')[0];
                          //SearchElement - кастомный виджет (описан в elements)
                          //listView состоит из совокупности SearchElement
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
