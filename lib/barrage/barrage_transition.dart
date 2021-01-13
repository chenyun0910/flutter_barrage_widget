import 'package:flutter/material.dart';
import 'package:flutter_barrage_widget/barrage/widget_ext.dart';
import 'package:flutter_barrage_widget/eventbus/event_bus.dart';

import 'barrage.dart';

class BarrageTransition extends StatefulWidget {
  const BarrageTransition(
      {Key key,
      @required this.duration,
      this.onComplete,
      this.direction = TransitionDirection.rtl,
      this.desc,
      this.id,
      this.name,
      this.img,
      this.barrageId,
      this.onPressed})
      : super(key: key);

  final Duration duration;
  final TransitionDirection direction;
  final ValueChanged onComplete;
  final String desc;
  final String id;
  final String name;
  final String img;
  final String barrageId;
  final Function(String name) onPressed;

  @override
  State<StatefulWidget> createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;
  int type = 0;
  bool get isComplete => _animationController.isCompleted;

  @override
  void initState() {
    bus.on('barrageId${widget.barrageId}', (e) {
      if (mounted) {
        if (!_animationController.isDismissed) {
          type = 0;
          _animationController?.forward();
          setState(() {});
        }
      }
    });
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete('');
            }
          });
    var begin = Offset(-1.0, .0);
    var end = Offset(1.0, .0);
    switch (widget.direction) {
      case TransitionDirection.ltr:
        begin = Offset(-1.0, .0);
        end = Offset(1.0, .0);
        break;
      case TransitionDirection.rtl:
        begin = Offset(1.0, .0);
        end = Offset(-1.0, .0);
        break;
      case TransitionDirection.ttb:
        begin = Offset(.0, .0);
        end = Offset(.0, 2.0);
        break;
      case TransitionDirection.btt:
        begin = Offset(.0, 2.0);
        end = Offset(.0, .0);
        break;
    }
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == 0) {
          if (Barrage.selectBarrageId != widget.barrageId) {
            bus.emit('barrageId${Barrage.selectBarrageId}');
            Barrage.selectBarrageId = widget.barrageId;
          }
          type = 1;
          _animationController?.stop();
        } else {
          type = 0;
          _animationController?.forward();
        }
        setState(() {});
      },
      child: SlideTransition(
        position: _animation,
        child: getBarrageWidget(),
      ),
    );
  }

  Widget getBarrageWidget() {
    return normal(widget.desc,
        id: widget.id, name: widget.name, img: widget.img);
  }

  Widget normal(String text, {String id, String name, String img}) {
    return Row(
      children: <Widget>[
        type == 0
            ? Container()
            : GestureDetector(
                onTap: () {
                  widget.onPressed(name);
                },
                child: Image.network(
                  img != null ? img : '',
                  width: 28,
                  height: 28,
                ).sq_corner(14),
              ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(color: Color(0xFF167592)),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum TransitionDirection {
  ltr,
  rtl,
  ttb,
  btt
}
