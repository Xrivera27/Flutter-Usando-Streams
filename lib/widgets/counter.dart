import 'dart:async';
import 'package:adaptive_stream/widgets/stream.dart';


class Counter{
  final _controler = StreamController<List<Stream>>();

  Stream<List<Stream>> get counterStream => _controler.stream;
  
   void startCounter(List<Stream> m) {
    _controler.sink.add(m);
  }
  void dispose(){
    _controler.close();
  }
}



