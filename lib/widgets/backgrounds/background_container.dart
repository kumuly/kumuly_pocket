import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    Key? key,
    required this.child,
    required this.color,
    required this.assetName,
    this.appBarHeight = kToolbarHeight,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final String assetName;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        image: DecorationImage(
          image: AssetImage(assetName),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: appBarHeight),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - appBarHeight,
          child: child,
        ),
      ),
    );
  }
}
