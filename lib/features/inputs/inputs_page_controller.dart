import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/shared/enums/app_location_enum.dart';
import 'package:pg1/core/shared/enums/gender_enum.dart';

class InputsPageController extends AppPageController {
  PageController pageController = PageController();
  ValueNotifier<int> currentPageIndex = ValueNotifier(0);

  TextEditingController nameField = TextEditingController(text: '');
  TextEditingController ageField = TextEditingController(text: '');
  ValueNotifier<GenderEnum?> selectedGender = ValueNotifier(null);
  ValueNotifier<AppLocationEnum?> selectedLocation = ValueNotifier(null);
  ValueNotifier<bool> isValidInput = ValueNotifier(false);
  ValueNotifier<String?> errorText = ValueNotifier(null);

  @override
  Future<void> initLoad(BuildContext context) async {
    pageController.addListener(_onPageChanged);
    nameField.addListener(validateInputField);
    selectedLocation.addListener(validateInputField);
    ageField.addListener(validateInputField);
    selectedGender.addListener(validateInputField);
  }

  @override
  Future<void> dispose() async {
    pageController.removeListener(_onPageChanged);
    nameField.removeListener(validateInputField);
    ageField.removeListener(validateInputField);
    selectedLocation.removeListener(validateInputField);
    selectedGender.removeListener(validateInputField);
  }

  void _onPageChanged() async {
    currentPageIndex.value = pageController.page?.ceil() ?? 0;
    validateInputField();
  }

  void validateInputField() {
    isValidInput.value = false;
    errorText.value = null;

    if (currentPageIndex.value == 0) {
      //name
      final isValidName = _isValidName(nameField.text);
      if (isValidName) {
        errorText.value = null;
        isValidInput.value = true;
        return;
      } else {
        if (nameField.text.isEmpty) {
          errorText.value = null;
        } else {
          errorText.value = 'Invalid Username';
        }
        return;
      }
    } else if (currentPageIndex.value == 1) {
      //age

      final isValidAge = _isValidAge(ageField.text);
      if (!isValidAge) {
        if (ageField.text.isEmpty) {
          errorText.value = null;
        } else {
          errorText.value = 'Invalid Age Format';
        }
        return;
      } else {
        if (_isUnderage(ageField.text)) {
          if (ageField.text.isEmpty) {
            errorText.value = null;
          } else {
            errorText.value = 'You must be at least 18 years old.';
          }
          return;
        } else {
          errorText.value = null;
          isValidInput.value = true;
          return;
        }
      }
    } else if (currentPageIndex.value == 2) {
      //address
      if (selectedLocation.value != null) {
        isValidInput.value = true;
        return;
      }
    } else if (currentPageIndex.value == 3) {
      //gender
      if (selectedGender.value != null) {
        isValidInput.value = true;
        return;
      }
    }

    isValidInput.value = false;
  }

  bool _isValidName(String? name) {
    if (name == null) return false;

    final trimmed = name.trim();

    if (trimmed.length < 2) return false;

    final regex = RegExp(r"^[A-Za-z\- ]+$");

    return regex.hasMatch(trimmed);
  }

  bool _isValidAge(String? ageString) {
    if (ageString == null) return false;

    final trimmed = ageString.trim();

    if (!RegExp(r"^[0-9]+$").hasMatch(trimmed)) return false;

    if (trimmed.length != 2) return false;

    final age = int.tryParse(trimmed);
    if (age == null) return false;

    return true;
  }

  bool _isUnderage(String? ageString) {
    if (ageString == null) return false;

    final age = int.tryParse(ageString);
    if (age == null) return false;

    return age < 18;
  }

  Future<void> onContinuePressed(BuildContext context) async {
    if (!isValidInput.value) {
      return;
    }
    if ((pageController.page ?? 0) < 3) {
      await pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
    } else {
      await context.pushNamed(AppRoutes.whyTheseMoment.name);
    }
  }

  void onGenderSelected(GenderEnum gender) {
    selectedGender.value = gender;
  }

  void onLocationSelected(AppLocationEnum location) {
    selectedLocation.value = location;
  }

  Future<void> onClickBack(BuildContext context) async {
    if (pageController.page == 0) {
      context.pop();
    } else {
      await pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.linear);
    }
  }
}
