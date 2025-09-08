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
final List<ForumTopic> mockTopics = [
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
      authorName: 'Dr. Carlos Eduardo',
      authorTitle: 'Obstetra',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      message:
          'Olá Júlia! Cólicas leves podem ser normais nesta fase, pois seu útero está crescendo. No entanto, se a dor for intensa, constante ou vier acompanhada de sangramento, procure seu médico imediatamente. Para aliviar, tente descansar e beber bastante água.',
    ),
    tags: ['Cólicas', '16 semanas'],
  ),
  ForumTopic(
    question: ForumMessage(
      authorName: 'Mariana',
      authorTitle: 'segunda gravidez',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      message:
          'É seguro continuar a fazer exercícios de baixo impacto durante o segundo trimestre? Gosto de caminhar e nadar, mas tenho receio de exagerar.',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Dra. Sofia Pereira',
      authorTitle: 'Fisioterapeuta',
      avatarUrl: 'https://i.pravatar.cc/150?img=35',
      message:
          'Sim, Mariana! Exercícios de baixo impacto como caminhada e natação são altamente recomendados, desde que não haja contraindicações do seu médico. Eles ajudam na circulação e no controle do peso. O importante é sempre ouvir seu corpo e evitar a exaustão.',
    ),
    tags: ['Exercícios', '2º Trimestre'],
  ),
  ForumTopic(
    question: ForumMessage(
      authorName: 'Beatriz',
      authorTitle: '28 semanas',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      message:
          'Estou com muita azia e dificuldade para dormir. Alguma dica de alimentação ou posição para dormir que possa ajudar a aliviar esses sintomas?',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Dr. Lucas Martins',
      authorTitle: 'Nutricionista',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      message:
          'Olá Beatriz. Azia é comum nessa fase. Evite alimentos gordurosos e picantes, principalmente à noite. Tente fazer refeições menores e mais frequentes. Para dormir, elevar a cabeceira da cama com travesseiros extras pode ajudar bastante. Evite deitar logo após comer.',
    ),
    tags: ['Azia', 'Sono', 'Alimentação'],
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
