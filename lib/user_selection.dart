import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Vendor/login_page.dart';
import 'customer/login_screen.dart';

class UserSelectionController extends GetxController {
  final selectedUserType = "".obs;
  static final GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final savedUserType = box.read<String>('userType');
    if (savedUserType != null) {
      selectedUserType.value = savedUserType;
    }
  }

  Future<void> setUserType(String userType) async {
    await box.write('userType', userType);
    selectedUserType.value = userType;

    if (userType == "vendor") {
      Get.to(() => const VendorLoginScreen(),);
    } else {
      Get.to(() => const CustomerLoginScreen(), arguments: userType);
    }
    generalUserType = userType;
  }

  Future<void> logout() async {
    await box.remove('userType');
    selectedUserType.value = "";
    Get.off(() => const UserSelectionScreen());
  }
}
 var generalUserType = "";
class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserSelectionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select User Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectionButton(
              label: "I am a Vendor",
              onTap: () => controller.setUserType("vendor"),
            ),
            const SizedBox(height: 20),
            _buildSelectionButton(
              label: "I am a Customer",
              onTap: () => controller.setUserType("customer"),
            ),
            const SizedBox(height: 40),
            Obx(
              () => Text(
                "Last Selected Type: ${controller.selectedUserType.value}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
