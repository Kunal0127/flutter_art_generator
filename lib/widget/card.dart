import 'package:flutter/material.dart';

const kValue = 15.0;

Padding card({
  required int index,
  required Alignment alignment,
  required bool isBot,
  required String message,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: kValue,
      horizontal: kValue,
    ),
    child: Stack(
      children: [
        Align(
          alignment: alignment,
          child: isBot
              ? const CircleAvatar(
                  radius: 18,
                  child: Icon(
                    Icons.ac_unit_rounded,
                  ),
                )
              : const CircleAvatar(
                  radius: 18,
                  child: Icon(
                    Icons.person,
                  )),
        ),
        Align(
          alignment: alignment,
          child: Container(
            margin: isBot
                ? EdgeInsets.only(right: kValue / 2, left: kValue * 3.6)
                : EdgeInsets.only(left: kValue / 2, right: kValue * 3.6),
            padding: isBot
                ? EdgeInsets.symmetric(
                    horizontal: kValue * 1.2, vertical: kValue / 1.2)
                : EdgeInsets.symmetric(
                    horizontal: kValue * 1.2, vertical: kValue / 1.2),
            decoration: BoxDecoration(
              color: isBot ? Colors.white : Colors.green[400],
              borderRadius: isBot
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(kValue * 3.33),
                      bottomRight: Radius.circular(kValue * 3.33),
                      topRight: Radius.circular(kValue * 3.33),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(kValue * 3.33),
                      bottomLeft: Radius.circular(kValue * 3.33),
                      topLeft: Radius.circular(kValue * 3.33),
                    ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(kValue / 5, kValue / 5),
                  blurRadius: kValue * 0.5,
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isBot ? Colors.green[400] : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
