# Notifications Permissions Setup

This guide explains how to configure permissions for local notifications on Android and iOS.

## Prerequisites

First, generate the Android and iOS platform folders:

```bash
flutter create .
```

This command creates `android/` and `ios/` directories if they don't exist.

## Android Setup

### 1. Update AndroidManifest.xml

Navigate to `android/app/src/main/AndroidManifest.xml` and add the following permissions inside the `<manifest>` tag (before the `<application>` tag):

```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Full example of permissions section:**

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.habit_flow">

    <!-- Notification permissions -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher">
        <!-- rest of application config -->
    </application>
</manifest>
```

### 2. Update build.gradle

Navigate to `android/app/build.gradle` and ensure your `compileSdkVersion` and `targetSdkVersion` are set to at least 33 for Android 13+ support:

```gradle
android {
    compileSdkVersion 34  // or higher

    defaultConfig {
        applicationId "com.example.habit_flow"
        minSdkVersion 21    // or higher
        targetSdkVersion 34 // or higher
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    // rest of configuration
}
```

### 3. Request Runtime Permissions (Android 12+)

For Android 12 and above, you should request the `POST_NOTIFICATIONS` permission at runtime. Add this to your Flutter code (e.g., in `main.dart`):

```dart
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permission on Android 13+
  if (Platform.isAndroid) {
    final status = await Permission.notification.request();
    debugPrint('Notification permission: $status');
  }

  runApp(const HabitFlowApp());
}
```

**Add `permission_handler` to pubspec.yaml:**

```yaml
dependencies:
  permission_handler: ^11.4.4
```

## iOS Setup

### 1. Update Info.plist

Navigate to `ios/Runner/Info.plist` and add the following keys:

```xml
<key>NSUserNotificationAlertStyle</key>
<string>alert</string>

<key>NSLocalNotificationAlertStyle</key>
<string>alert</string>

<key>UIApplicationSupportsShakeToEdit</key>
<false/>
```

**Full example Info.plist section:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Existing configuration -->

    <!-- Notification settings -->
    <key>NSUserNotificationAlertStyle</key>
    <string>alert</string>

    <key>NSLocalNotificationAlertStyle</key>
    <string>alert</string>

    <key>UIApplicationSupportsShakeToEdit</key>
    <false/>

    <!-- Rest of configuration -->
</dict>
</plist>
```

### 2. Update Podfile (Optional but Recommended)

Navigate to `ios/Podfile` and ensure the minimum deployment target is set to iOS 11.0 or higher:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_NOTIFICATIONS=1',
      ]
    end
  end
end
```

### 3. Request User Permission (iOS)

iOS requires explicit user consent for notifications. This is handled automatically by `flutter_local_notifications` with the `requestAlertPermission: true` setting in the initialization code.

Users will see an alert the first time the app tries to schedule a notification, asking them to allow notifications.

## Verification

### Android
- Build and run the app:
  ```bash
  flutter run --release
  ```
- Go to app settings → Notifications → Enable notifications
- Create a habit with reminders enabled
- Verify that notifications appear at the scheduled time

### iOS
- Build and run the app:
  ```bash
  flutter run --release
  ```
- When prompted, allow notifications
- Create a habit with reminders enabled
- Verify that notifications appear at the scheduled time

## Troubleshooting

### Notifications not appearing on Android

1. **Check notification settings:**
   - Go to Settings → Apps → HabitFlow → Notifications
   - Ensure notifications are enabled
   - Check the notification channel settings

2. **Check battery optimization:**
   - Go to Settings → Battery → Battery Saver / Adaptive Battery
   - Add HabitFlow to the whitelist (allow to run in background)

3. **Check Doze mode:**
   - If on Android 6.0+, Doze mode may prevent notifications
   - Add HabitFlow to the Doze whitelist

### Notifications not appearing on iOS

1. **Check notification settings:**
   - Go to Settings → HabitFlow → Notifications
   - Ensure notifications are enabled
   - Check alert style (must be "Alert", not "Badges")

2. **Check Do Not Disturb:**
   - Disable Do Not Disturb mode
   - Check that the app is not muted

3. **Check Focus Mode:**
   - Ensure the app is allowed in active Focus Mode

### Permissions denied

If users deny permissions when first prompted:

**Android:**
- They can re-enable by going to Settings → Apps → HabitFlow → Permissions → Notifications

**iOS:**
- They can re-enable by going to Settings → HabitFlow → Notifications

## Testing Notifications

To test notifications without waiting for the scheduled time:

```dart
// In your notification service, you can add this debug method:
Future<void> debugScheduleTestNotification() async {
  await _zonedScheduleNotification(
    id: 999999,
    title: 'Test Notification',
    body: 'This is a test notification',
    scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
  );
}
```

## References

- [flutter_local_notifications Documentation](https://pub.dev/packages/flutter_local_notifications)
- [Android Notification Permissions](https://developer.android.com/guide/topics/ui/notifiers/notifications#permissions)
- [iOS UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)
- [Permission Handler Package](https://pub.dev/packages/permission_handler)
