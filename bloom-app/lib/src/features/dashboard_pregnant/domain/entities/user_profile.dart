class UserProfile {
  final String name;
  final String pregnancyInfo;
  final String avatarUrl;
  final String babySize;
  final String babyWeight;
  final DateTime dum;
  final DateTime dpp;

  // Propriedades calculadas
  final int weeksLeft;
  final int daysLeft;
  final int currentWeek;

  UserProfile({
    required this.name,
    required this.pregnancyInfo,
    required this.avatarUrl,
    required this.babySize,
    required this.babyWeight,
    required this.dum,
    required this.dpp,
  }) : weeksLeft = dpp.difference(DateTime.now()).inDays ~/ 7,
       daysLeft = dpp.difference(DateTime.now()).inDays,
       currentWeek = 40 - (dpp.difference(DateTime.now()).inDays ~/ 7);
}
