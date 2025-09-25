// ================= Expandable Text =================
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  const ExpandableText(this.text, {super.key, this.trimLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool readMore = false;

  @override
  Widget build(BuildContext context) {
    final span = TextSpan(
      text: widget.text,
      style: const TextStyle(color: Colors.white70, fontSize: 16),
    );

    final tp = TextPainter(
      text: span,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 64);
    final isOverflow = tp.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          maxLines: readMore ? null : widget.trimLines,
          overflow: TextOverflow.fade,
        ),
        if (isOverflow)
          InkWell(
            onTap: () {
              setState(() {
                readMore = !readMore;
              });
            },
            child: Text(
              readMore ? "Read Less" : "Read More",
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
