// Importa todos os modelos de dados que serão usados aqui
import 'package:app/src/features/dashboard_pregnant/domain/entities/doctor.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/article.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_message.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/weekly_update.dart';

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

final List<WeeklyUpdate> mockWeeklyUpdates = [
  // TRIMESTRE 1
  const WeeklyUpdate(
    weekNumber: 1,
    title: "A Concepção",
    summary: "O início de uma nova vida.",
    imageUrl: "assets/images/weeks/semana_01.png",
    babySizeFruit: "invisível a olho nu",
    fullContent:
        "A jornada começa! A fecundação do óvulo pelo espermatozoide marca o ponto de partida. Embora clinicamente a gravidez ainda não tenha começado, seu corpo já se prepara.",
    momTips: [
      "Mantenha um estilo de vida saudável.",
      "Converse com seu parceiro sobre este novo capítulo.",
    ],
    symptoms: ["Nenhum sintoma de gravidez ainda."],
  ),
  const WeeklyUpdate(
    weekNumber: 2,
    title: "A Preparação do Ninho",
    summary: "Seu corpo se prepara para a ovulação.",
    imageUrl: "assets/images/weeks/semana_02.png",
    babySizeFruit: "um óvulo",
    fullContent:
        "A ovulação está próxima. Seu útero se prepara para receber o óvulo fertilizado. A 'idade' da sua gravidez é contada a partir do primeiro dia da sua última menstruação.",
    momTips: [
      "Monitore seu ciclo para entender o período fértil.",
      "Continue com hábitos saudáveis.",
    ],
    symptoms: ["Nenhum sintoma de gravidez ainda."],
  ),
  const WeeklyUpdate(
    weekNumber: 3,
    title: "A Fertilização",
    summary: "O encontro mágico que dá início a tudo.",
    imageUrl: "assets/images/weeks/semana_03.png",
    babySizeFruit: "um grão de açúcar",
    fullContent:
        "O espermatozoide encontrou o óvulo, e a fertilização aconteceu! As células começam a se multiplicar rapidamente enquanto viajam em direção ao útero.",
    momTips: ["Evite álcool e fumo.", "Descanse bastante."],
    symptoms: ["Algumas mulheres podem sentir uma leve pontada (dor do meio)."],
  ),
  const WeeklyUpdate(
    weekNumber: 4,
    title: "Implantação (Nidação)",
    summary: "O embrião se fixa no útero.",
    imageUrl: "assets/images/weeks/semana_04.png",
    babySizeFruit: "uma semente de papoula",
    fullContent:
        "O blastocisto, uma minúscula bola de células, aninha-se na parede do seu útero. A placenta e o cordão umbilical já começaram a se formar.",
    momTips: ["Faça um teste de gravidez!", "Comece a tomar ácido fólico."],
    symptoms: [
      "Leve sangramento (nidação)",
      "Sensibilidade nos seios",
      "Fadiga",
    ],
  ),
  const WeeklyUpdate(
    weekNumber: 5,
    title: "O Coração Começa a Bater",
    summary: "O sistema circulatório do bebê se desenvolve.",
    imageUrl: "assets/images/weeks/semana_05.png",
    babySizeFruit: "uma semente de laranja",
    fullContent:
        "O coração do seu bebê, ainda muito primitivo, começa a bater e a bombear sangue. Os principais órgãos, como cérebro e medula espinhal, estão em formação.",
    momTips: [
      "Agende sua primeira consulta pré-natal.",
      "Foque em alimentos ricos em nutrientes.",
    ],
    symptoms: ["Enjoo matinal pode começar.", "Aversão a certos cheiros."],
  ),
  const WeeklyUpdate(
    weekNumber: 6,
    title: "Traços do Rosto",
    summary: "Pequenas dobras na cabeça se tornarão o rosto.",
    imageUrl: "assets/images/weeks/semana_06.png",
    babySizeFruit: "uma lentilha",
    fullContent:
        "O nariz, a boca e as orelhas estão começando a se formar. O coração bate cerca de 100-160 vezes por minuto, quase o dobro do seu!",
    momTips: [
      "Coma pequenas porções para combater o enjoo.",
      "Use roupas confortáveis.",
    ],
    symptoms: ["Cansaço extremo", "Variações de humor."],
  ),
  const WeeklyUpdate(
    weekNumber: 7,
    title: "Mãos e Pés",
    summary: "Os membros do bebê estão crescendo.",
    imageUrl: "assets/images/weeks/semana_07.png",
    babySizeFruit: "um mirtilo",
    fullContent:
        "Os braços e as pernas estão se alongando, e as mãos e os pés parecem pequenas pás. O cérebro está se desenvolvendo rapidamente.",
    momTips: ["Beba muita água.", "Evite levantar peso."],
    symptoms: ["Azia pode começar.", "Salivação excessiva."],
  ),
  const WeeklyUpdate(
    weekNumber: 8,
    title: "Pequenos Movimentos",
    summary: "Seu bebê agora é um feto e já se mexe.",
    imageUrl: "assets/images/weeks/semana_08.png",
    babySizeFruit: "um feijão",
    fullContent:
        "Todos os órgãos essenciais estão formados. O bebê se move bastante, embora você ainda não sinta. A cauda embrionária desapareceu.",
    momTips: [
      "Converse sobre suas emoções.",
      "Pesquise sobre os direitos da gestante no trabalho.",
    ],
    symptoms: ["Veias mais visíveis.", "Leves cólicas."],
  ),
  const WeeklyUpdate(
    weekNumber: 9,
    title: "Detalhes se Formam",
    summary: "Articulações e músculos em desenvolvimento.",
    imageUrl: "assets/images/weeks/semana_09.png",
    babySizeFruit: "uma uva",
    fullContent:
        "Os cotovelos e joelhos já se dobram. Os órgãos vitais, como coração, pulmões e rins, estão funcionando e amadurecendo.",
    momTips: ["Use um sutiã de bom suporte.", "Comece um diário da gravidez."],
    symptoms: ["Dores de cabeça.", "Tonturas."],
  ),
  const WeeklyUpdate(
    weekNumber: 10,
    title: "Unhas e Cabelos",
    summary: "As unhas e uma fina camada de cabelo aparecem.",
    imageUrl: "assets/images/weeks/semana_10.png",
    babySizeFruit: "um morango",
    fullContent:
        "O período mais crítico do desenvolvimento terminou. O bebê agora irá focar em crescer e ganhar peso. Os dentes estão se formando dentro da gengiva.",
    momTips: [
      "Considere contar a boa notícia para mais pessoas.",
      "Planeje o anúncio da gravidez.",
    ],
    symptoms: ["Diminuição dos enjoos para muitas mulheres."],
  ),
  const WeeklyUpdate(
    weekNumber: 11,
    title: "Alongando e Chutando",
    summary: "O bebê está cada vez mais ativo.",
    imageUrl: "assets/images/weeks/semana_11.png",
    babySizeFruit: "um figo",
    fullContent:
        "O bebê está em constante movimento, esticando-se e chutando. Os órgãos genitais externos começam a se diferenciar.",
    momTips: [
      "Comece a pensar em exercícios leves.",
      "Hidrate a pele da barriga.",
    ],
    symptoms: ["Prisão de ventre.", "Aumento da energia."],
  ),
  const WeeklyUpdate(
    weekNumber: 12,
    title: "Desenvolvimento dos Reflexos",
    summary: "Seu bebê começa a abrir e fechar as mãos.",
    imageUrl: "assets/images/weeks/semana_12.png",
    babySizeFruit: "um limão",
    fullContent:
        "Os reflexos estão se desenvolvendo. Se você cutucar a barriga, o bebê provavelmente se mexerá. Ele já pode fazer o movimento de sucção.",
    momTips: [
      "Faça o ultrassom do primeiro trimestre.",
      "Planeje seu orçamento para a chegada do bebê.",
    ],
    symptoms: ["A barriga começa a ficar mais aparente."],
  ),
  const WeeklyUpdate(
    weekNumber: 13,
    title: "Impressões Digitais Únicas",
    summary: "As pontas dos dedos têm impressões digitais.",
    imageUrl: "assets/images/weeks/semana_13.png",
    babySizeFruit: "uma vagem de ervilha",
    fullContent:
        "As cordas vocais começam a se formar. O corpo do bebê está crescendo mais rápido que a cabeça, tornando as proporções mais equilibradas.",
    momTips: [
      "Compre roupas de maternidade.",
      "Pesquise sobre os diferentes tipos de parto.",
    ],
    symptoms: ["Aumento da libido.", "Fim do primeiro trimestre!"],
  ),

  // TRIMESTRE 2
  const WeeklyUpdate(
    weekNumber: 14,
    title: "Expressões Faciais",
    summary: "O bebê já consegue fazer caretas.",
    imageUrl: "assets/images/weeks/semana_14.png",
    babySizeFruit: "um pêssego",
    fullContent:
        "O bebê pode franzir a testa, fazer bico e outras expressões. O pescoço está mais longo, e ele consegue erguer a cabeça.",
    momTips: [
      "Aproveite o aumento de energia.",
      "Comece a planejar o quarto do bebê.",
    ],
    symptoms: ["Menos cansaço.", "Aumento do apetite."],
  ),
  const WeeklyUpdate(
    weekNumber: 15,
    title: "Ossos se Fortalecendo",
    summary: "O esqueleto do bebê está se ossificando.",
    imageUrl: "assets/images/weeks/semana_15.png",
    babySizeFruit: "uma maçã",
    fullContent:
        "O esqueleto, que era cartilagem, está endurecendo. A pele ainda é fina, e os vasos sanguíneos são visíveis através dela.",
    momTips: ["Use sapatos confortáveis.", "Faça exercícios de Kegel."],
    symptoms: ["Congestão nasal.", "Dores nas costas."],
  ),
  const WeeklyUpdate(
    weekNumber: 16,
    title: "Movimentos Coordenados",
    summary: "Os olhos se movem e ele ouve sua voz.",
    imageUrl: "assets/images/weeks/semana_16.png",
    babySizeFruit: "um abacate",
    fullContent:
        "O sistema nervoso permite movimentos faciais. A audição está se desenvolvendo, e ele já pode ouvir os sons do seu corpo e sua voz.",
    momTips: [
      "Converse e cante para o seu bebê!",
      "Use um travesseiro de corpo para dormir.",
    ],
    symptoms: ["Possíveis primeiros movimentos do bebê (tremor)."],
  ),
  const WeeklyUpdate(
    weekNumber: 17,
    title: "Ganhando Peso",
    summary: "Uma camada de gordura começa a se formar.",
    imageUrl: "assets/images/weeks/semana_17.png",
    babySizeFruit: "uma pera",
    fullContent:
        "A gordura corporal, essencial para manter o calor e a energia, está começando a se acumular. O coração bombeia cerca de 24 litros de sangue por dia!",
    momTips: [
      "Cuidado com tonturas.",
      "Continue com uma alimentação rica em ferro.",
    ],
    symptoms: ["Aumento do apetite.", "Dores nos ligamentos redondos."],
  ),
  const WeeklyUpdate(
    weekNumber: 18,
    title: "Audição Apurada",
    summary: "O bebê pode se assustar com ruídos altos.",
    imageUrl: "assets/images/weeks/semana_18.png",
    babySizeFruit: "uma batata-doce",
    fullContent:
        "O sistema nervoso está amadurecendo. Os nervos estão sendo cobertos por mielina, um processo crucial para a coordenação.",
    momTips: [
      "Evite ambientes muito barulhentos.",
      "Comece a pesquisar sobre cadeirinhas de carro.",
    ],
    symptoms: ["Dificuldade para dormir.", "Cãibras nas pernas."],
  ),
  const WeeklyUpdate(
    weekNumber: 19,
    title: "Cobertura Protetora",
    summary: "A pele é coberta pelo verniz caseoso.",
    imageUrl: "assets/images/weeks/semana_19.png",
    babySizeFruit: "uma manga",
    fullContent:
        "Uma substância gordurosa e esbranquiçada chamada verniz caseoso cobre a pele do bebê para protegê-la do líquido amniótico.",
    momTips: [
      "Beba muita água para evitar inchaço.",
      "Faça pausas regulares se trabalha sentada.",
    ],
    symptoms: ["Manchas na pele (cloasma).", "Dor na região lombar."],
  ),
  const WeeklyUpdate(
    weekNumber: 20,
    title: "Metade do Caminho!",
    summary: "Você chegou à metade da gravidez.",
    imageUrl: "assets/images/weeks/semana_20.png",
    babySizeFruit: "uma banana",
    fullContent:
        "O bebê engole mais líquido amniótico, o que é bom para o sistema digestivo. O ultrassom morfológico pode revelar o sexo do bebê!",
    momTips: ["Faça o ultrassom morfológico.", "Celebre esta marca!"],
    symptoms: ["Os chutes do bebê ficam mais fortes.", "Aumento do apetite."],
  ),
  const WeeklyUpdate(
    weekNumber: 21,
    title: "Sobrancelhas e Pálpebras",
    summary: "Detalhes finos do rosto estão se formando.",
    imageUrl: "assets/images/weeks/semana_21.png",
    babySizeFruit: "uma cenoura",
    fullContent:
        "As sobrancelhas e pálpebras estão completamente formadas. O bebê tem ciclos de sono e vigília mais regulares.",
    momTips: [
      "Use protetor solar.",
      "Considere fazer um curso de preparação para o parto.",
    ],
    symptoms: ["Estrias podem aparecer.", "Varizes."],
  ),
  const WeeklyUpdate(
    weekNumber: 22,
    title: "Sentindo o Mundo",
    summary: "O tato está se desenvolvendo.",
    imageUrl: "assets/images/weeks/semana_22.png",
    babySizeFruit: "um coco pequeno",
    fullContent:
        "O bebê agora pode sentir o toque. Ele explora o ambiente com as mãos, tocando o rosto e o cordão umbilical.",
    momTips: ["Peça para seu parceiro sentir os chutes.", "Hidrate-se bem."],
    symptoms: ["Inchaço nos tornozelos e pés.", "Cabelo e unhas mais fortes."],
  ),
  const WeeklyUpdate(
    weekNumber: 23,
    title: "Praticando a Respiração",
    summary: "Os pulmões se preparam para a vida fora.",
    imageUrl: "assets/images/weeks/semana_23.png",
    babySizeFruit: "uma beringela",
    fullContent:
        "Os vasos sanguíneos dos pulmões estão se desenvolvendo para preparar a respiração. O bebê faz movimentos respiratórios, mas ainda não há ar nos pulmões.",
    momTips: [
      "Conheça os sinais de trabalho de parto prematuro.",
      "Descanse com os pés elevados.",
    ],
    symptoms: ["Falta de ar.", "Roncos."],
  ),
  const WeeklyUpdate(
    weekNumber: 24,
    title: "Viabilidade",
    summary: "O bebê tem chance de sobreviver se nascer agora.",
    imageUrl: "assets/images/weeks/semana_24.png",
    babySizeFruit: "um melão cantalupo",
    fullContent:
        "Este é um marco importante. Com cuidados médicos intensivos, um bebê nascido nesta semana tem chances de sobreviver. O rosto está completamente formado.",
    momTips: ["Faça o teste de tolerância à glicose.", "Monte o berço."],
    symptoms: [
      "Pele da barriga com coceira.",
      "Esquecimento (cérebro de grávida).",
    ],
  ),
  const WeeklyUpdate(
    weekNumber: 25,
    title: "Cabelos e Cor",
    summary: "O cabelo do bebê cresce e ganha cor.",
    imageUrl: "assets/images/weeks/semana_25.png",
    babySizeFruit: "uma couve-flor",
    fullContent:
        "O cabelo do bebê não é mais branco, já tem cor e textura. Ele está cada vez mais gordinho, preenchendo a pele enrugada.",
    momTips: [
      "Comece a pensar no plano de parto.",
      "Lave as roupinhas do bebê.",
    ],
    symptoms: ["Hemorroidas.", "Dor no nervo ciático."],
  ),
  const WeeklyUpdate(
    weekNumber: 26,
    title: "Abrindo os Olhos",
    summary: "As pálpebras se abrem pela primeira vez.",
    imageUrl: "assets/images/weeks/semana_26.png",
    babySizeFruit: "um alface",
    fullContent:
        "O bebê pode abrir e fechar os olhos e perceber mudanças de luz. As ondas cerebrais para audição e visão já estão ativas.",
    momTips: [
      "Faça um lanche saudável antes de dormir.",
      "Use calçados antiderrapantes.",
    ],
    symptoms: [
      "Aumento da pressão arterial.",
      "Dificuldade em encontrar uma posição confortável.",
    ],
  ),
  const WeeklyUpdate(
    weekNumber: 27,
    title: "Soluços no Útero",
    summary: "Você pode sentir o bebê soluçando.",
    imageUrl: "assets/images/weeks/semana_27.png",
    babySizeFruit: "um repolho",
    fullContent:
        "Os soluços são comuns e são um bom sinal de que o diafragma está se desenvolvendo. O cérebro continua seu rápido crescimento.",
    momTips: [
      "Finalize os preparativos do quarto.",
      "Faça um ensaio fotográfico de gestante.",
    ],
    symptoms: ["Fim do segundo trimestre!", "Cãibras podem piorar."],
  ),

  // TRIMESTRE 3
  const WeeklyUpdate(
    weekNumber: 28,
    title: "Sonhando",
    summary: "O bebê pode estar sonhando.",
    imageUrl: "assets/images/weeks/semana_28.png",
    babySizeFruit: "uma abóbora",
    fullContent:
        "Os ciclos de sono do bebê incluem a fase REM (Movimento Rápido dos Olhos), que está associada aos sonhos. Ele já pode reconhecer sua voz.",
    momTips: [
      "Comece a frequentar as consultas pré-natais com mais frequência.",
      "Prepare a mala da maternidade.",
    ],
    symptoms: ["Síndrome das pernas inquietas.", "Inchaço."],
  ),
  const WeeklyUpdate(
    weekNumber: 29,
    title: "Ossos Fortes",
    summary: "O bebê precisa de muito cálcio.",
    imageUrl: "assets/images/weeks/semana_29.png",
    babySizeFruit: "uma abóbora média",
    fullContent:
        "Cerca de 250 miligramas de cálcio são depositados nos ossos do bebê todos os dias. Os chutes e socos estão mais fortes e definidos.",
    momTips: [
      "Consuma alimentos ricos em cálcio (leite, iogurte, queijo).",
      "Pratique técnicas de respiração para o parto.",
    ],
    symptoms: ["Azia e constipação podem voltar."],
  ),
  const WeeklyUpdate(
    weekNumber: 30,
    title: "Visão em Foco",
    summary: "O bebê pode focar a visão a curtas distâncias.",
    imageUrl: "assets/images/weeks/semana_30.png",
    babySizeFruit: "um pepino grande",
    fullContent:
        "A visão do bebê está se desenvolvendo, embora ainda seja limitada. A medula óssea assumiu a produção de glóbulos vermelhos.",
    momTips: [
      "Discuta suas preocupações sobre o parto com seu médico.",
      "Descanse sempre que puder.",
    ],
    symptoms: ["Cansaço retorna.", "Mudanças de humor."],
  ),
  const WeeklyUpdate(
    weekNumber: 31,
    title: "Todos os 5 Sentidos",
    summary: "O bebê usa todos os cinco sentidos.",
    imageUrl: "assets/images/weeks/semana_31.png",
    babySizeFruit: "um cacho de coco",
    fullContent:
        "O bebê pode ver, ouvir, cheirar, saborear e sentir. Ele está ganhando peso rapidamente, cerca de 200g por semana.",
    momTips: [
      "Aprenda sobre os estágios do trabalho de parto.",
      "Faça um tour pela maternidade.",
    ],
    symptoms: ["Contrações de Braxton Hicks.", "Vazamento de colostro."],
  ),
  const WeeklyUpdate(
    weekNumber: 32,
    title: "Pronto para Nascer",
    summary: "As unhas já alcançam as pontas dos dedos.",
    imageUrl: "assets/images/weeks/semana_32.png",
    babySizeFruit: "uma jaca",
    fullContent:
        "A maioria dos bebês já se vira de cabeça para baixo (posição cefálica) em preparação para o parto. Os pulmões são os últimos órgãos a amadurecer completamente.",
    momTips: [
      "Confirme quem estará com você na sala de parto.",
      "Prepare lanches para levar para o hospital.",
    ],
    symptoms: ["Falta de ar, pois o útero pressiona o diafragma."],
  ),
  const WeeklyUpdate(
    weekNumber: 33,
    title: "Imunidade",
    summary: "O bebê recebe anticorpos de você.",
    imageUrl: "assets/images/weeks/semana_33.png",
    babySizeFruit: "um abacaxi",
    fullContent:
        "Seu sistema imunológico está compartilhando anticorpos com o bebê através da placenta, o que o protegerá nos primeiros meses de vida.",
    momTips: [
      "Durma de lado para melhorar a circulação.",
      "Finalize os detalhes do plano de parto.",
    ],
    symptoms: ["Dificuldade para se movimentar.", "Calor excessivo."],
  ),
  const WeeklyUpdate(
    weekNumber: 34,
    title: "Descendo",
    summary: "O bebê pode começar a descer para a pelve.",
    imageUrl: "assets/images/weeks/semana_34.png",
    babySizeFruit: "um melão",
    fullContent:
        "Quando o bebê 'encaixa' na pelve, você pode sentir mais pressão na bexiga, mas também um alívio na respiração, pois há mais espaço para os pulmões.",
    momTips: [
      "Instale a cadeirinha do carro.",
      "Tenha os contatos de emergência à mão.",
    ],
    symptoms: ["Aumento da frequência urinária.", "Sensação de peso na pelve."],
  ),
  const WeeklyUpdate(
    weekNumber: 35,
    title: "Amadurecimento Rápido",
    summary: "Os rins e o fígado estão totalmente funcionais.",
    imageUrl: "assets/images/weeks/semana_35.png",
    babySizeFruit: "um melão honeydew",
    fullContent:
        "O desenvolvimento físico está quase completo. Nas próximas semanas, o foco principal será ganhar peso e gordura para se manter aquecido após o nascimento.",
    momTips: ["Revise a mala da maternidade.", "Pratique o relaxamento."],
    symptoms: ["Cansaço intenso.", "Ansiedade."],
  ),
  const WeeklyUpdate(
    weekNumber: 36,
    title: "Menos Espaço",
    summary: "Os movimentos do bebê mudam.",
    imageUrl: "assets/images/weeks/semana_36.png",
    babySizeFruit: "uma alface romana",
    fullContent:
        "Com menos espaço para se mover, os chutes fortes podem ser substituídos por mais rolamentos e alongamentos. Você sentirá cada movimento.",
    momTips: ["Monitore os movimentos do bebê.", "Descanse o máximo possível."],
    symptoms: ["Contrações mais frequentes.", "Pressão na pelve."],
  ),
  const WeeklyUpdate(
    weekNumber: 37,
    title: "A Termo!",
    summary: "Seu bebê é considerado 'a termo'.",
    imageUrl: "assets/images/weeks/semana_37.png",
    babySizeFruit: "uma acelga",
    fullContent:
        "A partir desta semana, o bebê não é mais considerado prematuro se nascer. Ele está pronto para o mundo exterior, com os pulmões preparados para respirar.",
    momTips: [
      "Fique atenta aos sinais de trabalho de parto.",
      "Mantenha o celular carregado.",
    ],
    symptoms: ["Perda do tampão mucoso.", "Aumento da secreção."],
  ),
  const WeeklyUpdate(
    weekNumber: 38,
    title: "Aperfeiçoando Detalhes",
    summary: "O bebê continua a acumular gordura.",
    imageUrl: "assets/images/weeks/semana_38.png",
    babySizeFruit: "uma abóbora pequena",
    fullContent:
        "O cérebro e o sistema nervoso continuam a fazer conexões importantes. A cor dos olhos pode não ser a definitiva, podendo mudar após o nascimento.",
    momTips: [
      "Relaxe e confie no seu corpo.",
      "Assista a filmes e séries para se distrair.",
    ],
    symptoms: ["Inchaço nas mãos e pés.", "Impaciência."],
  ),
  const WeeklyUpdate(
    weekNumber: 39,
    title: "A Grande Espera",
    summary: "O bebê está pronto e esperando o momento certo.",
    imageUrl: "assets/images/weeks/semana_39.png",
    babySizeFruit: "uma melancia pequena",
    fullContent:
        "O bebê tem o tamanho final e está apenas esperando o sinal do corpo para iniciar o trabalho de parto. O verniz caseoso está mais espesso.",
    momTips: [
      "Durma sempre que puder.",
      "Faça caminhadas leves para ajudar a induzir o parto.",
    ],
    symptoms: ["Sensação de 'explosão' iminente.", "Muita pressão pélvica."],
  ),
  const WeeklyUpdate(
    weekNumber: 40,
    title: "Feliz Data Provável!",
    summary: "A data chegou! Mas pode demorar mais um pouco.",
    imageUrl: "assets/images/weeks/semana_40.png",
    babySizeFruit: "uma abóbora grande",
    fullContent:
        "Parabéns, você chegou à data provável do parto! Lembre-se que apenas 5% dos bebês nascem exatamente na data. Ele pode chegar a qualquer momento!",
    momTips: [
      "Tente relaxar e não se fixar na data.",
      "Confirme os últimos detalhes com a equipe médica.",
    ],
    symptoms: [
      "Todos os sinais de trabalho de parto.",
      "Ansiedade e excitação!",
    ],
  ),
];

final List<MedicalRecord> mockHistory = [
  MedicalRecord(
    id: '1',
    type: RecordType.exam,
    name: 'Ultrassom Morfológico',
    status: RecordStatus.completed,
    recommendedDate: 'Semana 20-24',
  ),
  MedicalRecord(
    id: '2',
    type: RecordType.exam,
    name: 'Exame de Glicemia',
    status: RecordStatus.pending,
    recommendedDate: 'Semana 24-28',
  ),
  MedicalRecord(
    id: '3',
    type: RecordType.vaccine,
    name: 'Vacina dTpa',
    status: RecordStatus.pending,
    time: '14:00',
    date: '24 de Fevereiro',
    recommendedDate: 'A partir da Semana 20',
  ),
  MedicalRecord(
    id: '4',
    type: RecordType.medication,
    name: 'Ácido Fólico',
    status: RecordStatus.completed,
    time: '08:00',
    frequency: 'A cada 12 horas',
    recommendedDate: '1º Trimestre',
  ),
  MedicalRecord(
    id: '5',
    type: RecordType.medication,
    name: 'Ferritina',
    status: RecordStatus.overdue,
    time: '20:00',
    frequency: 'A cada 24 horas',
    recommendedDate: 'Conforme orientação',
  ),
];
