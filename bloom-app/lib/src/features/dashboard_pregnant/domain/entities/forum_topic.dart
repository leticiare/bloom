import 'forum_message.dart';

class ForumTopic {
  final ForumMessage question;
  final ForumMessage answer;
  final List<String> tags;

  ForumTopic({
    required this.question,
    required this.answer,
    required this.tags,
  });
}
