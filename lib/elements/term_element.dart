import 'package:flutter/material.dart';

//кастомный виджет - ряд с иконкой условия, значением, ед. измерения и если
//это направление ветра - со стрелкой в данном направлении

class TermElement extends StatelessWidget {
  const TermElement(
      {Key key,
      @required this.text,
      @required this.icon,
      this.sign,
      this.windDirection})
      : super(key: key);

  final String text;  //данные
  final String sign;  //ед. измерения
  final String icon;  //иконка
  final String windDirection; //напр. ветра

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset('assets/icons/$icon.png'),
            ),
            Row(
              children: <Widget>[
                RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: ' ' + text,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: sign != null ? ' ' + sign : '',
                        )
                      ],
                    )),
                if (windDirection != null && windDirection != '~')
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset('assets/wd/$windDirection.png'),
                  )
              ],
            ),
          ],
        ));
  }
}
