import 'package:equatable/equatable.dart';
import 'package:pg1/core/shared/enums/supporting_traits_enum.dart';

class PatternInsight extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String insight;
  final List<String> bullets;
  final List<SupportingTraitEnum> traits;

  const PatternInsight({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.insight,
    required this.bullets,
    required this.traits,
  });

  factory PatternInsight.fromJson(Map<String, dynamic> json) {
    final traitStrings = (json['supporting_traits'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

    final traitEnums = traitStrings.map((label) => SupportingTraitEnum.fromLabel(label)).where((e) => e != null).map((e) => e!).toList();

    return PatternInsight(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      insight: json['insight'] as String,
      bullets: (json['supporting_bullets'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      traits: traitEnums,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, insight, bullets, traits];
}
