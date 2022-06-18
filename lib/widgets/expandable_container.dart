import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget collapsedChild;
  final Widget expandedChild;

  const ExpandableContainer({
    Key key,
    @required this.collapsedChild,
    @required this.expandedChild,
    this.collapsedHeight,
    this.expandedHeight,
    this.expanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // duration: const Duration(milliseconds: 500),
      // curve: Curves.easeIn,
      width: Device.screenWidth,
      padding: EdgeInsets.all(16.0),
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: expanded ? expandedChild : collapsedChild,
        // decoration: BoxDecoration(border: Border.all(width: 1.0, color: Theme.of(context).primaryColor),),
      ),
    );
  }
}
