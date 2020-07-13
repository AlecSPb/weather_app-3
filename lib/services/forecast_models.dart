
//модели прогнозов

class HourlyForecast {
  String time,  //время
      icon, //иконка погоды
      weatherType,  //тип погоды
      localTime,  //мест. время в данной зоне
      pressure, //давление
      humidity, //влажность
      clouds, //облачность
      windSpeed,  //скорость ветра
      windDirection;  //направлеие ветра
  double temp, feelsLike; //температура, ощущается как
}

class WeeklyForecast {
  String time,  //вермя
      weekday,  //день недели
      icon, //иконка погоды
      sunrise,  //время восхода
      sunset, //время заката 
      tempMax,  //макс температура (не исп.)
      tempMin,  //мин температура (не исп.)
      pressure, //давление
      humidity, //влажность
      windSpeed,  //скорость ветра
      windDirection,  //направлеие ветра
      weatherType,  //тип погоды
      clouds, //облачность
      dayLength,  //продолжительность дня
      localSunrise, //восход по мест. времени
      localSunset,  //закат по мест. времени
      uvi;  //УФ-индекс
  double tempDay, //температура днем
      tempNight,  //ночью
      tempEvening,  //вечером
      tempMorning,   //утром
      feelsLikeDay, //ощущается как днем
      feelsLikeMorning, //утром
      feelsLikeEvening, //вечером
      feelsLikeNight; //ночью
}
