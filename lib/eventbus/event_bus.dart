
//订阅者回调签名
typedef void EventCallback(arg);

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var bus = new EventBus();

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static EventBus _singleton = new EventBus._internal();

  static EventBus get instance => _getInstance();

  //工厂构造函数
  factory EventBus() => _getInstance();

  static EventBus _getInstance() {
    if (_singleton == null) {
      _singleton = new EventBus._internal();
    }
    return _singleton;
  }

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _emap = new Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    //if (_emap.containsKey(eventName)) return; //已经包含,不再添加
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  //添加订阅者(类似我的页面,只添加一次)
  void onOnly(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    if (_emap.containsKey(eventName)) return; //已经包含,不再添加
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }

  //清空所有的
  void clearAll() {
    if (_emap != null) {
      _emap.clear();
    }
  }
}
