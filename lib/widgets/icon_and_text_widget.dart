import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_app/widgets/small_text.dart';


class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const IconAndTextWidget({Key? key,
    required this.text,
    required this.icon,
    required this.iconColor
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,size:10),
        SizedBox(width:2,),
        SmallText(text: text,),
      ],
    );
  }
}
