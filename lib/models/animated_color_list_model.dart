import 'package:flutter/material.dart';

typedef RemovedItemBuilder = Widget Function<T>(
  T item,
  BuildContext context,
  Animation<double> animation,
);

class AnimatedListModel<E> {
  AnimatedListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final Function removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(
      index,
      duration: Duration(milliseconds: 300),
    );
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
        duration: Duration(milliseconds: 600),
      );
    }
    return removedItem;
  }

  bool get isNotEmpty => _items.isNotEmpty;

  List<E> get items => _items;

  Iterable<E> map(Function f) => _items.map<E>(f as E Function(E));
  Iterable<E> where(Function f) => _items.where(f as bool Function(E));

  bool contains(E item) => _items.contains(item);

  int get length => _items.length;
  E operator [](int index) => _items[index];
  int indexOf(E item) => _items.indexOf(item);
}
