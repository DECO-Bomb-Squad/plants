import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';

class CommentManager {
  Column getComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded (
              flex: 1,
              child: Icon(Icons.account_circle, size: 40,)
            ),
            Expanded (
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Username", style: subheaderStyle),
                  Text("15 minutes ago")
                ],
              )
            )
          ]
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: const [
                  Icon(Icons.arrow_upward),
                  Text("20", style: textStyle,),
                  Icon(Icons.arrow_downward)
                ],
              )
            ),
            const Expanded(
              flex: 4,
              child: Text(
              "dfjklskdfsj ksdjhfksdhjfksjdh fkjsdh f kjshdfjk hsdjkfh sdjkfh skdjf ksjdhf ksjdhf kjs dfk hsd kfjh sdkjfh skejdh fiksh j"
              )
            )
          ]
        )
      ],
    );
  }
}