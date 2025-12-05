enum AppRoutes {
  splash(name: 'splash', path: '/'),
  onboarding(name: 'onboarding', path: '/onboarding'),
  howWork(name: 'howWork', path: '/howWork'),
  inputs(name: 'inputs', path: '/inputs'),
  whyTheseMoment(name: 'whyTheseMoment', path: '/whyTheseMoment'),
  patternCard(name: 'patternCard', path: '/patternCard'),
  patternResult(name: 'patternResult', path: '/patternResult'),
  interpretationLen(name: 'interpretationLen', path: '/interpretationLen'),
  loveLibrary(name: 'loveLibrary', path: '/loveLibrary'),
  results(name: 'results', path: '/results');

  final String name;
  final String path;
  const AppRoutes({required this.name, required this.path});
}
