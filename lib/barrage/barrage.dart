import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'barrage_transition.dart';

class Barrage extends StatefulWidget {
  final int showCount;
  static String selectBarrageId = '0';
  final double padding;
  final int randomOffset;
  final Function(String name) onPressed;

  Barrage(
      {Key key,
      this.showCount = 10,
      this.padding = 8,
      this.randomOffset = 0,
      this.onPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BarrageState();
}

class BarrageState extends State<Barrage> {
  List<_BarrageTransitionItem> _barrageList = [];
  Timer _timer;
  Random _random = Random();
  double _height;
  int barrageIndex = 0;
  List<int> speedInt = [15, 14, 13, 12, 11, 10];
  Duration _kDuration;

  addBarrage({String dec, String userId, String name, String img}) {
    double perRowHeight = (_height - 3 * widget.padding) / widget.showCount;
    _kDuration = Duration(seconds: speedInt[Random().nextInt(speedInt.length)]);
    var index = 0;
    if (_barrageList.length == 0) {
      index = 0;
      barrageIndex++;
    } else {
      index = barrageIndex++;
    }
    var top = _computeTop(index, perRowHeight);
    if (barrageIndex > 100000) {
      barrageIndex = 0;
    }
    var bottom = _height - top - perRowHeight;
    String id = '${DateTime.now().toIso8601String()}:${_random.nextInt(1000)}';
    var item = _BarrageTransitionItem(
      id: id,
      top: top,
      bottom: bottom,
      onComplete: _onComplete,
      duration: _kDuration,
      dec: dec,
      userId: userId,
      name: name,
      img: img,
      onPressed: widget.onPressed,
    );
    _barrageList.add(item);
    if (mounted) {
      setState(() {});
    }
  }

  _onComplete(id) {
    _barrageList.removeWhere((f) {
      return f.id == id;
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _barrageList.removeWhere((f) {
        return false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraintType) {
        _height = constraintType.maxHeight;
        return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(
            children: []..addAll(_barrageList),
          ),
        );
      },
    );
  }

  _computeTop(int index, double perRowHeight) {
    int num = (index / widget.showCount).floor();
    var top;
    top = (index % widget.showCount) * perRowHeight + widget.padding;

    if (num % 2 == 1 && index % widget.showCount != widget.showCount - 1) {
      top -= perRowHeight / 2;
    }
    if (widget.randomOffset != 0 && top > widget.randomOffset) {
      top += _random.nextInt(widget.randomOffset) * 2 - widget.randomOffset;
    }
    return top;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _barrageList.clear();
    super.dispose();
  }
}

// ignore: must_be_immutable
class _BarrageTransitionItem extends StatelessWidget {
  _BarrageTransitionItem(
      {this.id,
      this.top,
      this.bottom,
      this.child,
      this.onComplete,
      this.duration,
      this.dec,
      this.userId,
      this.name,
      this.img,
      this.onPressed});

  final String id;
  final double top;
  final double bottom;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;
  var _key = GlobalKey<BarrageTransitionState>();
  final String dec;
  final String userId;
  final String name;
  final String img;
  final Function(String name) onPressed;

  bool get isComplete => _key.currentState.isComplete;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: top,
      bottom: bottom,
      child: BarrageTransition(
        key: _key,
        onComplete: (v) {
          onComplete(id);
        },
        duration: duration,
        desc: dec,
        id: userId,
        name: name,
        img: img,
        barrageId: id,
        onPressed: onPressed,
      ),
    );
  }
}
