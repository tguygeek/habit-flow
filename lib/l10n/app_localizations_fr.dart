// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'HabitFlow';

  @override
  String get homeTitle => 'Mes habitudes';

  @override
  String get emptyHabitsTitle => 'Aucune habitude';

  @override
  String get emptyHabitsSubtitle =>
      'Appuyez sur + pour créer votre première habitude';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get editHabit => 'Modifier l\'habitude';

  @override
  String get habitName => 'Nom de l\'habitude';

  @override
  String get habitNameHint => 'ex. Boire de l\'eau, Lire 10 pages';

  @override
  String get habitDescription => 'Description (optionnel)';

  @override
  String get category => 'Catégorie';

  @override
  String get weeklyTarget => 'Objectif de jours par semaine';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get deleteConfirmTitle => 'Supprimer l\'habitude ?';

  @override
  String deleteConfirmBody(String name) {
    return 'Cela supprimera définitivement $name et son historique.';
  }

  @override
  String currentStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Série de $count jours',
      one: 'Série d\'1 jour',
      zero: 'Pas encore de série',
    );
    return '$_temp0';
  }

  @override
  String completionRate(int percent) {
    return '$percent% cette semaine';
  }

  @override
  String get markDoneToday => 'Marquer comme fait aujourd\'hui';

  @override
  String get markedDoneToday => 'Fait aujourd\'hui';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get totalHabits => 'Total d\'habitudes';

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String get overallCompletion => 'Taux de réussite global';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get about => 'À propos';

  @override
  String get aboutBody =>
      'HabitFlow vous aide à construire des habitudes durables, un jour à la fois.';

  @override
  String get nameRequired => 'Veuillez saisir un nom d\'habitude';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryProductivity => 'Productivité';

  @override
  String get categoryLearning => 'Apprentissage';

  @override
  String get categoryMindfulness => 'Pleine conscience';

  @override
  String get categoryOther => 'Autre';

  @override
  String get habitDetailTitle => 'Détails de l\'habitude';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String get history => 'Historique';
}
