import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    Key? key,
    required this.child,
    this.color,
    required this.assetName,
    this.appBarHeight = kToolbarHeight,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final String assetName;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      padding: EdgeInsets.only(top: appBarHeight),
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        image: DecorationImage(
          matchTextDirection: true,
          image: AssetImage(assetName),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
      child: child,
    );
  }
}
