import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';

import 'and_listener_listener.dart';
class AndListenerEvent extends NyEvent {
  final Map<String, dynamic> product;

  AndListenerEvent(this.product);

  AndListenerEvent.placeholder() : product = {};


  @override
  final listeners = {
    AndListenerListener: AndListenerListener(),
  };
}
