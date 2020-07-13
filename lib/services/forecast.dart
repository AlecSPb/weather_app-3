import 'package:intl/intl.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/forecast_models.dart';
import 'package:weather_app/services/translation.dart';

//один из главных классов - прогноз

class Forecast {
  String nowCloudness, //текущее состояние погоды
      pressure, //давление
      humidity, //влажность
      windSpeed,  //скорость ветра
      time, //время
      windDirecton, //направление ветра 
      icon, //изображение погоды
      timezone, //часовой пояс
      clouds, //облачность
      uvi;  //УФ индекс
  List<HourlyForecast> hourlyForecast;  //прогноз на 24 часа (список из прогнозов на каждый час)
  List<WeeklyForecast> weeklyForecast;  //прогноз на 7 дней (список из прогнозов на каждый  день)
  int timeOffset; //часовая зона относительно UTC
  double temperature, feelsLike;  //температура, ощущается как
  
  //конструктор при инициализации приложения
  Forecast(
      {this.time = ' ',
      this.nowCloudness = ' ',
      this.pressure = '~',
      this.humidity = '~',
      this.windSpeed = '~',
      this.windDirecton = '~',
      this.icon = 'blank',//пустая картинка
      this.clouds = '~',
      this.temperature = 0,
      this.feelsLike = 0});
  
  //функция перевода дат (т.к. даты первоначально на английском)
  //переводы в services/translation
  String _translator(String data, bool type) {
    //для каждого элемента словаря, если нашлось нужное слово для перевода
    //то заменить его значением
    dayTranslationMap.forEach((key, translate) {
      if (data.contains(key)) {
        data = data.replaceFirst(key, translate);
      }
    });
    //type - перевод месяца
    if (type == true) {
      monthTranslationMap.forEach((key, translate) {
        if (data.contains(key)) {
          data = data.replaceFirst(key, translate);
        }
      });
    }
    return data;
  }
  
  //API возвращает направление в градусах, поэтому они переводятся в 
  //более понятный для человека формат
  String _getWindDirection(int degrees) {
    if (degrees < 180) {
      if (degrees >= 0 && degrees < 25) {
        return 'С';
      } else if (degrees >= 25 && degrees < 65) {
        return 'С-В';
      } else if (degrees >= 65 && degrees < 115) {
        return 'В';
      } else if (degrees >= 115 && degrees < 155) {
        return 'Ю-В';
      } else if (degrees >= 155 && degrees < 180) {
        return 'Ю';
      } else {
        return 'ошибка';
      }
    } else {
      if (degrees >= 180 && degrees < 205) {
        return 'Ю';
      } else if (degrees >= 205 && degrees < 245) {
        return 'Ю-З';
      } else if (degrees >= 245 && degrees < 295) {
        return 'З';
      } else if (degrees >= 295 && degrees < 335) {
        return 'С-З';
      } else if (degrees >= 335 && degrees <= 360) {
        return 'С';
      } else {
        return 'ошибка';
      }
    }
  }
  
  //перевод и форматирование даты в вид год, месяц, день, часы, минуты
  String _timeFormatter(DateTime time) {
    return _translator(DateFormat.yMMMMd().add_Hm().format(time), true);
  }
  
  //поиск длины дня (от рассвета до заката)
  String _dayLength(int sunrise, int sunset) {
    Duration dayLen = DateTime.fromMillisecondsSinceEpoch(sunset * 1000)
        .difference(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000));
    return '${dayLen.inHours}ч ${dayLen.inMinutes - (dayLen.inHours * 60)}м';
  }

  //второй конструктор, который вызвается при получении данных
  //dynamic - грубо говоря "заглушка", или любой тип данных
  Forecast.fromJson(Map<String, dynamic> data, int timezoneOffset) {
    
    timeOffset = data["timezone_offset"];

    List<HourlyForecast> hourlyList = [];

    print('start - SUCCESS');
    
    //заполнение списка почасового прогноза
    //заполнение объекта класса происходит с помощью каскада (..)
    for (int i = 0; i < 24; i++) {
      var item = data["hourly"][i];
      HourlyForecast tmp = new HourlyForecast()
        ..time = DateFormat.Hm()
            .format(DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000))
        ..icon = item["weather"][0]["icon"]
        ..weatherType = item["weather"][0]["description"]
        ..localTime = _timeFormatter(DateTime.fromMillisecondsSinceEpoch(
            (item["dt"] - timezoneOffset + timeOffset) * 1000))
        ..pressure = (item["pressure"] * 0.750062).round().toString()
        ..humidity = (item["humidity"]).toString()
        ..clouds = (item["clouds"]).toString()
        ..windSpeed = (item["wind_speed"]).toString()
        ..windDirection = _getWindDirection(item["wind_deg"])
        ..temp = item["temp"].toDouble()
        ..feelsLike = item["feels_like"].toDouble();

      hourlyList.add(tmp);
    }

    print('hourly - SUCCESS');

    List<WeeklyForecast> weeklyList = [];

    //заполнение списка недельного прогноза
    for (int i = 0; i < 8; i++) {
      var item = data["daily"][i];

      WeeklyForecast tmp = new WeeklyForecast()
        ..time = _translator(
            DateFormat.MMMMd()
                .format(DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000)),
            true)
        ..weekday = _translator(
            DateFormat.EEEE()
                .format(DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000)),
            false)
        ..sunrise = DateFormat.Hm()
            .add_Md()
            .format(DateTime.fromMillisecondsSinceEpoch(item["sunrise"] * 1000))
        ..sunset = DateFormat.Hm()
            .add_Md()
            .format(DateTime.fromMillisecondsSinceEpoch(item["sunset"] * 1000))
        ..humidity = item["humidity"].toString()
        ..pressure = (item["pressure"] * 0.750062).round().toString()
        ..windSpeed = item["wind_speed"].toString()
        ..windDirection = _getWindDirection(item["wind_deg"])
        ..weatherType = item["weather"][0]["description"]
        ..clouds = item["clouds"].toString()
        ..icon = item["weather"][0]["icon"]
        ..dayLength = _dayLength(item["sunrise"], item["sunset"])
        ..uvi = item["uvi"].round().toString()
        ..localSunrise = DateFormat.Hm().add_Md().format(
            DateTime.fromMillisecondsSinceEpoch(
                (item["sunrise"] - timezoneOffset + timeOffset) * 1000))
        ..localSunset = DateFormat.Hm().add_Md().format(
            DateTime.fromMillisecondsSinceEpoch(
                (item["sunset"] - timezoneOffset + timeOffset) * 1000))
        ..tempDay = item["temp"]["day"].toDouble()
        ..tempNight = item["temp"]["night"].toDouble()
        ..tempMorning = item["temp"]["morn"].toDouble()
        ..tempEvening = item["temp"]["eve"].toDouble()
        ..feelsLikeDay = item["feels_like"]["day"].toDouble()
        ..feelsLikeEvening = item["feels_like"]["eve"].toDouble()
        ..feelsLikeMorning = item["feels_like"]["morn"].toDouble()
        ..feelsLikeNight = item["feels_like"]["night"].toDouble();

      weeklyList.add(tmp);
    }

    print('weekly - SUCCESS');
    
    //заполнение текущего прозноза
    this
      ..time = _translator(
          DateFormat.MMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(
              data["current"]["dt"] * 1000)),
          true)
      ..temperature = data["current"]["temp"].toDouble()
      ..nowCloudness = 'Сейчас ' + data["current"]["weather"][0]["description"]
      ..hourlyForecast = hourlyList
      ..weeklyForecast = weeklyList
      ..feelsLike = data["current"]["feels_like"].toDouble()
      ..pressure = (data["current"]["pressure"] * 0.750062).round().toString()
      ..humidity = data["current"]["humidity"].toString()
      ..windSpeed = data["current"]["wind_speed"].toString()
      ..windDirecton = _getWindDirection(data["current"]["wind_deg"])
      ..icon = data["current"]["weather"][0]["icon"]
      ..timezone = data["timezone"]
      ..clouds = data["current"]["clouds"].toString()
      ..uvi = data["current"]["uvi"].toDouble().round().toString();

    print('end - SUCCESS');
  }
}
