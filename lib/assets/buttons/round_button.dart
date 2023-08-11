import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color buttonColor;
  final Color textColor;

  const RoundButton({
    Key? key, // Added Key parameter here
    required this.title,
    required this.onPress,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      // borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: buttonColor,
        minWidth: MediaQuery.of(context).size.width - 200,
        height: MediaQuery.of(context).size.height -
            800, // Added height to ensure consistent size
        clipBehavior: Clip.antiAlias,
        onPressed: onPress,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
