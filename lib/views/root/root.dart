import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/views/root/account.dart';
import 'package:coinharbor/views/root/copy_trade.dart';
import 'package:coinharbor/views/root/dashboard.dart';
import 'package:coinharbor/views/root/investments.dart';
import 'package:coinharbor/views/root/trade_view.dart';
import 'package:coinharbor/views/root/transactions.dart';
import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:country_flags/country_flags.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:icons_plus/icons_plus.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  String selectedMenu = "Dashboard"; // default

  final List<String> menus = [
    "Dashboard",
    "Transactions",
    "Trade View",
    "Copy Trade",
    "Investments",
    "Account",
  ];

  final Map<String, Widget> menuPages = {
    "Dashboard": const DashboardScreen(),
    "Transactions": const TransactionsScreen(),
    "Trade View": const TradeViewScreen(),
    "Copy Trade": const CopyTradeScreen(),
    "Investments": const InvestmentsScreen(),
    "Account": const AccountScreen(),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tab =
        GoRouterState.of(context).uri.queryParameters['tab'];
    if (tab != null && menus.contains(tab)) {
      setState(() {
        selectedMenu = tab;
      });
    }
  }

  void onMenuTap(String menu) {
    setState(() {
      selectedMenu = menu;
    });
    context.go('/homepage?tab=$menu');
  }

  String selectedCountry = "US"; // default

  final List<Map<String, String>> countries = [
    {"code": "US", "name": "United States"},
    {"code": "AE", "name": "United Arab Emirates"},
    {"code": "SG", "name": "Singapore"},
    {"code": "CH", "name": "Switzerland"},
    {"code": "SV", "name": "El Salvador"},
    {"code": "DE", "name": "Germany"},
    {"code": "IN", "name": "India"},
    {"code": "GB", "name": "United Kingdom"},
    {"code": "CA", "name": "Canada"},
  ];

  User? user;

  getUserDetails(HomeViewModel model) async {
    await model.getUser();
    if (model.user == null) {
      showCustomToast("Failed to load user profile",
          toastType: ToastType.error, time: 5);
    }
    setState(() {
      user = model.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BaseView<HomeViewModel>(
        onModelReady: (model) {
          getUserDetails(model);
          model.setAppTitle('Homepage');
        },
        onListenForEvent: (model, event) {},
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            drawer: ResponsiveWidget.isSmallScreen(context)
                ? Drawer(
                    shape: const BeveledRectangleBorder(),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/image/logo.png',
                            scale: 4,
                            width: CalcWidth(context, 190,
                                maxWidth: 200),
                            height: 85.0,
                          ),
                        ),
                        55.0.sbH,
                        DrawerMenuItem(
                          icon: Icons.bar_chart,
                          label: "Dashboard",
                          selected: selectedMenu == "Dashboard",
                          onTap: () {
                            onMenuTap("Dashboard");
                            Navigator.pop(context);
                          },
                        ),
                        DrawerMenuItem(
                          icon: Icons.receipt_long,
                          label: "Transactions",
                          selected:
                              selectedMenu == "Transactions",
                          onTap: () {
                            onMenuTap("Transactions");
                            Navigator.pop(context);
                          },
                        ),
                        DrawerMenuItem(
                          icon: Icons.pie_chart,
                          label: "Trade View",
                          selected: selectedMenu == "Trade View",
                          onTap: () {
                            onMenuTap("Trade View");
                            Navigator.pop(context);
                          },
                        ),
                        DrawerMenuItem(
                          icon: Icons.bar_chart,
                          label: "Copy Trade",
                          selected: selectedMenu == "Copy Trade",
                          onTap: () {
                            onMenuTap("Copy Trade");
                            Navigator.pop(context);
                          },
                        ),
                        DrawerMenuItem(
                          icon: Iconsax.bank_outline,
                          label: "Investments",
                          selected:
                              selectedMenu == "Investments",
                          onTap: () {
                            onMenuTap("Investments");
                            Navigator.pop(context);
                          },
                        ),
                        DrawerMenuItem(
                          icon: Icons.person,
                          label: "Account",
                          selected: selectedMenu == "Account",
                          onTap: () {
                            onMenuTap("Account");
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ListTile(
                          onTap: () {
                            model.processLogout(context);
                          },
                          leading: const Icon(Iconsax.logout_bold),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  )
                : null,
            body: Row(
              children: [
                // Sidebar
                if (ResponsiveWidget.isLargeScreen(context))
                  Container(
                    width: screenSize.width / 5.5,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/image/logo.png',
                            scale: 4,
                            width: CalcWidth(context, 190,
                                maxWidth: 200),
                            height: 85.0,
                          ),
                        ),
                        55.0.sbH,
                        Expanded(
                          child: ListView(
                            children: [
                              DrawerMenuItem(
                                icon: Icons.dashboard,
                                label: "Dashboard",
                                selected:
                                    selectedMenu == "Dashboard",
                                onTap: () =>
                                    onMenuTap("Dashboard"),
                              ),
                              DrawerMenuItem(
                                icon: Icons.receipt_long,
                                label: "Transactions",
                                selected: selectedMenu ==
                                    "Transactions",
                                onTap: () =>
                                    onMenuTap("Transactions"),
                              ),
                              DrawerMenuItem(
                                icon: Icons.pie_chart,
                                label: "Trade View",
                                selected:
                                    selectedMenu == "Trade View",
                                onTap: () {
                                  onMenuTap("Trade View");
                                },
                              ),
                              DrawerMenuItem(
                                icon: Icons.bar_chart,
                                label: "Copy Trade",
                                selected:
                                    selectedMenu == "Copy Trade",
                                onTap: () {
                                  onMenuTap("Copy Trade");
                                },
                              ),
                              DrawerMenuItem(
                                icon: Iconsax.bank_outline,
                                label: "Investments",
                                selected: selectedMenu ==
                                    "Investments",
                                onTap: () {
                                  onMenuTap("Investments");
                                },
                              ),
                              DrawerMenuItem(
                                icon: Icons.person,
                                label: "Account",
                                selected:
                                    selectedMenu == "Account",
                                onTap: () {
                                  onMenuTap("Account");
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: AppColors.white,
                        elevation: 0,
                        toolbarHeight: 80,
                        automaticallyImplyLeading: false,
                        leading: (ResponsiveWidget.isLargeScreen(
                                context))
                            ? null
                            : Builder(
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Scaffold.of(context)
                                          .openDrawer();
                                    },
                                    child: ResponsiveWidget
                                            .isSmallScreen(
                                                context)
                                        ? Image.asset(
                                            "assets/image/sort.png",
                                            height: 10,
                                            width: 10,
                                            scale: 16,
                                            color: const Color(
                                                0xff000000),
                                          )
                                        : null,
                                  );
                                },
                              ),
                        title: Text(
                          selectedMenu,
                          style: TextStyle(
                            fontSize:
                                (ResponsiveWidget.isLargeScreen(
                                        context))
                                    ? 22
                                    : 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        centerTitle: false,
                        actions: [
                          if (ResponsiveWidget.isLargeScreen(
                              context))
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius:
                                    BorderRadius.circular(40),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor:
                                      const Color(0xffFFFFFF),
                                  value: selectedCountry,
                                  alignment: Alignment.center,
                                  isExpanded: false,
                                  icon: const SizedBox.shrink(),
                                  items:
                                      countries.map((country) {
                                    return DropdownMenuItem<
                                        String>(
                                      value: country["code"],
                                      child: Row(
                                        mainAxisSize:
                                            MainAxisSize.min,
                                        children: [
                                          CountryFlag
                                              .fromCountryCode(
                                            country["code"]!,
                                            theme:
                                                const ImageTheme(
                                              shape: Circle(),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: 10),
                                          Text(
                                            country["name"]!,
                                            style:
                                                const TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Colors.black87,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: 11),
                                          const Icon(
                                            Iconsax.arrow_down_1_bold,
                                            color: Color(
                                                0xff161616),
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCountry = value!;
                                    });
                                    debugPrint(
                                        "Selected country: $value");
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(width: 25),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                                'assets/icons/notification.svg'),
                          ),
                          const SizedBox(width: 25),
                          if (ResponsiveWidget.isLargeScreen(
                              context))
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius:
                                    BorderRadius.circular(40),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  value: (user == null)
                                      ? 'no name'
                                      : user!.name,
                                  isExpanded:
                                      false, // keeps compact width
                                  customButton: Row(
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundImage: AssetImage(
                                            "assets/images/user_avatar.png"),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        (user == null)
                                            ? 'no name'
                                            : user!.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Iconsax.arrow_down_1_bold,
                                        color: Color(0xff161616),
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: (user == null)
                                          ? 'no name'
                                          : user!.name,
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                          horizontal: 4,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              (user == null)
                                                  ? 'no name'
                                                  : user!.name,
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Divider(
                                              color: AppColors
                                                  .foundationGreyLighter,
                                              thickness: 0.3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      onTap: () {
                                        context.go(
                                            '/homepage?tab=Account');
                                      },
                                      value: "Account Settings",
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Iconsax.setting_bold,
                                            color: AppColors
                                                .foundationGreyLightActive,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Account Settings",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      onTap: () {
                                        model.processLogout(
                                            context);
                                      },
                                      value: "Logout",
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Iconsax.logout_bold,
                                            color: AppColors.red,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  AppColors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == "Logout") {
                                      debugPrint(
                                          "Logging out...");
                                    } else if (value ==
                                        "Account Settings") {
                                      debugPrint(
                                          "Opening settings...");
                                    }
                                  },
                                  dropdownStyleData:
                                      DropdownStyleData(
                                    elevation: 10,
                                    direction:
                                        DropdownDirection.left,
                                    offset: const Offset(0, 7),
                                    // 👈 pushes it 12px down
                                    width:
                                        300, // 👈 set custom dropdown width
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors
                                              .lightGrey,
                                          offset:
                                              Offset(0.0, 1.0),
                                          blurRadius: 1.0,
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(
                                              12),
                                      color: Colors.white,
                                    ),
                                  ),
                                  menuItemStyleData:
                                      const MenuItemStyleData(
                                    height: 65,
                                  ),
                                ),
                              ),
                            ),
                          (ResponsiveWidget.isSmallScreen(
                                  context))
                              ? const SizedBox(
                                  width: 1,
                                )
                              : SizedBox(
                                  width: screenSize.width / 40,
                                ),
                        ],
                      ),
                      // Page content below AppBar
                      Expanded(
                        child: Container(
                          color: AppColors.white,
                          child: menuPages[selectedMenu] ??
                              const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.foundationPurpleNormal
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: selected
                ? const Color(0xffFFFFFF)
                : AppColors.foundationGreyLightHover,
          ),
          title: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: selected
                  ? const Color(0xffFFFFFF)
                  : AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
