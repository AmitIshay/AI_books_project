

import 'package:flutter/cupertino.dart' show StatelessWidget, BuildContext, Widget, Container, MediaQuery, EdgeInsets, Border, BorderRadius, BoxDecoration;
import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';

class CommentCard  extends StatelessWidget {
  final Map objComments;

  const CommentCard({super.key, required this.objComments});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 23),
      child: Container(
        width: media.width*0.6,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child:
        Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_circle, color: TColor.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${objComments["user"]?.toString() ?? "Unknown user"}:${objComments["comment"]?.toString() ?? ""}"
                ,style: TextStyle(
                    color: TColor.subTitle,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 8),

            ]
        )
      ));
  }
}