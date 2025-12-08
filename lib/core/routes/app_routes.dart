enum AppRoutes {
  onboarding(name: 'onboarding', path: '/'),
  howWork(name: 'howWork', path: '/howWork'),
  inputs(name: 'inputs', path: '/inputs'),
  whyTheseMoment(name: 'whyTheseMoment', path: '/whyTheseMoment'),
  patternCard(name: 'patternCard', path: '/patternCard'),
  patternResult(name: 'patternResult', path: '/patternResult'),
  interpretationLen(name: 'interpretationLen', path: '/interpretationLen'),
  selfViewLen(name: 'selfViewLen', path: '/selfViewLen'),
  loveLibrary(name: 'loveLibrary', path: '/loveLibrary'),
  celebration(name: 'celebration', path: '/celebration'),
  results(name: 'results', path: '/results');

  final String name;
  final String path;
  const AppRoutes({required this.name, required this.path});
}
