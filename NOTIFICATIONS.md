# HabitFlow Notifications Guide

## Overview

HabitFlow includes a powerful notification system that reminds you to complete your habits at the time you choose. These are **local notifications** that work entirely on your device — no internet connection required.

## Features

✅ **Configurable Reminders** — Set any time you want (0:00 to 23:59)
✅ **Hourly Notifications** — Gets reminded every hour after your chosen time until midnight
✅ **Completion Feedback** — Special notification when you complete a habit on time
✅ **Works Offline** — All notifications are local and don't require internet
✅ **Auto-Reset** — Reminders reset automatically each day
✅ **iOS & Android** — Full support on both platforms

## How to Enable Notifications

### Step 1: Create or Edit a Habit

1. Open HabitFlow
2. Either:
   - Tap **Add Habit** to create a new habit
   - Or tap an existing habit to **Edit** it

### Step 2: Enable Reminders

In the Add/Edit Habit screen, you'll see a switch labeled **"Enable Reminders"**.

- **Toggle ON** to enable notifications for this habit
- **Toggle OFF** to disable notifications

### Step 3: Set Reminder Time

Once you enable reminders, two input fields will appear:

- **Hour** (0-23): Enter the hour when you want to be reminded
  - Examples: `9` for 9:00 AM, `14` for 2:00 PM, `21` for 9:00 PM
- **Minute** (0-59): Enter the minutes
  - Examples: `0` for :00, `30` for :30, `15` for :15

### Step 4: Save

Tap the **Save** button to apply your changes.

The app will now send you notifications starting at your chosen time.

## Understanding Notifications

### First Reminder

When your chosen time arrives, you'll receive a notification:

**Title:** "Time for your habit!"
**Message:** [Your habit name]

### Hourly Reminders

If you don't complete the habit, you'll receive reminders **every hour** until midnight:

**Title:** "Reminder: Complete your habit!"
**Message:** [Your habit name]

**Timeline Example:**
- Set reminder for **09:00** (9:00 AM)
- You receive notifications at: **9:00, 10:00, 11:00, 12:00, 13:00, ..., 23:00**
- At **midnight**, reminders reset for the next day

### Completion Notification

If you mark the habit as completed **before the reminder time or during the day**:

**Title:** "Great job!"
**Message:** "You completed [habit name] on time!"

After this, no more reminders are sent for that day.

## Examples

### Example 1: Morning Exercise Habit

```
Habit: Morning Pushups
Reminder Time: 06:30

Timeline:
06:30 → "Time for your habit! Morning Pushups"
07:30 → "Reminder: Complete your habit! Morning Pushups"
08:30 → "Reminder: Complete your habit! Morning Pushups"
...continuing every hour until...
23:30 → "Reminder: Complete your habit! Morning Pushups"
00:00 → Reset for next day
```

If you complete at 07:00:
```
07:00 → (You mark it as done)
07:01 → "Great job! You completed Morning Pushups on time!"
(No more reminders that day)
```

### Example 2: Evening Reading Habit

```
Habit: Read Book
Reminder Time: 20:00 (8:00 PM)

Timeline:
20:00 → "Time for your habit! Read Book"
21:00 → "Reminder: Complete your habit! Read Book"
22:00 → "Reminder: Complete your habit! Read Book"
23:00 → "Reminder: Complete your habit! Read Book"
00:00 → Reset for next day
```

If you don't complete it by midnight, the habit will have the same reminders the next evening.

## Managing Notifications

### Disable Reminders for a Specific Habit

1. Open the habit
2. Tap **Edit**
3. Toggle **"Enable Reminders"** OFF
4. Tap **Save**

All notifications for this habit will be cancelled immediately.

### Change Reminder Time

1. Open the habit
2. Tap **Edit**
3. Modify the **Hour** and **Minute** fields
4. Tap **Save**

New reminders will be scheduled for the updated time.

### Delete a Habit with Reminders

When you delete a habit, all associated notifications are automatically cancelled.

## Notification Permissions

### iOS

The first time the app tries to send a notification, iOS will ask you for permission:

```
"HabitFlow" Would Like to Send You Notifications

Notifications may include alerts, sounds, and icon badges
```

- Tap **Allow** to enable notifications
- Tap **Don't Allow** to disable them

**To change this later:**
1. Go to Settings → HabitFlow
2. Toggle Notifications **ON** or **OFF**
3. Adjust Notification Style (must be "Alert" for best experience)

### Android

On Android 13+, you may see a notification permission prompt:

```
Allow HabitFlow to send you notifications?
```

- Tap **Allow** to enable
- Tap **Don't Allow** to disable

**To change this later:**
1. Go to Settings → Apps → HabitFlow → Permissions
2. Tap Notifications
3. Toggle **Allow** or **Deny**

**Additional Steps (Android):**
- Go to Settings → Apps & Notifications → Notifications → HabitFlow
- Enable notifications if disabled
- Check notification channel settings

## Troubleshooting

### Notifications not appearing?

**Android:**

1. **Check notification settings:**
   - Settings → Apps → HabitFlow → Notifications → Toggle ON

2. **Check battery settings:**
   - Settings → Battery → Battery Saver or Adaptive Battery
   - Add HabitFlow to the whitelist/exception list

3. **Check Doze mode:**
   - Settings → Apps → HabitFlow → Battery → Allow background activity

4. **Restart the app:**
   - Close HabitFlow completely and reopen it

**iOS:**

1. **Check notification settings:**
   - Settings → HabitFlow → Notifications → Allow Notifications ON
   - Alert Style must be "Alert" (not "Badges" only)

2. **Check Do Not Disturb:**
   - Disable Do Not Disturb mode in Control Center

3. **Check Focus Mode:**
   - Settings → Focus → [Your Active Focus]
   - Ensure HabitFlow is allowed

4. **Restart the app:**
   - Swipe up and close HabitFlow, then reopen it

### Getting too many notifications?

**Option 1:** Change the reminder time to later in the day
- Edit the habit and set a later hour (e.g., 18:00 instead of 09:00)

**Option 2:** Disable reminders for less important habits
- Edit the habit and toggle "Enable Reminders" OFF

**Option 3:** Complete habits earlier in the day
- This sends the completion notification and stops hourly reminders

### Notifications have sound on iOS but not Android?

This is normal behavior:
- **iOS:** Plays system notification sound (can be changed in iOS settings)
- **Android:** Uses system notification sound (can be changed in app settings)

To change Android notification sound:
1. Settings → Apps → HabitFlow → Notifications
2. Tap Habit Reminders channel
3. Change Sound

## Tips & Tricks

### 💡 Best Practices

1. **Set reminders for consistent times:** Use a time when you usually do the activity
   - Example: Morning exercise → Set reminder for 06:00

2. **Use multiple habits for different times:**
   - Morning habit: 06:00
   - Midday habit: 12:00
   - Evening habit: 20:00

3. **Complete habits as early as possible:** This sends the completion notification and stops hourly reminders for that day

4. **Review and adjust:** After a week, check if your reminder times are working well and adjust if needed

### 🔔 Advanced Tips

**Create a "Critical" habit with early reminder:**
- Set reminder for 06:00 to catch the day early
- This gives you the whole day to complete it

**Create a "Backup" habit with late reminder:**
- Set reminder for 20:00 for habits you often forget
- This is your last chance reminder before midnight

## FAQ

**Q: Will notifications work if the app is closed?**
A: Yes! Notifications are sent by the operating system, not the app. Even if HabitFlow is closed, notifications will appear.

**Q: Will notifications work without internet?**
A: Yes! All notifications are local. No internet connection is required.

**Q: Can I have different reminder times for weekdays and weekends?**
A: Not yet. Currently, HabitFlow uses the same reminder time every day. You can manually change the time in settings each week if needed.

**Q: Why do I get notifications even after completing the habit?**
A: If the completion notification is sent before the next hourly reminder, you might see it. This is normal. Disable reminders or change the time if this happens frequently.

**Q: Can I set reminders for specific days only?**
A: Not directly. You can disable reminders on days you don't want them, or create a separate habit for those days.

**Q: How many habits can have reminders?**
A: There's no limit! You can enable reminders on as many habits as you want.

**Q: Will reminders drain my battery?**
A: No. Local notifications are very efficient and have minimal battery impact.

## Support

If you encounter issues not covered here:

1. Check that notifications are enabled in your device settings
2. Try restarting the app
3. Try restarting your device
4. Report the issue on GitHub: [HabitFlow Issues](https://github.com/tguygeek/habit-flow/issues)

---

**Enjoy your habit tracking with notifications! 🎯**
