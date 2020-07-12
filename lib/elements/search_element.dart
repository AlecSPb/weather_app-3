import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/provider.dart';

class SearchElement extends StatelessWidget {
  SearchElement({Key key, this.index, this.description, this.lat, this.lon})
      : super(key: key);

  final int index;
  final String description;
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).textTheme.headline1.color;
    return GestureDetector(
      onTap: () {
        Provider.of<WeatherProvider>(context, listen: false)
            .getWeatherCall(lat, lon);
        Navigator.pop(context);
      },
      child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  '$description',
                  softWrap: true,
                  style: TextStyle(color: color),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                ),
              ),
            ],
          )),
    );
  }
}
