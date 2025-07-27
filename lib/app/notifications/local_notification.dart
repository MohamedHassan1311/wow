part of 'notification_helper.dart';

FlutterLocalNotificationsPlugin? _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> localNotification() async {
  _notificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    _notificationsPlugin!
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  } else {
    _notificationsPlugin!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings(
    defaultPresentBadge: true,
    defaultPresentAlert: true,
    defaultPresentSound: true,
  );

  const initSetting = InitializationSettings(
    android: android,
    iOS: ios,
  );

  await _notificationsPlugin!.initialize(
    initSetting,
    onDidReceiveNotificationResponse: (not) {
      print("onSelect Message ${not.payload}");
      handlePath(json.decode(not.payload ?? ""));
    },
  );

  const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
    'default_channel', // channel ID
    'Default Notifications', // channel name
    description: 'This channel is used for default sound notifications',
    importance: Importance.high,
    playSound: true,
  );

  await _notificationsPlugin!
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultChannel);
}

