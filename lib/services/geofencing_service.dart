import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/ripple_state.dart';

final geofencingServiceProvider = Provider<GeofencingService>((ref) {
  return GeofencingService(ref);
});

class GeofencingService {
  final ProviderRef _ref;

  GeofencingService(this._ref);

  Future<void> init() async {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[onLocation] - \$location');
      
      // Basic mock logic: speed > 2.0 = walking, else calm
      final speed = location.coords.speed;
      if (speed > 5.0) {
        _ref.read(rippleStateProvider.notifier).state = RippleState.busy;
      } else if (speed > 1.0) {
        _ref.read(rippleStateProvider.notifier).state = RippleState.walking;
      } else {
        _ref.read(rippleStateProvider.notifier).state = RippleState.calm;
      }
    });

    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      print('[onGeofence] - \$event');
      if (event.action == 'ENTER' && event.identifier == 'DANGER_ZONE') {
        _ref.read(rippleStateProvider.notifier).state = RippleState.danger;
      }
    });

    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: false,
      logLevel: bg.Config.LOG_LEVEL_OFF,
    ));

    await bg.BackgroundGeolocation.start();
  }

  Future<void> addDangerZone(double lat, double lng) async {
    await bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: "DANGER_ZONE",
      radius: 200,
      latitude: lat,
      longitude: lng,
      notifyOnEntry: true,
      notifyOnExit: true,
      notifyOnDwell: false,
    ));
  }
}
