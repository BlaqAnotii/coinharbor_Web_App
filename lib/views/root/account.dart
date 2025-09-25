import 'package:coinharbor/controllers/auth_vm.dart';
import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:coinharbor/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

enum MenuOption {
  personalInfo,
  deliveryHistory,

  ///  bankAccounts,
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

  final TextEditingController _phoneController =
      TextEditingController();
  final TextEditingController _addressController =
      TextEditingController();
  final TextEditingController _dateOfBirthController =
      TextEditingController();
  final TextEditingController genderController =
      TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  final List<String> _genderOptions = ['Male', 'Female'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(
      today.year - 18,
      today.month,
      today.day,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate:
          eighteenYearsAgo, // 👈 restrict max date to 18 years ago
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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

            // _menuTile(
            //     icon: Icons.verified,
            //     title: "KYC Verification",
            //     selected:
            //         _selectedOption == MenuOption.bankAccounts,
            //     onTap: () => setState(() =>
            //         _selectedOption = MenuOption.bankAccounts)),
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
        return _updateProfileWidget();
      // case MenuOption.bankAccounts:
      //   return _updateKYC();
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
            _infoRow("Gender", user?.gender ?? "No gender"),
            _infoRow("Address", user?.address ?? "No address"),
            _infoRow(
                "Address", user!.country?.name ?? 'No country'),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _updateProfileWidget() {
    return BaseView<AuthViewModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text("Update Profile",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Divider(height: 20),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _dateOfBirthController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'Select date of birth',
                      hintStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      disabledBorder: InputBorder.none,
                    ),
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.background,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    hint: const Text(
                      'Select Gender',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: model.selectedgender,
                    icon: const Icon(Iconsax.arrow_down_1,
                        color: Color(0xff161616), size: 16),
                    items: model.gender.map((coin) {
                      return DropdownMenuItem<String>(
                        value: coin['id'],
                        child: Text(
                          coin['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      print('onChanged fired with: $val');
                      // <-- use dialog's setState
                      setState(() {
                        // <-- use dialog's setState
                        model.selectedgender = val!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 3,
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Residential Address',
                  hintStyle: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    hint: const Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: model.selectedCountryCode,
                    icon: const Icon(Iconsax.arrow_down_1,
                        color: Color(0xff161616), size: 16),
                    items: model.countries.map((coin) {
                      return DropdownMenuItem<int>(
                        value: coin['id'],
                        child: Text(
                          coin['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      print('onChanged fired with: $val');
                      // <-- use dialog's setState
                      setState(() {
                        // <-- use dialog's setState
                        model.selectedCountryCode = val!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                onPressed: () {
                  if (_dateOfBirthController.text.isNotEmpty &&
                      _phoneController.text.isNotEmpty &&
                      model.selectedgender != null &&
                      _addressController.text.isNotEmpty &&
                      model.selectedCountryCode != null) {
                    model.processCompleteProfile(
                      context,
                      _dateOfBirthController.text,
                      _addressController.text,
                      _phoneController.text,
                    );
                  } else {
                    showCustomToast('Missing Field',
                        toastType: ToastType.info);
                  }
                },
                text: 'Update',
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _updateKYC() {
  //   return BaseView<AuthViewModel>(
  //     onModelReady: (model) {},
  //     builder: (context, model, child) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Row(
  //               mainAxisAlignment:
  //                   MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Update Profile",
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600)),
  //               ],
  //             ),
  //             const Divider(height: 20),
  //             const SizedBox(height: 30),
  //             GestureDetector(
  //               onTap: () => _selectDate(context),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: Colors.grey.shade300),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: TextField(
  //                   controller: _dateOfBirthController,
  //                   enabled: false,
  //                   decoration: InputDecoration(
  //                     hintText: 'Select date of birth',
  //                     hintStyle: GoogleFonts.inter(
  //                       textStyle: TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.grey.shade400,
  //                       ),
  //                     ),
  //                     suffixIcon: const Icon(
  //                       Icons.calendar_today,
  //                       color: Colors.grey,
  //                       size: 20,
  //                     ),
  //                     border: InputBorder.none,
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       horizontal: 12,
  //                       vertical: 16,
  //                     ),
  //                     disabledBorder: InputBorder.none,
  //                   ),
  //                   style: GoogleFonts.inter(
  //                     textStyle: const TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 30),
  //             TextField(
  //               controller: _phoneController,
  //               keyboardType: TextInputType.phone,
  //               decoration: InputDecoration(
  //                 hintText: 'Phone number',
  //                 hintStyle: GoogleFonts.inter(
  //                   textStyle: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey.shade400,
  //                   ),
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: const BorderSide(
  //                     color: AppColors.background,
  //                   ),
  //                 ),
  //                 disabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             TextField(
  //               controller: genderController,
  //               decoration: InputDecoration(
  //                 hintText: 'Male, Female, Others',
  //                 hintStyle: GoogleFonts.inter(
  //                   textStyle: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey.shade400,
  //                   ),
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: const BorderSide(
  //                     color: AppColors.background,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             TextField(
  //               maxLines: 3,
  //               controller: _addressController,
  //               decoration: InputDecoration(
  //                 hintText: 'Residential Address',
  //                 hintStyle: GoogleFonts.inter(
  //                   textStyle: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey.shade400,
  //                   ),
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                   borderSide: const BorderSide(
  //                     color: AppColors.background,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.only(left: 10),
  //               decoration: BoxDecoration(
  //                 border:
  //                     Border.all(color: Colors.grey.shade300),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButton<int>(
  //                   isExpanded: true,
  //                   dropdownColor: Colors.white,
  //                   hint: const Text(
  //                     'Select Country',
  //                     style: TextStyle(
  //                       fontSize: 15,
  //                       color: Colors.grey,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   value: model.selectedCountryCode,
  //                   icon: const Icon(Iconsax.arrow_down_1,
  //                       color: Color(0xff161616), size: 16),
  //                   items: model.countries.map((coin) {
  //                     return DropdownMenuItem<int>(
  //                       value: coin['id'],
  //                       child: Text(
  //                         coin['name']!,
  //                         style: const TextStyle(
  //                           fontSize: 15,
  //                           color: AppColors.black,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     );
  //                   }).toList(),
  //                   onChanged: (val) {
  //                     print('onChanged fired with: $val');
  //                     // <-- use dialog's setState
  //                     setState(() {
  //                       // <-- use dialog's setState
  //                       model.selectedCountryCode = val!;
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             AppButton(
  //               onPressed: () {
  //                 if (_dateOfBirthController.text.isNotEmpty &&
  //                     _phoneController.text.isNotEmpty &&
  //                     genderController.text.isNotEmpty &&
  //                     _addressController.text.isNotEmpty &&
  //                     model.selectedCountryCode != null) {
  //                   model.processCompleteProfile(
  //                     context,
  //                     _dateOfBirthController.text,
  //                     genderController.text,
  //                     _addressController.text,
  //                     _phoneController.text,
  //                   );
  //                 }
  //               },
  //               text: 'Update',
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
