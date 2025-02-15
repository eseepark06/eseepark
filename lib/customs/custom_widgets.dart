import 'package:flutter/material.dart';

import '../globals.dart';

class Section extends StatefulWidget {
  final String title;
  final double? titleSize;
  final List<Widget>? children;

  const Section({
    super.key,
    this.titleSize,
    required this.title,
    this.children
  });

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: screenWidth * 0.02),
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.titleSize ?? screenSize * 0.014,
                      fontWeight: FontWeight.w600
                  )
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14)
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.0
              ),
              child: Column(
                children: widget.children ?? [],
              )
          )
        ],
      ),
    );
  }
}

class SectionItem extends StatefulWidget {
  final String title;
  final bool? showDivider;
  final Function()? onTap;
  const SectionItem({
    super.key,
    required this.title,
    this.showDivider,
    this.onTap
  });

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.01
        ),
        decoration: BoxDecoration(
            border: widget.showDivider != null && widget.showDivider == true ? Border(
                bottom: BorderSide(
                    color: const Color(0xFFD1D1D1),
                    width: .3
                )
            ) : null
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenSize * 0.012,
                    fontWeight: FontWeight.w400
                )
            ),
            Icon(Icons.chevron_right,
                color: const Color(0xFFD1D1D1),
                size: screenSize * 0.018
            )
          ],
        ),
      ),
    );
  }
}