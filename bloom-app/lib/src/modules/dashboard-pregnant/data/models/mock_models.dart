// lib/src/modules/dashboard-pregnant/data/models/mock_models.dart

// --- MODELOS DE DADOS PARA TODO O MÓDULO ---

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

class Doctor {
  final String name;
  final String specialty;
  final String avatarUrl;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });
}

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

// --- DADOS MOCKADOS GLOBAIS ---

final mockUserProfile = const UserProfile(
  name: 'Júlia Oliveira',
  pregnancyInfo: 'Primeira vez gestante',
  avatarUrl: 'https://i.pravatar.cc/150?img=1',
  babySize: '17 cm',
  babyWeight: '110 gr',
  weeksLeft: 16,
  daysLeft: 168,
);

final List<Doctor> mockDoctors = const [
  Doctor(
    name: 'José Ricardo',
    specialty: 'Ginecologista',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  Doctor(
    name: 'Ana Costa',
    specialty: 'Pediatra',
    avatarUrl: 'https://i.pravatar.cc/150?img=25',
  ),
  Doctor(
    name: 'Lucas Martins',
    specialty: 'Nutricionista',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
  ),
  Doctor(
    name: 'Sofia Pereira',
    specialty: 'Fisioterapeuta',
    avatarUrl: 'https://i.pravatar.cc/150?img=35',
  ),
  Doctor(
    name: 'Marcos Lima',
    specialty: 'Psicólogo',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
];

List<Article> mockArticles = [
  Article(
    title: 'Yoga para gravidez',
    summary: 'Yoga durante a gravidez ajuda a aliviar os sintomas comuns...',
    imageUrl:
        'https://images.pexels.com/photos/3094230/pexels-photo-3094230.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    authorName: 'Natália Maria',
    authorTitle: 'Fisioterapeuta',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=25',
    fullContent:
        'A prática de yoga pré-natal é uma abordagem multifacetada para o exercício que incentiva o alongamento, a concentração mental e a respiração focada. Pesquisas sugerem que a yoga pré-natal é segura e pode ter muitos benefícios para as gestantes e seus bebês.',
  ),
  Article(
    title: 'Por que seus tornozelos incham?',
    summary:
        'Isso é muito comum, mas pode causar desconforto. Descubra como aliviar...',
    imageUrl:
        'https://images.pexels.com/photos/1796603/pexels-photo-1796603.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    authorName: 'Carlos Eduardo',
    authorTitle: 'Médico CRM-SE 876234',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=3',
    isBookmarked: true,
    fullContent:
        'O inchaço, também conhecido como edema, ocorre quando o corpo retém mais líquido do que o normal. Durante a gravidez, o corpo produz aproximadamente 50% mais sangue e fluidos corporais para atender às necessidades do bebê em desenvolvimento.',
  ),
];

List<ForumTopic> mockTopics = [
  ForumTopic(
    question: ForumMessage(
      authorName: 'Júlia',
      authorTitle: 'primeira vez grávida',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      message:
          'Oi! Estou de 16 semanas na minha primeira gravidez e tenho sentido umas cólicas leves de vez em quando. Não são fortes, mas fico preocupada. Isso é normal ou devo falar com meu médico?',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Carlos Eduardo',
      authorTitle: 'Obstetra',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      message: 'Olá! Cólicas leves podem ser normais nesta fase da gravidez...',
    ),
    tags: ['Cólicas', '16 semanas'],
  ),
];
