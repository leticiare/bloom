/// Modelo de dados para uma única página do fluxo de onboarding.
class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String description;
  final String wordToHighlight;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.wordToHighlight,
  });
}
