enum GenderEnum {
  male(label: 'Male', value: 'male'),
  female(label: 'Female', value: 'female'),
  nonBinary(label: 'Non-binary', value: 'nonBinary'),
  perferNotToSay(label: 'Prefer Not To Say', value: 'preferNotToSay'),
  other(label: 'Other', value: 'other');

  final String label;
  final String value;
  const GenderEnum({required this.label, required this.value});
}
