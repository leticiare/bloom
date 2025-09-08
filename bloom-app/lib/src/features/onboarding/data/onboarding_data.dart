import 'package:app/src/features/onboarding/domain/entities/onboarding_page_model.dart';

/// Lista que armazena os dados de todas as telas do onboarding.
final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    imagePath: 'assets/images/onb1.png',
    title: 'Bem-vindo(a)',
    description:
        'Bem vindo(a) à Bloom, seu parceiro na jornada da sua gravidez.',
    wordToHighlight: '',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb2.png',
    title: 'Acompanhamento por profissionais',
    description:
        'Esse aplicativo vai proporcionar o apoio dos seus profissionais favoritos para te ajudar a monitorar o progresso da sua gravidez e pós parto.',
    wordToHighlight: 'profissionais',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb3.png',
    title: 'Recursos educacionais',
    description:
        'Esse app vai prover de recursos educacionais como fóruns e artigos de profissionais para ajudar usuários a aprender sobre a saúde materna.',
    wordToHighlight: 'educacionais',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb4.png',
    title: 'Suporte da comunidade',
    description:
        'Esse aplicativo possui um suporte da comunidade para ajudar usuários a conectar-se com profissionais da área da saúde a compartilhar informações.',
    wordToHighlight: 'comunidade',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb5.png',
    title: 'Registro de saúde',
    description:
        'Esse aplicativo permite que usuários marquem consultas, salve informações sobre sua saúde e do seu bebê, facilitando na hora da consulta.',
    wordToHighlight: 'saúde',
  ),
];
