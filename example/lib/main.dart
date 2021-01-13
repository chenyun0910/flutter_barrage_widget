import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barrage_widget/barrage/barrage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLutter Barrage Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FLutter Barrage Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _barrageKey = GlobalKey<BarrageState>();
  List<String> values = [
    '弹幕很不是不错呢',
    '出自鼹鼠的故事',
    'PS.大家想收录就收录，想转载就转载',
    "666",
    "给阿姨倒杯卡布奇诺",
    "17张牌他能秒我，我当场吃掉这个显示器",
    "小轩在不在,我是娇妹",
    "蛮王冲撞",
    "醉里挑灯看剑，梦回吹角连营。",
    "你看我还有机会吗？",
    "I will find you, and kill you!",
    "风急天高猿啸哀，渚清沙白鸟飞回。",
    "无边落木萧萧下，不尽长江滚滚来。",
    "万里悲秋常作客，百年多病独登台。",
    "艰难苦恨繁霜鬓",
    "潦倒新停浊酒杯",
    '刘备浇水…',
    '最新实体弹幕！',
    '琴瑟琵琶，八大王一般头面',
    '8888888888888888888888888888',
    '男人没有等到3分钟之后。',
    '但她还是按照计划，一本正经地在心里默念',
    '代号077沉默不语。',
  ];
  Timer _timer;

  void _change() {
    setState(() {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        Random random = Random();
        int _random = random.nextInt(values.length);
        var text = values[_random];
        _barrageKey.currentState.addBarrage(
          dec: text,
          userId: '',
          name: text,
          img: 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fku'
              '.90sjimg'
              '.com%2Felement_pic%2F01%2F30%2F74%2F22573b218d3d415'
              '.jpg&refer=http%3A%2F%2Fku.90sjimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1613025741&t=d2d424961964a65e5e386beb5a20cc15',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              child: Barrage(
                key: _barrageKey,
                showCount: 18,
                onPressed: (name) {
                  Fluttertoast.showToast(
                      msg: name, gravity: ToastGravity.CENTER);
                },
              ),
            ),
            RaisedButton(
              child: Text('Play'),
              onPressed: () => _change(),
            ),
          ],
        ),
      ),
    );
  }
}
