/// Modelo de dados que representa o perfil da usuária gestante.
class UserProfile {
  final String name;
  final String pregnancyInfo;
  final String avatarUrl;
  final String babySize;
  final String babyWeight;
  final int weeksLeft;
  final int daysLeft;

  const UserProfile({
    required this.name,
    required this.pregnancyInfo,
    required this.avatarUrl,
    required this.babySize,
    required this.babyWeight,
    required this.weeksLeft,
    required this.daysLeft,
  });
}
