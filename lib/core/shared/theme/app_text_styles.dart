import 'package:flutter/material.dart';

class AppTextStyles {
  // Colors
  static const Color _black = Color(0xFF000000);
  static const Color _darkGray = Color(0xFF2C2C2C);
  static const Color _mediumGray = Color(0xFF5C5C5C);
  static const Color _lightGray = Color(0xFF8E8E8E);
  static const Color _veryLightGray = Color(0xFFB8B8B8);
  static const Color _white = Color(0xFFFFFFFF);
  // static const Color _turquoise = Color(0xFF5ECFCB);

  // 1. Screen Title - Large, bold titles like "Your Love Code"
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.2,
  );

  // 2. Section Header - Uppercase labels like "PRIMARY PATTERN"
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    letterSpacing: 0.5,
    height: 1.3,
  );

  // 3. Pattern Name - Names like "Secure Explorer"
  static const TextStyle patternName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: _black,
    height: 1.3,
  );

  // 4. Card Title - Titles in cards like "Get early access to TWLVE Dating"
  static const TextStyle cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.3,
  );

  // 5. Body Text - Main descriptive paragraphs
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    height: 1.5,
  );

  // 6. Body Text Small - Privacy notice and disclaimers
  static const TextStyle bodyTextSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: _mediumGray,
    height: 1.4,
  );

  // 7. Scenario Label - "Scenario" text
  static const TextStyle scenarioLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    height: 1.3,
  );

  // 8. Scenario Description - The scenario text in cards
  static const TextStyle scenarioDescription = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    height: 1.5,
  );

  // 9. Question Text - Questions like "How do you usually respond first?"
  static const TextStyle questionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    height: 1.4,
  );

  // 10. Option Text - Radio button option text
  static const TextStyle optionText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    height: 1.4,
  );

  // 11. Button Text Primary - Text on filled black buttons
  static const TextStyle buttonTextPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _white,
    height: 1.2,
  );

  // 12. Button Text Secondary - Text on outlined buttons
  static const TextStyle buttonTextSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _black,
    height: 1.2,
  );

  // 13. Link Text - Underlined links like "How TWLVE works"
  static const TextStyle linkText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: _black,
    decoration: TextDecoration.underline,
    height: 1.3,
  );

  // 14. Progress Text - "Step 1 of 3", "2 / 19"
  static const TextStyle progressText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: _mediumGray,
    height: 1.3,
  );

  // 15. Insight Heading - "Insight" label
  static const TextStyle insightHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.3,
  );

  // 16. Insight Body - Insight description paragraphs
  static const TextStyle insightBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    height: 1.5,
  );

  // 17. Bullet Point - List items in insights
  static const TextStyle bulletPoint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _darkGray,
    height: 1.2,
  );

  // 18. Tag Label - Pills like "Social mirroring"
  static const TextStyle tagLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: _darkGray,
    height: 1.2,
  );

  // 19. Input Placeholder - Placeholder text in text fields
  static const TextStyle inputPlaceholder = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _veryLightGray,
    height: 1.4,
  );

  // 20. Input Label - "Email address" label
  static const TextStyle inputLabel = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.3,
  );

  // 21. Success Message - "You're in."
  static const TextStyle successMessage = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.3,
  );

  // 22. Loading Text - "Your Love Code is taking shape."
  static const TextStyle loadingText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _black,
    height: 1.3,
  );

  // 23. Status Text - "Pattern 1 identified"
  static const TextStyle statusText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.3,
  );

  // 24. Match Type Label - "Steady Communicator"
  static const TextStyle matchTypeLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: _black,
    height: 1.3,
  );

  // Additional helper: Input text (actual input value)
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _black,
    height: 1.4,
  );

  // Pattern card subtitle (Pattern 1, Pattern 2, etc under icons)
  static const TextStyle patternCardLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: _lightGray,
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    height: 1.4,
  );

  static const TextStyle subtitleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    height: 1.5,
  );

  static const TextStyle subtitleMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    height: 1.4,
  );
}
