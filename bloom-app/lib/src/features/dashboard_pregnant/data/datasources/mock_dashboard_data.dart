// Importa todos os modelos de dados que serão usados aqui
import 'package:app/src/features/dashboard_pregnant/domain/entities/user_profile.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/doctor.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/article.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_message.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';

/// Perfil de exemplo da usuária.
final mockUserProfile = const UserProfile(
  name: 'Júlia Oliveira',
  pregnancyInfo: 'Primeira vez gestante',
  avatarUrl: 'https://i.pravatar.cc/150?img=1',
  babySize: '17 cm',
  babyWeight: '110 gr',
  weeksLeft: 16,
  daysLeft: 168,
);

/// Lista de médicos de exemplo.
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

/// Lista de artigos de exemplo.
List<Article> mockArticles = [
  Article(
    title: 'Yoga para gravidez',
    summary: 'Yoga durante a gravidez ajuda a aliviar os sintomas comuns...',
    imageUrl:
        'https://images.pexels.com/photos/3094230/pexels-photo-3094230.jpeg',
    authorName: 'Natália Maria',
    authorTitle: 'Fisioterapeuta',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=25',
    fullContent:
        'A prática de yoga pré-natal é uma abordagem multifacetada para o exercício que incentiva o alongamento, a concentração mental e a respiração focada...',
  ),
  Article(
    title: 'Por que seus tornozelos incham?',
    summary:
        'Isso é muito comum, mas pode causar desconforto. Descubra como aliviar...',
    imageUrl:
        'https://images.pexels.com/photos/1796603/pexels-photo-1796603.jpeg',
    authorName: 'Carlos Eduardo',
    authorTitle: 'Médico CRM-SE 876234',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=3',
    isBookmarked: true,
    fullContent:
        'O inchaço, também conhecido como edema, ocorre quando o corpo retém mais líquido do que o normal...',
  ),
];

/// Lista de tópicos do fórum de exemplo.
List<ForumTopic> mockTopics = [
  ForumTopic(
    question: ForumMessage(
      authorName: 'Júlia',
      authorTitle: 'primeira vez grávida',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      message:
          'Oi! Estou de 16 semanas na minha primeira gravidez e tenho sentido umas cólicas leves de vez em quando. Isso é normal?',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Carlos Eduardo',
      authorTitle: 'Obstetra',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      message:
          'Olá! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo...',
    ),
    tags: ['Cólicas', '16 semanas'],
  ),
];

final List<MedicalRecord> mockHistory = [
  MedicalRecord(
    type: RecordType.exam,
    name: 'Ultrassom Morfológico',
    status: RecordStatus.completed,
  ),
  MedicalRecord(
    type: RecordType.exam,
    name: 'Exame de Glicemia',
    status: RecordStatus.pending,
  ),
  MedicalRecord(
    type: RecordType.vaccine,
    name: 'Vacina dTpa',
    status: RecordStatus.pending,
    time: '14:00',
    date: '24 de Fevereiro',
  ),
  MedicalRecord(
    type: RecordType.medication,
    name: 'Ácido Fólico',
    status: RecordStatus.completed,
    time: '08:00',
    frequency: 'A cada 12 horas',
  ),
  MedicalRecord(
    type: RecordType.medication,
    name: 'Ferritina',
    status: RecordStatus.overdue,
    time: '20:00',
    frequency: 'A cada 24 horas',
  ),
];
