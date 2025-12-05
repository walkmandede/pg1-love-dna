import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/shared/enums/gender_enum.dart';

class InputsPageController extends AppPageController {
  PageController pageController = PageController();
  ValueNotifier<int> currentPageIndex = ValueNotifier(0);

  TextEditingController nameField = TextEditingController(text: kDebugMode ? 'Test Name' : '');
  TextEditingController ageField = TextEditingController(text: kDebugMode ? '27' : '');
  TextEditingController addressField = TextEditingController(text: kDebugMode ? 'Test Address' : '');
  ValueNotifier<GenderEnum?> selectedGender = ValueNotifier(kDebugMode ? GenderEnum.male : null);
  ValueNotifier<bool> isValidInput = ValueNotifier(kDebugMode ? true : false);

  @override
  Future<void> initLoad(BuildContext context) async {
    pageController.addListener(_onPageChanged);
    nameField.addListener(validateInputField);
    addressField.addListener(validateInputField);
    ageField.addListener(validateInputField);
    selectedGender.addListener(validateInputField);
  }

  @override
  Future<void> dispose() async {
    pageController.removeListener(_onPageChanged);
    nameField.removeListener(validateInputField);
    ageField.removeListener(validateInputField);
    addressField.removeListener(validateInputField);
    selectedGender.removeListener(validateInputField);
  }

  void _onPageChanged() async {
    currentPageIndex.value = pageController.page?.ceil() ?? 0;
    validateInputField();
  }

  void validateInputField() {
    isValidInput.value = false;

    if (currentPageIndex.value == 0) {
      //name
      if (nameField.text.isNotEmpty) {
        isValidInput.value = true;
        return;
      }
    } else if (currentPageIndex.value == 1) {
      //age
      if (ageField.text.isNotEmpty) {
        final age = int.tryParse(ageField.text);
        if (age != null) {
          isValidInput.value = true;
          return;
        }
      }
    } else if (currentPageIndex.value == 2) {
      //address
      if (addressField.text.isNotEmpty) {
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
}
