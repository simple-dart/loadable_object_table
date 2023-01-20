import 'dart:async';

import 'package:simple_dart_load_indicator/simple_dart_load_indicator.dart';
import 'package:simple_dart_object_table/simple_dart_object_table.dart';

typedef LoadNext<T> = Future<List<T>> Function();

class LoadableObjectTable<T> {
  late ObjectTable<T> objectTable;
  late LoadNext<T> loadNext;
  final StreamController<bool> _onLoadNext = StreamController<bool>.broadcast();
  LoadIndicator loadIndicator = LoadIndicator();

  Stream<bool> get onLoadNext => _onLoadNext.stream;

  LoadableObjectTable(this.objectTable, this.loadNext) {
    objectTable.scrollablePanel.element.onScroll.listen((event) {
      final scrollableNodeRoot = objectTable.scrollablePanel.element;
      if (scrollableNodeRoot.scrollTop + scrollableNodeRoot.offsetHeight >= scrollableNodeRoot.scrollHeight) {
        handleLoadNext();
      }
    });
  }

  Future<void> handleLoadNext() async {
    loadIndicator.show(objectTable);
    final nextObjects = await loadNext();
    nextObjects.forEach(objectTable.createObjectRow);
    _onLoadNext.add(nextObjects.isNotEmpty);
    loadIndicator.hide();
  }

  void dispose() {
    _onLoadNext.close();
  }
}
