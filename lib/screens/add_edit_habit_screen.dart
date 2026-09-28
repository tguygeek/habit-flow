import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';
import '../providers/habit_provider.dart';

/// Screen 3: create a new habit, or edit an existing one when [existing]
/// is provided.
class AddEditHabitScreen extends StatefulWidget {
  const AddEditHabitScreen({super.key, this.existing});

  final Habit? existing;

  bool get isEditing => existing != null;

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late HabitCategory _category;
  late int _weeklyTarget;
  late bool _enableReminders;
  late int? _reminderHour;
  late int? _reminderMinute;

  @override
  void initState() {
    super.initState();
    final Habit? existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _descController = TextEditingController(text: existing?.description ?? '');
    _category = existing?.category ?? HabitCategory.other;
    _weeklyTarget = existing?.weeklyTarget ?? 5;
    _enableReminders = existing?.enableReminders ?? false;
    _reminderHour = existing?.reminderHour;
    _reminderMinute = existing?.reminderMinute;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final HabitProvider provider = context.read<HabitProvider>();
    final Habit? existing = widget.existing;

    if (existing == null) {
      await provider.addHabit(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _category,
        weeklyTarget: _weeklyTarget,
        enableReminders: _enableReminders,
        reminderHour: _reminderHour,
        reminderMinute: _reminderMinute,
      );
    } else {
      await provider.updateHabit(
        existing.copyWith(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          category: _category,
          weeklyTarget: _weeklyTarget,
          reminderHour: _reminderHour,
          reminderMinute: _reminderMinute,
          enableReminders: _enableReminders,
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editHabit : l10n.addHabit),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.habitName,
                hintText: l10n.habitNameHint,
              ),
              textInputAction: TextInputAction.next,
              validator:
                  (String? value) =>
                      (value == null || value.trim().isEmpty)
                          ? l10n.nameRequired
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: l10n.habitDescription),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<HabitCategory>(
              initialValue: _category,
              decoration: InputDecoration(labelText: l10n.category),
              items: <DropdownMenuItem<HabitCategory>>[
                for (final HabitCategory c in HabitCategory.values)
                  DropdownMenuItem<HabitCategory>(
                    value: c,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(c.icon, size: 18, color: c.color),
                        const SizedBox(width: 8),
                        Text(c.label(l10n)),
                      ],
                    ),
                  ),
              ],
              onChanged: (HabitCategory? value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            Text(l10n.weeklyTarget),
            Semantics(
              label: l10n.weeklyTarget,
              value: '$_weeklyTarget',
              child: Slider(
                value: _weeklyTarget.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: '$_weeklyTarget',
                onChanged:
                    (double v) => setState(() => _weeklyTarget = v.round()),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Enable Reminders'),
              subtitle: const Text(
                'Get hourly notifications to complete this habit',
              ),
              value: _enableReminders,
              onChanged: (bool value) {
                setState(() => _enableReminders = value);
              },
            ),
            if (_enableReminders) ...<Widget>[
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      initialValue:
                          _reminderHour?.toString().padLeft(2, '0') ?? '09',
                      decoration: const InputDecoration(
                        labelText: 'Hour',
                        hintText: '00-23',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final int? hour = int.tryParse(value);
                        if (hour == null || hour < 0 || hour > 23) {
                          return 'Invalid hour';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _reminderHour = int.tryParse(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue:
                          _reminderMinute?.toString().padLeft(2, '0') ?? '00',
                      decoration: const InputDecoration(
                        labelText: 'Minute',
                        hintText: '00-59',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final int? minute = int.tryParse(value);
                        if (minute == null || minute < 0 || minute > 59) {
                          return 'Invalid minute';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _reminderMinute = int.tryParse(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}
