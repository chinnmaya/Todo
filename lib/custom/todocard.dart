import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class todocard extends StatelessWidget {
  const todocard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconcolor,
      required this.time,
      required this.check,
      required this.iconbgcolor,
      required this.onchanged,
      required this.index})
      : super(key: key);
  final String title;
  final IconData iconData;
  final Color iconcolor;
  final String time;
  final bool check;
  final Color iconbgcolor;
  final Function onchanged;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Theme(
          child: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              activeColor: Color(0xff6cf8a9),
              checkColor: Color(0xff0e3e26),
              value: check,
              onChanged: (value) {
                onchanged(index);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          data: ThemeData(
            primarySwatch: Colors.blue,
            unselectedWidgetColor: Color(0xff5e616a),
          ),
        ),
        Expanded(
          child: Container(
            height: 75,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Color(0xff2a2e3d),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 33,
                    width: 36,
                    decoration: BoxDecoration(
                      color: iconbgcolor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      iconData,
                      color: iconcolor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
