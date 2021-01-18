import 'package:flutter/material.dart';

class AboutMeTab extends StatelessWidget {
  final String aboutMe;

  const AboutMeTab({Key key,@required this.aboutMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.1),
              ),
            ],
          ),
          child: Text(aboutMe??"",style: Theme.of(context).textTheme.headline3),
        ),
      ],
    );
  }
}
