enum AppLocationEnum {
  london(label: 'London'),
  otherUK(label: 'Other (UK)'),
  outsideUK(label: 'Outside UK');

  final String label;
  const AppLocationEnum({required this.label});
}
