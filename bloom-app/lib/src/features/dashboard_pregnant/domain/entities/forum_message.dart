class ForumMessage {
  final String authorName;
  final String authorTitle;
  final String avatarUrl;
  final String message;
  final bool isFromUser;

  ForumMessage({
    required this.authorName,
    required this.authorTitle,
    required this.avatarUrl,
    required this.message,
    this.isFromUser = false,
  });
}
