/// Modelo de dados para uma atualização semanal da gravidez.
class WeeklyUpdate {
  final int weekNumber;
  final String title;
  final String summary;
  final String imageUrl;
  final String babySizeFruit;
  final String fullContent;
  final List<String> momTips;
  final List<String> symptoms;

  const WeeklyUpdate({
    required this.weekNumber,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.babySizeFruit,
    required this.fullContent,
    required this.momTips,
    required this.symptoms,
  });
}
