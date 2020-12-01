import 'package:flutter/material.dart';

class DynamicFlexibleSpaceBarTitle extends StatefulWidget {
  /// this widget changing bottom padding of title according scrollposition of flexible space
  /// child which will be displayed as title
  @required
  final Widget child;

  DynamicFlexibleSpaceBarTitle({this.child});

  @override
  State<StatefulWidget> createState() => _DynamicFlexibleSpaceBarTitleState();
}

class _DynamicFlexibleSpaceBarTitleState extends State<DynamicFlexibleSpaceBarTitle> {
  ScrollPosition _position;
  double _bottomPadding = 16; /// default padding
  EdgeInsets _dynamicMargin = EdgeInsets.only();
  double _dynamicOpacity = 0.0;

  final double maxLeftMargin = 36.0;
  final double maxRightMargin = 26.0;
  final double maxBottomPadding = 17.0;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _removeListener();
    _addListener();
    super.didChangeDependencies();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() => _position?.removeListener(_positionListener);

  void _positionListener() {
    /// when scroll position changes widget will be rebuilt
    final FlexibleSpaceBarSettings settings =
    context.dependOnInheritedWidgetOfExactType();
    setState(() {
      _bottomPadding = getPadding(settings.minExtent.toInt(), settings.maxExtent.toInt(), settings.currentExtent.toInt());
      _dynamicMargin = getMargin(settings.minExtent.toInt(), settings.maxExtent.toInt(), settings.currentExtent.toInt());
      _dynamicOpacity = getOpacity(settings.minExtent.toInt(), settings.maxExtent.toInt(), settings.currentExtent.toInt());
    });
  }

  double getOpacity(int minExtent, int maxExtent, int currentExtent) {
    double leftMarginExtent = (maxExtent - minExtent) / (maxLeftMargin);
    for (var i = 0; i < maxLeftMargin; i++) {
      if (currentExtent >= minExtent + (i * leftMarginExtent) &&
          currentExtent <= minExtent + ((i+1) * leftMarginExtent) && i < maxLeftMargin/4) {
        return 1 - i.toDouble()*4/maxLeftMargin;
      }
    }
    return 0.0;
  }

  double getPadding(int minExtent, int maxExtent, int currentExtent) {
    double onePaddingExtent = (maxExtent - minExtent) / maxBottomPadding;
    for (var i = 0; i < maxBottomPadding; i++) {
      if (currentExtent >= minExtent + (i * onePaddingExtent) &&
          currentExtent <= minExtent + ((i+1) * onePaddingExtent)) {
        return maxBottomPadding - i - 1;
      }
    }
    return 0;
  }

  EdgeInsets getMargin(int minExtent, int maxExtent, int currentExtent) {
    double leftMarginExtent = (maxExtent - minExtent) / maxLeftMargin;
    double rightMarginExtent = (maxExtent - minExtent) / maxRightMargin;
    double leftMargin = 5;
    double rightMargin = 5;

    for (var i = 0; i < maxLeftMargin; i++) {
      if (currentExtent >= minExtent + (i * leftMarginExtent) &&
          currentExtent <= minExtent + ((i+1) * leftMarginExtent)) {
        leftMargin = maxLeftMargin - i.toDouble() - 1;
      }
    }

    for (var j = 0; j < maxRightMargin; j++) {
      if (currentExtent >= minExtent + (j * rightMarginExtent) &&
          currentExtent <= minExtent + ((j+1) * rightMarginExtent)) {
        rightMargin = maxRightMargin - j.toDouble() - 1;
      }
    }

    return EdgeInsets.only(left: leftMargin, right: rightMargin);
  }

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: _dynamicOpacity,
    child: Container(
        padding: EdgeInsets.only(bottom: _bottomPadding),
        margin: _dynamicMargin,
        child: widget.child
    ),
  );
}