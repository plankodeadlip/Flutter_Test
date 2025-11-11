import '/app/events/http_event.dart';
import 'package:flutter_app/app/events/eventHandler.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../app/events/and_listener_event.dart';
import '../app/events/http_event.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/6.x/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  ButtonPressedEvent: ButtonPressedEvent(),
  AndListenerEvent:AndListenerEvent.placeholder(),

  httpUpdatedEvent: httpUpdatedEvent(),
  };


