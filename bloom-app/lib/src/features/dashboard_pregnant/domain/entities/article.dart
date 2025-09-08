class Article {
  final String title;
  final String summary;
  final String imageUrl;
  final String authorName;
  final String authorTitle;
  final String authorAvatarUrl;
  final String fullContent;
  bool isBookmarked;

  Article({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.authorName,
    required this.authorTitle,
    required this.authorAvatarUrl,
    required this.fullContent,
    this.isBookmarked = false,
  });
}
