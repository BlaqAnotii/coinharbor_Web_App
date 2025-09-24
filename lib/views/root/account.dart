import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/views/base.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

enum MenuOption {
  personalInfo,
  deliveryHistory,
  bankAccounts,
}

class _AccountScreenState extends State<AccountScreen> {
  MenuOption _selectedOption = MenuOption.personalInfo;
  User? user;

  getUserDetails(HomeViewModel model) async {
    await model.getUser();
    if (model.user == null) {
      showCustomToast("Failed to load user profile",
          toastType: ToastType.error, time: 5);
    }
    setState(() {
      user = model.user;
      debugPrint("User fiat balance: ${user?.fiatBalance}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Responsive Layout
                isMobile
                    ? Column(
                        children: [
                          _buildMenuCard(),
                          const SizedBox(height: 16),
                          _buildRightCard(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 2, child: _buildMenuCard()),
                          const SizedBox(width: 16),
                          Expanded(
                              flex: 3, child: _buildRightCard()),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  // LEFT MENU
  Widget _buildMenuCard() {
    return BaseView<HomeViewModel>(onModelReady: (model) {
      getUserDetails(model);
    }, builder: (context, model, child) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.background,
            )),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    "assets/images/user_avatar.png",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Icon(Icons.edit,
                      color: Colors.white, size: 16),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text((user == null) ? 'no name' : user!.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),

            const SizedBox(height: 15),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified,
                    color: AppColors.darkBlue, size: 16),
                SizedBox(width: 4),
                Text("KYC Verified",
                    style: TextStyle(
                        color: AppColors.blacks, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),

            // Menu Items
            _menuTile(
                icon: Icons.person,
                title: "Personal Information",
                selected:
                    _selectedOption == MenuOption.personalInfo,
                onTap: () => setState(() =>
                    _selectedOption = MenuOption.personalInfo)),
            const SizedBox(height: 3),

            _menuTile(
                icon: Icons.person,
                title: "Update Profile",
                selected: _selectedOption ==
                    MenuOption.deliveryHistory,
                onTap: () => setState(() => _selectedOption =
                    MenuOption.deliveryHistory)),
            const SizedBox(height: 3),

            _menuTile(
                icon: Icons.verified,
                title: "KYC Verification",
                selected:
                    _selectedOption == MenuOption.bankAccounts,
                onTap: () => setState(() =>
                    _selectedOption = MenuOption.bankAccounts)),
            const SizedBox(height: 3),

            ListTile(
              leading: const Icon(Iconsax.logout,
                  color: Colors.redAccent),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }

  // RIGHT CONTENT
  Widget _buildRightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.background)),
      child: _buildRightContent(),
    );
  }

  Widget _buildRightContent() {
    switch (_selectedOption) {
      case MenuOption.personalInfo:
        return _personalInfoWidget();
      case MenuOption.deliveryHistory:
        return const Center(
            child: Text("Update Profile",
                style: TextStyle(fontSize: 16)));
      case MenuOption.bankAccounts:
        return const Center(
            child: Text("KYC Verification",
                style: TextStyle(fontSize: 16)));
    }
  }

 Widget _personalInfoWidget() {
  return BaseView<HomeViewModel>(
    onModelReady: (model) {
      getUserDetails(model);
    },
    builder: (context, model, child) {
      if (user == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Personal Information",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 20),
          _infoRow("Full Name", user?.name ?? "N/A"),
          _infoRow("Email", user?.email ?? "N/A"),
          _infoRow("Phone", user?.phone ?? "No phone number"),
          _infoRow("Address", user?.address ?? "No address"),
          _infoRow("Gender", user?.gender ?? "No gender"),
          _infoRow("KYC Status", "Verified",
              valueColor: AppColors.primary),
          const SizedBox(height: 20),
        ],
      );
    },
  );
}

  // Menu tile
  static Widget _menuTile({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: selected
              ? AppColors.foundationPurpleNormal
              : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: selected
              ? AppColors.foundationPurpleNormal
              : Colors.black87,
          fontWeight:
              selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }

  // Info row
 Widget _infoRow(String label, String value,
    {Color valueColor = Colors.black87}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(color: Colors.black54)),
        ),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

}
