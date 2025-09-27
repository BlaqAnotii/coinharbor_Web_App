import 'dart:convert';

import 'package:coinharbor/controllers/auth_vm.dart';
import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/transaction_model.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/data/model/wallet_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:coinharbor/widgets/input.dart';
import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  List<Wallet> allwallets = [];

  loadwallets(HomeViewModel model) async {
    model.getAllWallet().then((v) {
      setState(() {
        allwallets = v;
        // Keep only non-live events for this tab
      });
    });
  }

  final TextEditingController cryptoController =
      TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController depositAmount =
      TextEditingController();

  final TextEditingController withdrawamount =
      TextEditingController();
  final TextEditingController receipient =
      TextEditingController();

  double usdValue = 0.0;

  String selectedCrypto = "bitcoin"; // default
  final List<Map<String, String>> cryptos = [
    {"id": "bitcoin", "symbol": "BTC"},
    {"id": "ethereum", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
  ];

  String selectedCrypto2 = "bitcoin"; // default
  final List<Map<String, String>> cryptos2 = [
    {"id": "bitcoin", "symbol": "BTC"},
    {"id": "ethereum", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
  ];

  String selectedCrypto3 = "bitcoin"; // default
  final List<Map<String, String>> cryptos3 = [
    {"id": "bitcoin", "symbol": "BTC"},
    {"id": "ethereum", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
  ];

  String selectedCrypto4 = "bitcoin"; // default
  final List<Map<String, String>> cryptos4 = [
    {"id": "bitcoin", "symbol": "BTC"},
    {"id": "ethereum", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
  ];

  String selectedNetwork = "Bitcoin"; // default
  final List<Map<String, String>> network = [
    {"id": "Bitcoin", "symbol": "Bitcoin"},
    {"id": "ETH (ERC20)", "symbol": "ETH (ERC20)"},
    {"id": "TRON (TRC-20)", "symbol": "TRON (TRC-20)"},
  ];

  Future<double> fetchCryptoPrice(String id) async {
    final url = Uri.parse(
        "https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=usd");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data[id]["usd"] as num).toDouble();
    } else {
      throw Exception("Failed to load price");
    }
  }

  void convert() async {
    if (cryptoController.text.isEmpty) {
      setState(() => usdValue = 0.0);
      return;
    }

    final amount = double.tryParse(cryptoController.text) ?? 0;
    final price = await fetchCryptoPrice(selectedCrypto);

    setState(() {
      usdValue = amount * price;
    });
  }

  @override
  void initState() {
    super.initState();
    print('initState selectedCrypto2 = $selectedCrypto2');
    fetchCryptoData();

    cryptoController
        .addListener(convert); // auto-update on typing
  }

  @override
  void dispose() {
    cryptoController.dispose();
    super.dispose();
  }

  List<Transaction> transact = [];

  Future<void> fetchTransaction(HomeViewModel model) async {
    try {
      List<Transaction> fetchedtrans =
          await model.getAllTransaction();
      setState(() {
        transact = fetchedtrans;
      });
    } catch (e) {
      debugPrint("Error fetching stores: $e");
    }
  }

  List<dynamic> _coins = [];
  bool _loading = true;

  Future<void> fetchCryptoData() async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=5&page=1&price_change_percentage=24h');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _coins = json.decode(response.body);
        _loading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String buildTickerText() {
    if (_coins.isEmpty) return "Loading crypto data...";

    return _coins.map((coin) {
      final name = coin['name'];
      final price = coin['current_price'];
      final change =
          coin['price_change_percentage_24h']?.toDouble() ?? 0.0;

      final arrow = change >= 0 ? "▲" : "▼";
      final color = change >= 0 ? "🟢" : "🔴";

      return "$color $name: \$$price ($arrow ${change.toStringAsFixed(2)}%)";
    }).join("   •   ");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var mobile = ResponsiveWidget.isSmallScreen(context);
    var desktop = ResponsiveWidget.isLargeScreen(context);

    print('BUILD: selectedCrypto2 = $selectedCrypto2');
    print(
        'BUILD: items = ${cryptos2.map((c) => c['id']).toList()}');

    // before building dropdown, check membership
    assert(cryptos2.any((c) => c['id'] == selectedCrypto2),
        'selectedCrypto2 not in cryptos2 items!');

    return BaseView<HomeViewModel>(onModelReady: (model) {
      getUserDetails(model);

      loadwallets(model);
      fetchTransaction(model);
    }, builder: (context, model, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.background,
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 40,
                  child: _loading
                      ? buildSkeleton()
                      : Marquee(
                          text: buildTickerText(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          blankSpace: 50,
                          velocity: 50.0,
                          pauseAfterRound: Duration.zero,
                          startPadding: 10.0,
                        ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              desktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              height: 155.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image/dashboard.png'),
                                    fit: BoxFit.cover,
                                  )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 13,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Today's Cryptocurrency prices",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "The global crypto market cap is \$1.86T",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    AppButton3(
                                        onPressed: () {
                                          context.go(
                                              '/homepage?tab=Copy Trade');
                                        },
                                        width: 170,
                                        height: 40,
                                        text: "Copy an Expert")
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Container(
                                    width: CalcWidth(
                                        context, 170,
                                        maxWidth: 220),
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                        border: Border.all(
                                          color: AppColors
                                              .foundationGreyLighter,
                                          width: 0.3,
                                        )),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                              15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            (user == null)
                                                ? '\$1.00'
                                                : NumberFormat
                                                    .currency(
                                                    locale:
                                                        'en_US', // US formatting style
                                                    symbol:
                                                        '\$', // Currency symbol
                                                  ).format(user!
                                                    .fiatBalance),
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 19,
                                              color:
                                                  Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 9),
                                          const Text(
                                            'Main Account',
                                            style: TextStyle(
                                                color:
                                                    Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(
                                              height: 14),

                                          // Progress Bar
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        40),
                                            child:
                                                LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          40),
                                              value: 0.35,
                                              minHeight: 6,
                                              backgroundColor:
                                                  Colors.grey
                                                      .shade300,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      Colors
                                                          .green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: CalcWidth(
                                        context, 170,
                                        maxWidth: 220),
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                        border: Border.all(
                                          color: AppColors
                                              .foundationGreyLighter,
                                          width: 0.3,
                                        )),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                              15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          const Text(
                                            '\$0.00',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 19,
                                              color:
                                                  Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 9),
                                          const Text(
                                            'Trade Account',
                                            style: TextStyle(
                                                color:
                                                    Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(
                                              height: 14),

                                          // Progress Bar
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        40),
                                            child:
                                                LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          40),
                                              value: 0.55,
                                              minHeight: 6,
                                              backgroundColor:
                                                  Colors.grey
                                                      .shade300,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      Colors
                                                          .green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: CalcWidth(
                                        context, 170,
                                        maxWidth: 220),
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                        border: Border.all(
                                          color: AppColors
                                              .foundationGreyLighter,
                                          width: 0.3,
                                        )),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                              15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          const Text(
                                            '\$0.00',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 19,
                                              color:
                                                  Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 9),
                                          const Text(
                                            'Bonus Balance',
                                            style: TextStyle(
                                                color:
                                                    Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(
                                              height: 14),

                                          // Progress Bar
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        40),
                                            child:
                                                LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          40),
                                              value: 0.001,
                                              minHeight: 6,
                                              backgroundColor:
                                                  Colors.grey
                                                      .shade300,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      Colors
                                                          .green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            (allwallets.isNotEmpty)
                                ? SizedBox(
                                    width: CalcWidth(
                                        context, 690,
                                        maxWidth: 720),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: (allwallets).map(
                                          (wallet) // max 3 wallets for your layout
                                          {
                                        return Container(
                                          width: CalcWidth(
                                              context, 170,
                                              maxWidth: 220),
                                          height: 110.0,
                                          decoration:
                                              BoxDecoration(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        10),
                                            border: Border.all(
                                              color: AppColors
                                                  .foundationGreyLighter,
                                              width: 0.3,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets
                                                    .all(15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  wallet.balance
                                                      .toStringAsFixed(
                                                          2),
                                                  style:
                                                      const TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                    fontSize: 19,
                                                    color: Colors
                                                        .black87,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 9),
                                                Text(
                                                  wallet
                                                      .currency, // 👈 dynamic currency name (BTC, ETH, USDT...)
                                                  style:
                                                      const TextStyle(
                                                    color: Colors
                                                        .grey,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 14),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              40),
                                                  child:
                                                      LinearProgressIndicator(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                40),
                                                    value:
                                                        0.001, // 👉 you can replace with wallet.fiatBalance if needed
                                                    minHeight: 6,
                                                    backgroundColor:
                                                        Colors
                                                            .grey
                                                            .shade300,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors
                                                          .green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : SizedBox(
                                    width: CalcWidth(
                                        context, 690,
                                        maxWidth: 720),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Container(
                                            width: CalcWidth(
                                                context, 690,
                                                maxWidth: 720),
                                            height: 110.0,
                                            decoration:
                                                BoxDecoration(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          10),
                                              border: Border.all(
                                                color: AppColors
                                                    .foundationGreyLighter,
                                                width: 0.3,
                                              ),
                                            ),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.all(
                                                      15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  Text(
                                                    'NO WALLET FOUND',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                      fontSize:
                                                          19,
                                                      color: Colors
                                                          .black87,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 9),
                                                  Text(
                                                    'Create Wallet', // 👈 dynamic currency name (BTC, ETH, USDT...)
                                                    style:
                                                        TextStyle(
                                                      color: Colors
                                                          .grey,
                                                      fontSize:
                                                          14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(
                                            10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Recent Transactions',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight:
                                                FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          decoration:
                                              BoxDecoration(
                                            color: AppColors
                                                .white, // Background color
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        10),
                                            border: Border.all(
                                              color: AppColors
                                                  .foundationGreyLighter,
                                              width: 0.3,
                                            ),
                                          ),
                                          child: Theme(
                                            data:
                                                Theme.of(context)
                                                    .copyWith(
                                              cardColor:
                                                  Colors.white,
                                              dividerColor:
                                                  Colors.grey,
                                            ),
                                            child: transact
                                                    .isEmpty
                                                ? const Center(
                                                    child: Text(
                                                        "No Transaction found"),
                                                  )
                                                : DataTable(
                                                    headingRowColor:
                                                        WidgetStateProperty
                                                            .all(
                                                      AppColors
                                                          .background,
                                                    ),
                                                    dataRowHeight:
                                                        50,
                                                    columnSpacing:
                                                        75,
                                                    dividerThickness:
                                                        0.1,
                                                    columns: const [
                                                      DataColumn(
                                                        label:
                                                            Text(
                                                          'Type',
                                                          style:
                                                              TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Asset',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Amount',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Fiat Amount',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Status',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                    ],
                                                    rows: transact
                                                        .take(2) // 👈 only keep 4 transactions
                                                        .map((members) {
                                                      Color
                                                          statusColor;
                                                      switch (members
                                                          .status
                                                          .toLowerCase()) {
                                                        case 'completed':
                                                          statusColor =
                                                              Colors.green;
                                                          break;
                                                        case 'pending':
                                                          statusColor =
                                                              Colors.orange;
                                                          break;
                                                        case 'failed':
                                                          statusColor =
                                                              Colors.red;
                                                          break;
                                                        default:
                                                          statusColor =
                                                              Colors.grey;
                                                      }

                                                      return DataRow(
                                                        cells: [
                                                          DataCell(Text(members.type.isNotEmpty
                                                              ? members.type
                                                              : '-')),
                                                          DataCell(
                                                            Text(
                                                              members.asset,
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(Text(members
                                                              .amount
                                                              .toStringAsFixed(2))),
                                                          DataCell(Text(members
                                                              .fiatAmount
                                                              .toStringAsFixed(2))),
                                                          DataCell(
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 6,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: statusColor.withOpacity(0.15),
                                                                borderRadius: BorderRadius.circular(6),
                                                              ),
                                                              child: Text(
                                                                members.status,
                                                                style: TextStyle(
                                                                  color: statusColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenSize.width / 70,
                        ),
                        Column(
                          children: [
                            Container(
                              width: CalcWidth(context, 260,
                                  maxWidth: 310),
                              height: 643.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors
                                        .foundationGreyLighter,
                                    width: 0.3,
                                  )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Quick Actions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext
                                                        context) {
                                                  // final cryptoAmount =
                                                  //     cryptoController
                                                  //         .text;
                                                  //String tempValue = "bitcoin"; // local state

                                                  return BaseView<
                                                          HomeViewModel>(
                                                      onModelReady:
                                                          (model) {
                                                    debugPrint(
                                                        "Alladu======");
                                                    model.setAppTitle(
                                                        'Deposit');
                                                  }, builder: (context,
                                                          model,
                                                          child) {
                                                    return StatefulBuilder(builder:
                                                        (context,
                                                            setStateDialog) {
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left:
                                                                450,
                                                            right:
                                                                450),
                                                        child:
                                                            Container(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              10),
                                                          margin: const EdgeInsets
                                                              .only(
                                                              top: 35,
                                                              bottom: 60),
                                                          height:
                                                              300.w,
                                                          width:
                                                              300.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColors.white, // Background color
                                                            borderRadius:
                                                                BorderRadius.circular(10),
                                                            border:
                                                                const Border(
                                                              top: BorderSide(
                                                                color: AppColors.lightGrey, // Border color
                                                                width: 1, // Border width
                                                              ),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                blurRadius: 3,
                                                                offset: const Offset(0, 4),
                                                                spreadRadius: 1,
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets.all(15),
                                                            child:
                                                                Form(
                                                              // key:
                                                              //     model.formKey,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Deposit Cryptocurrency ',
                                                                    style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: AppColors.blacks,
                                                                    ),
                                                                  ),
                                                                  75.0.sbH,
                                                                  const Text(
                                                                    'Deposit Amount',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: AppColors.foundationGreyLightActive,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 10),
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                                                    decoration: BoxDecoration(
                                                                      color: AppColors.background,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        const SizedBox(height: 8),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: TextField(
                                                                                controller: depositAmount,
                                                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                                inputFormatters: [
                                                                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                                ],
                                                                                style: const TextStyle(
                                                                                  fontSize: 22,
                                                                                  color: AppColors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                                decoration: const InputDecoration(
                                                                                  hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                                  border: InputBorder.none,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            IntrinsicWidth(
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  dropdownColor: Colors.white,
                                                                                  hint: const Text(
                                                                                    'BTC',
                                                                                    style: TextStyle(
                                                                                      fontSize: 15,
                                                                                      color: AppColors.black,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  value: selectedCrypto3,
                                                                                  icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                                  items: cryptos3.map((coin) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: coin['id'],
                                                                                      child: Text(
                                                                                        coin['symbol']!,
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
                                                                                    setStateDialog(() {
                                                                                      // <-- use dialog's setState
                                                                                      selectedCrypto3 = val!;
                                                                                    });
                                                                                    print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 100),
                                                                  AppButton(
                                                                      text: 'Deposit',
                                                                      onPressed: () {
                                                                        if (depositAmount.text.isNotEmpty) {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                                debugPrint("Alladu======");
                                                                                model.setAppTitle('Deposit');
                                                                              }, builder: (context, model, child) {
                                                                                final cryptox = depositAmount.text;
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(left: 450, right: 450),
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    margin: const EdgeInsets.only(top: 35, bottom: 60),
                                                                                    height: 300.w,
                                                                                    width: 300.w,
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColors.white, // Background color
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      border: const Border(
                                                                                        top: BorderSide(
                                                                                          color: AppColors.lightGrey, // Border color
                                                                                          width: 1, // Border width
                                                                                        ),
                                                                                      ),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                          blurRadius: 3,
                                                                                          offset: const Offset(0, 4),
                                                                                          spreadRadius: 1,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(15),
                                                                                      child: Form(
                                                                                        // key:
                                                                                        //     model.formKey,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Confirm Deposit',
                                                                                              style: TextStyle(
                                                                                                fontSize: 18,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: AppColors.blacks,
                                                                                              ),
                                                                                            ),
                                                                                            75.0.sbH,
                                                                                            const Center(
                                                                                              child: Text(
                                                                                                'You’re about to deposit',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 16,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: AppColors.foundationGreyLightActive,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 10),
                                                                                            // Center(
                                                                                            //   child: Image.asset(
                                                                                            //     widget.payCurrency['flag'],
                                                                                            //     width: 40,
                                                                                            //     height: 40,
                                                                                            //   ),
                                                                                            // ),
                                                                                            const SizedBox(height: 15),
                                                                                            Center(
                                                                                              child: Text(
                                                                                                '$cryptox $selectedCrypto3',
                                                                                                style: const TextStyle(
                                                                                                  fontSize: 18,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: AppColors.primary,
                                                                                                ),
                                                                                              ),
                                                                                            ),

                                                                                            const SizedBox(height: 45),
                                                                                            Container(
                                                                                              padding: const EdgeInsets.all(10),
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppColors.background,
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  const SizedBox(height: 10),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    children: [
                                                                                                      const Text(
                                                                                                        'Service Fee',
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 14,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: AppColors.foundationGreyLightActive,
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.green.shade100,
                                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                                        ),
                                                                                                        child: const Text(
                                                                                                          'Zero Fees',
                                                                                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(height: 13),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    children: [
                                                                                                      const Text(
                                                                                                        'Total',
                                                                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        '$cryptox $selectedCrypto3',
                                                                                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 100),
                                                                                            AppButton(
                                                                                                text: 'Confirm',
                                                                                                onPressed: () {
                                                                                                  if (selectedCrypto3.isNotEmpty && cryptox.isNotEmpty) {
                                                                                                    model.processDeposit(
                                                                                                      context,
                                                                                                      selectedCrypto3,
                                                                                                      cryptox,
                                                                                                    );
                                                                                                  } else {
                                                                                                    showCustomToast(
                                                                                                      'Transaction Failed',
                                                                                                      toastType: ToastType.error,
                                                                                                    );
                                                                                                  }
                                                                                                }),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                            },
                                                                          );
                                                                        } else {
                                                                          showCustomToast(
                                                                            'Enter Crypto Amount',
                                                                            toastType: ToastType.info,
                                                                          );
                                                                        }
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                                },
                                              );
                                            },
                                            child: _buildActionButton(
                                                'assets/images/payment.png',
                                                'Receive')),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext
                                                      context) {
                                                // final cryptoAmount =
                                                //     cryptoController
                                                //         .text;
                                                //String tempValue = "bitcoin"; // local state

                                                return BaseView<
                                                        HomeViewModel>(
                                                    onModelReady:
                                                        (model) {
                                                  debugPrint(
                                                      "Alladu======");
                                                  model.setAppTitle(
                                                      'Withdraw');
                                                }, builder: (context,
                                                        model,
                                                        child) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context,
                                                              setStateDialog) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                              450,
                                                          right:
                                                              450),
                                                      child:
                                                          Container(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            10),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top:
                                                                35,
                                                            bottom:
                                                                60),
                                                        height:
                                                            300.w,
                                                        width:
                                                            300.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.white, // Background color
                                                          borderRadius:
                                                              BorderRadius.circular(10),
                                                          border:
                                                              const Border(
                                                            top:
                                                                BorderSide(
                                                              color: AppColors.lightGrey, // Border color
                                                              width: 1, // Border width
                                                            ),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5), // Light shadow
                                                              blurRadius: 3,
                                                              offset: const Offset(0, 4),
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              15),
                                                          child:
                                                              Form(
                                                            // key:
                                                            //     model.formKey,
                                                            child:
                                                                Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text(
                                                                  'Withdraw Cryptocurrency ',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AppColors.blacks,
                                                                  ),
                                                                ),
                                                                75.0.sbH,
                                                                const Text(
                                                                  'Withdraw Amount',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: AppColors.foundationGreyLightActive,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.background,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 8),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: TextField(
                                                                              controller: withdrawamount,
                                                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                              ],
                                                                              style: const TextStyle(
                                                                                fontSize: 22,
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              decoration: const InputDecoration(
                                                                                hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                                border: InputBorder.none,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          IntrinsicWidth(
                                                                            child: DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                isExpanded: true,
                                                                                dropdownColor: Colors.white,
                                                                                hint: const Text(
                                                                                  'BTC',
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: AppColors.black,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                value: selectedCrypto4,
                                                                                icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                                items: cryptos4.map((coin) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: coin['id'],
                                                                                    child: Text(
                                                                                      coin['symbol']!,
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
                                                                                  setStateDialog(() {
                                                                                    // <-- use dialog's setState
                                                                                    selectedCrypto4 = val!;
                                                                                  });
                                                                                  print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 15),
                                                                Input(
                                                                  controller: receipient,
                                                                  label: 'Recepient Wallet Address',
                                                                  validator: (val) {
                                                                    if (val!.isEmpty) {
                                                                      return 'Enter recepient';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                                const SizedBox(height: 15),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.background,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: DropdownButtonHideUnderline(
                                                                    child: DropdownButton<String>(
                                                                      isExpanded: true,
                                                                      dropdownColor: Colors.white,
                                                                      hint: const Text(
                                                                        'Bitcoin',
                                                                        style: TextStyle(
                                                                          fontSize: 15,
                                                                          color: AppColors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      value: selectedNetwork,
                                                                      icon: const Icon(
                                                                        Iconsax.arrow_down_1_bold,
                                                                        color: Color(0xff161616),
                                                                        size: 16,
                                                                      ),
                                                                      items: network.map((coin) {
                                                                        return DropdownMenuItem<String>(
                                                                          value: coin['id'],
                                                                          child: Text(
                                                                            coin['symbol']!,
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
                                                                        setStateDialog(() {
                                                                          // <-- use dialog's setState
                                                                          selectedNetwork = val!;
                                                                        });
                                                                        print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 100),
                                                                AppButton(
                                                                    text: 'Withdraw',
                                                                    onPressed: () {
                                                                      if (withdrawamount.text.isNotEmpty) {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                              debugPrint("Alladu======");
                                                                              model.setAppTitle('Deposit');
                                                                            }, builder: (context, model, child) {
                                                                              final withdraw = withdrawamount.text;
                                                                              final receiver = receipient.text;
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(left: 450, right: 450),
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  margin: const EdgeInsets.only(top: 35, bottom: 60),
                                                                                  height: 300.w,
                                                                                  width: 300.w,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.white, // Background color
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    border: const Border(
                                                                                      top: BorderSide(
                                                                                        color: AppColors.lightGrey, // Border color
                                                                                        width: 1, // Border width
                                                                                      ),
                                                                                    ),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                        blurRadius: 3,
                                                                                        offset: const Offset(0, 4),
                                                                                        spreadRadius: 1,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Form(
                                                                                      // key:
                                                                                      //     model.formKey,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          const Text(
                                                                                            'Confirm Withdraw',
                                                                                            style: TextStyle(
                                                                                              fontSize: 18,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: AppColors.blacks,
                                                                                            ),
                                                                                          ),
                                                                                          75.0.sbH,
                                                                                          const Center(
                                                                                            child: Text(
                                                                                              'You’re about to withdraw',
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: AppColors.foundationGreyLightActive,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          // Center(
                                                                                          //   child: Image.asset(
                                                                                          //     widget.payCurrency['flag'],
                                                                                          //     width: 40,
                                                                                          //     height: 40,
                                                                                          //   ),
                                                                                          // ),
                                                                                          const SizedBox(height: 15),
                                                                                          Center(
                                                                                            child: Text(
                                                                                              '$withdraw $selectedCrypto4',
                                                                                              style: const TextStyle(
                                                                                                fontSize: 18,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: AppColors.primary,
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                          const SizedBox(height: 45),
                                                                                          Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            decoration: BoxDecoration(
                                                                                              color: AppColors.background,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                const SizedBox(height: 10),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Service Fee',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        color: AppColors.foundationGreyLightActive,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.green.shade100,
                                                                                                        borderRadius: BorderRadius.circular(12),
                                                                                                      ),
                                                                                                      child: const Text(
                                                                                                        'Zero Fees',
                                                                                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                const SizedBox(height: 13),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Recepient',
                                                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      receiver,
                                                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                const SizedBox(height: 13),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Network',
                                                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      selectedNetwork,
                                                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                const SizedBox(height: 13),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Total',
                                                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      '$withdraw $selectedCrypto4',
                                                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 80),
                                                                                          AppButton(
                                                                                              text: 'Confirm',
                                                                                              onPressed: () {
                                                                                                if (selectedCrypto3.isNotEmpty && withdraw.isNotEmpty) {
                                                                                                  model.processWithdraw(context, selectedCrypto4, withdraw, selectedNetwork, receiver);
                                                                                                } else {
                                                                                                  showCustomToast(
                                                                                                    'Transaction Failed',
                                                                                                    toastType: ToastType.error,
                                                                                                  );
                                                                                                }
                                                                                              }),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                          },
                                                                        );
                                                                      } else {
                                                                        showCustomToast(
                                                                          'Enter Crypto Amount',
                                                                          toastType: ToastType.info,
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                              },
                                            );
                                          },
                                          child:
                                              _buildActionButton(
                                            'assets/images/send.png',
                                            'Send',
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext
                                                      context) {
                                                // final cryptoAmount =
                                                //     cryptoController
                                                //         .text;
                                                //String tempValue = "bitcoin"; // local state

                                                return BaseView<
                                                        HomeViewModel>(
                                                    onModelReady:
                                                        (model) {
                                                  debugPrint(
                                                      "Alladu======");
                                                  model.setAppTitle(
                                                      'Add Wallet');
                                                }, builder: (context,
                                                        model,
                                                        child) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context,
                                                              setStateDialog) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                              450,
                                                          right:
                                                              450),
                                                      child:
                                                          Container(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            10),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top:
                                                                35,
                                                            bottom:
                                                                60),
                                                        height:
                                                            300.w,
                                                        width:
                                                            300.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.white, // Background color
                                                          borderRadius:
                                                              BorderRadius.circular(10),
                                                          border:
                                                              const Border(
                                                            top:
                                                                BorderSide(
                                                              color: AppColors.lightGrey, // Border color
                                                              width: 1, // Border width
                                                            ),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5), // Light shadow
                                                              blurRadius: 3,
                                                              offset: const Offset(0, 4),
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              15),
                                                          child:
                                                              Form(
                                                            // key:
                                                            //     model.formKey,
                                                            child:
                                                                Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text(
                                                                  'Create Wallet',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AppColors.blacks,
                                                                  ),
                                                                ),
                                                                75.0.sbH,
                                                                const Text(
                                                                  'Select Currency',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: AppColors.foundationGreyLightActive,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.background,
                                                                    borderRadius: BorderRadius.circular(30),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 8),
                                                                      DropdownButtonHideUnderline(
                                                                        child: DropdownButton<String>(
                                                                          isExpanded: true,
                                                                          dropdownColor: Colors.white,
                                                                          hint: const Text(
                                                                            'BTC',
                                                                            style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: AppColors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          value: model.selectedCrypto,
                                                                          icon: const Icon(
                                                                            Iconsax.arrow_down_1_bold,
                                                                            color: Color(0xff161616),
                                                                            size: 16,
                                                                          ),
                                                                          items: model.cryptos.map((coin) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: coin['id'],
                                                                              child: Text(
                                                                                coin['symbol']!,
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
                                                                            setStateDialog(() {
                                                                              // <-- use dialog's setState
                                                                              model.selectedCrypto = val!;
                                                                            });
                                                                            print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 100),
                                                                AppButton(
                                                                  text: 'Create Wallet',
                                                                  onPressed: () {
                                                                    if (model.selectedCrypto.isNotEmpty) {
                                                                      model.processAddWallet(
                                                                        context,
                                                                      );
                                                                    } else {
                                                                      showCustomToast(
                                                                        'Please Select Currency',
                                                                        toastType: ToastType.info,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                              },
                                            );
                                          },
                                          child:
                                              _buildActionButton(
                                            'assets/images/exchange.png',
                                            'Add Wallet',
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext
                                                      context) {
                                                // final cryptoAmount =
                                                //     cryptoController
                                                //         .text;
                                                //String tempValue = "bitcoin"; // local state

                                                return BaseView<
                                                        HomeViewModel>(
                                                    onModelReady:
                                                        (model) {
                                                  debugPrint(
                                                      "Alladu======");
                                                  model.setAppTitle(
                                                      'Transfer');
                                                }, builder: (context,
                                                        model,
                                                        child) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context,
                                                              setStateDialog) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                              450,
                                                          right:
                                                              450),
                                                      child:
                                                          Container(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            10),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top:
                                                                35,
                                                            bottom:
                                                                60),
                                                        height:
                                                            300.w,
                                                        width:
                                                            300.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.white, // Background color
                                                          borderRadius:
                                                              BorderRadius.circular(10),
                                                          border:
                                                              const Border(
                                                            top:
                                                                BorderSide(
                                                              color: AppColors.lightGrey, // Border color
                                                              width: 1, // Border width
                                                            ),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5), // Light shadow
                                                              blurRadius: 3,
                                                              offset: const Offset(0, 4),
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              15),
                                                          child:
                                                              Form(
                                                            // key:
                                                            //     model.formKey,
                                                            child:
                                                                Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text(
                                                                  'Transfer to Trade Account',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AppColors.blacks,
                                                                  ),
                                                                ),
                                                                75.0.sbH,
                                                                const Text(
                                                                  'Amount to Transfer',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: AppColors.foundationGreyLightActive,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.background,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 8),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: TextField(
                                                                              controller: amount,
                                                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                              ],
                                                                              style: const TextStyle(
                                                                                fontSize: 22,
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              decoration: const InputDecoration(
                                                                                hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                                border: InputBorder.none,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          IntrinsicWidth(
                                                                            child: DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                isExpanded: true,
                                                                                dropdownColor: Colors.white,
                                                                                hint: const Text(
                                                                                  'BTC',
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: AppColors.black,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                value: selectedCrypto2,
                                                                                icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                                items: cryptos2.map((coin) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: coin['id'],
                                                                                    child: Text(
                                                                                      coin['symbol']!,
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
                                                                                  setStateDialog(() {
                                                                                    // <-- use dialog's setState
                                                                                    selectedCrypto2 = val!;
                                                                                  });
                                                                                  print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 100),
                                                                AppButton(
                                                                    text: 'Transfer',
                                                                    onPressed: () {
                                                                      if (amount.text.isNotEmpty) {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                              debugPrint("Alladu======");
                                                                              model.setAppTitle('Transfer');
                                                                            }, builder: (context, model, child) {
                                                                              final cryptoamount = amount.text;
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(left: 450, right: 450),
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  margin: const EdgeInsets.only(top: 35, bottom: 60),
                                                                                  height: 300.w,
                                                                                  width: 300.w,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.white, // Background color
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    border: const Border(
                                                                                      top: BorderSide(
                                                                                        color: AppColors.lightGrey, // Border color
                                                                                        width: 1, // Border width
                                                                                      ),
                                                                                    ),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                        blurRadius: 3,
                                                                                        offset: const Offset(0, 4),
                                                                                        spreadRadius: 1,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Form(
                                                                                      // key:
                                                                                      //     model.formKey,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          const Text(
                                                                                            'Confirm Transfer',
                                                                                            style: TextStyle(
                                                                                              fontSize: 18,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: AppColors.blacks,
                                                                                            ),
                                                                                          ),
                                                                                          75.0.sbH,
                                                                                          const Center(
                                                                                            child: Text(
                                                                                              'You’re about to transfer',
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: AppColors.foundationGreyLightActive,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          // Center(
                                                                                          //   child: Image.asset(
                                                                                          //     widget.payCurrency['flag'],
                                                                                          //     width: 40,
                                                                                          //     height: 40,
                                                                                          //   ),
                                                                                          // ),
                                                                                          const SizedBox(height: 15),
                                                                                          Center(
                                                                                            child: Text(
                                                                                              '$cryptoamount $selectedCrypto2',
                                                                                              style: const TextStyle(
                                                                                                fontSize: 18,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: AppColors.primary,
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                          const SizedBox(height: 45),
                                                                                          Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            decoration: BoxDecoration(
                                                                                              color: AppColors.background,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                const SizedBox(height: 10),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Service Fee',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        color: AppColors.foundationGreyLightActive,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.green.shade100,
                                                                                                        borderRadius: BorderRadius.circular(12),
                                                                                                      ),
                                                                                                      child: const Text(
                                                                                                        'Zero Fees',
                                                                                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                const SizedBox(height: 13),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      'Total',
                                                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      '$cryptoamount $selectedCrypto2',
                                                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 100),
                                                                                          AppButton(
                                                                                              text: 'Confirm',
                                                                                              onPressed: () {
                                                                                                if (selectedCrypto2.isNotEmpty && cryptoamount.isNotEmpty) {
                                                                                                  model.processTransfer(
                                                                                                    context,
                                                                                                    selectedCrypto2,
                                                                                                    cryptoamount,
                                                                                                  );
                                                                                                } else {
                                                                                                  showCustomToast(
                                                                                                    'Transaction Failed',
                                                                                                    toastType: ToastType.error,
                                                                                                  );
                                                                                                }
                                                                                              }),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                          },
                                                                        );
                                                                      } else {
                                                                        showCustomToast(
                                                                          'Enter Crypto Amount',
                                                                          toastType: ToastType.info,
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                              },
                                            );
                                          },
                                          child: _buildActionButton(
                                              'assets/images/send.png',
                                              'Transfer'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 45,
                                    ),
                                    const Text(
                                      'Convert to Fiat',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 12,
                                          vertical: 9),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.background,
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              height: 8),
                                          const Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                              "From Crypto",
                                              style: TextStyle(
                                                  color: Color(
                                                      0xff161616),
                                                  fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                    controller:
                                                        cryptoController,
                                                    keyboardType: const TextInputType
                                                        .numberWithOptions(
                                                        decimal:
                                                            true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'^\d*\.?\d*')),
                                                    ],
                                                    style:
                                                        const TextStyle(
                                                      fontSize:
                                                          22,
                                                      color: AppColors
                                                          .black,
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      hint: Text(
                                                          '0',
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: AppColors.black,
                                                              fontWeight: FontWeight.w600)),
                                                      border:
                                                          InputBorder
                                                              .none,
                                                    ),
                                                    onChanged: (_) =>
                                                        convert()),
                                              ),
                                              IntrinsicWidth(
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton<
                                                          String>(
                                                    isExpanded:
                                                        true,
                                                    dropdownColor:
                                                        Colors
                                                            .white,
                                                    value:
                                                        selectedCrypto,
                                                    icon: const Icon(
                                                        Iconsax
                                                            .arrow_down_1_bold,
                                                        color: Color(
                                                            0xff161616),
                                                        size:
                                                            16),
                                                    items: cryptos
                                                        .map(
                                                            (country) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: country[
                                                            'id'],
                                                        child: Text(
                                                            country[
                                                                'symbol']!,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: AppColors.black,
                                                                fontWeight: FontWeight.w600)),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (value) {
                                                      setState(
                                                          () {
                                                        selectedCrypto =
                                                            value!;
                                                      });
                                                      convert();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    _buildDivider(),
                                    const SizedBox(height: 15),

                                    // To Section
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 12,
                                          vertical: 9),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.background,
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              height: 8),
                                          const Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                                "To Fiat(USD)",
                                                style: TextStyle(
                                                    color: Color(
                                                        0xff161616),
                                                    fontSize:
                                                        14)),
                                          ),
                                          const SizedBox(
                                              height: 8),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                              usdValue == 0.0
                                                  ? "\$0.00"
                                                  : "\$${usdValue.toStringAsFixed(2)}",
                                              style:
                                                  const TextStyle(
                                                fontSize: 22,
                                                color: AppColors
                                                    .black,
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Center(
                                      child: AppButton(
                                          width: 180,
                                          onPressed: () {
                                            if (cryptoController
                                                .text
                                                .isNotEmpty) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext
                                                        context) {
                                                  final cryptoAmount =
                                                      cryptoController
                                                          .text;
                                                  return BaseView<
                                                          HomeViewModel>(
                                                      onModelReady:
                                                          (model) {
                                                    debugPrint(
                                                        "Alladu======");
                                                    model.setAppTitle(
                                                        'Convert');
                                                  }, builder: (context,
                                                          model,
                                                          child) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                              450,
                                                          right:
                                                              450),
                                                      child:
                                                          Container(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            10),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top:
                                                                35,
                                                            bottom:
                                                                60),
                                                        height:
                                                            300.w,
                                                        width:
                                                            300.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.white, // Background color
                                                          borderRadius:
                                                              BorderRadius.circular(10),
                                                          border:
                                                              const Border(
                                                            top:
                                                                BorderSide(
                                                              color: AppColors.lightGrey, // Border color
                                                              width: 1, // Border width
                                                            ),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5), // Light shadow
                                                              blurRadius: 3,
                                                              offset: const Offset(0, 4),
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              15),
                                                          child:
                                                              Form(
                                                            // key:
                                                            //     model.formKey,
                                                            child:
                                                                Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text(
                                                                  'Confirm Exchange',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AppColors.blacks,
                                                                  ),
                                                                ),
                                                                75.0.sbH,
                                                                const Center(
                                                                  child: Text(
                                                                    'You’re about to convert',
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: AppColors.foundationGreyLightActive,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                // Center(
                                                                //   child: Image.asset(
                                                                //     widget.payCurrency['flag'],
                                                                //     width: 40,
                                                                //     height: 40,
                                                                //   ),
                                                                // ),
                                                                const SizedBox(height: 15),
                                                                Center(
                                                                  child: Text(
                                                                    '$cryptoAmount $selectedCrypto',
                                                                    style: const TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: AppColors.primary,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 5),
                                                                Center(
                                                                  child: Text(
                                                                    'to \$${usdValue.toStringAsFixed(2)}',
                                                                    style: const TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: AppColors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 45),
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.background,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 10),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Service Fee',
                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.green.shade100,
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child: const Text(
                                                                              'Zero Fees',
                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 13),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Total',
                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                          ),
                                                                          Text(
                                                                            '$cryptoAmount $selectedCrypto',
                                                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 100),
                                                                AppButton(
                                                                    text: 'Confirm',
                                                                    onPressed: () {
                                                                      if (selectedCrypto.isNotEmpty && cryptoAmount.isNotEmpty) {
                                                                        model.processConvert(context, selectedCrypto, cryptoAmount);
                                                                      } else {
                                                                        showCustomToast('Transaction Failed', toastType: ToastType.error);
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              );
                                            } else {
                                              showCustomToast(
                                                'Enter Crypto Amount',
                                                toastType:
                                                    ToastType
                                                        .info,
                                              );
                                            }
                                          },
                                          text: 'Convert'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 110,
                            ),
                          ],
                        )
                      ],
                    )
                  :
//////////////////////////////////////////////////////////////////////////
                  //////////////// //MOBILE BEGINS HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  ///MOBILE IS HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  ///
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              height: 155.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image/dashboard.png'),
                                    fit: BoxFit.cover,
                                  )),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 13,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Today's Cryptocurrency prices",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "The global crypto market cap is \$1.86T",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    AppButton3(
                                        width: 170,
                                        height: 40,
                                        text: "Copy an Expert")
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GridView.count(
                              crossAxisCount:
                                  2, // two items per row
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // prevent nested scroll
                              childAspectRatio:
                                  1.4, // controls width/height ratio of cards
                              children: [
                                // --- Main Account Card ---
                                Container(
                                  width: CalcWidth(context, 160,
                                      maxWidth: 180),
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                    border: Border.all(
                                      color: AppColors
                                          .foundationGreyLighter,
                                      width: 0.3,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(
                                            15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          (user == null)
                                              ? '\$1.00'
                                              : '\$${user!.fiatBalance.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 19,
                                            color:
                                                Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 9),
                                        const Text(
                                          'Main Account',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 14),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(40),
                                          child:
                                              LinearProgressIndicator(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        40),
                                            value: 0.35,
                                            minHeight: 6,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade300,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // --- Trade Account Card ---
                                Container(
                                  width: CalcWidth(context, 160,
                                      maxWidth: 180),
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                    border: Border.all(
                                      color: AppColors
                                          .foundationGreyLighter,
                                      width: 0.3,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(
                                            15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        const Text(
                                          '\$0.00',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 19,
                                            color:
                                                Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 9),
                                        const Text(
                                          'Trade Account',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 14),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(40),
                                          child:
                                              LinearProgressIndicator(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        40),
                                            value: 0.55,
                                            minHeight: 6,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade300,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: CalcWidth(context, 360,
                                  maxWidth: 460),
                              height: 110.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors
                                        .foundationGreyLighter,
                                    width: 0.3,
                                  )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '\$0.00',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    const Text(
                                      'Bonus Balance',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(height: 14),

                                    // Progress Bar
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                              40),
                                      child:
                                          LinearProgressIndicator(
                                        borderRadius:
                                            BorderRadius
                                                .circular(40),
                                        value: 0.001,
                                        minHeight: 6,
                                        backgroundColor:
                                            Colors.grey.shade300,
                                        valueColor:
                                            const AlwaysStoppedAnimation<
                                                    Color>(
                                                Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            (allwallets.isNotEmpty)
                                ? LayoutBuilder(
                                    builder:
                                        (context, constraints) {
                                      // Dynamically decide number of columns
                                      int crossAxisCount = constraints
                                                  .maxWidth <
                                              400
                                          ? 1 // phones → single column
                                          : 2; // tablets → two columns (you can push to 3 if wide enough)

                                      double cardWidth =
                                          (constraints.maxWidth /
                                                  crossAxisCount) -
                                              1;

                                      return Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: allwallets
                                            .map((wallet) {
                                          return Container(
                                            width: cardWidth,
                                            height: 110.0,
                                            decoration:
                                                BoxDecoration(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          10),
                                              border: Border.all(
                                                color: AppColors
                                                    .foundationGreyLighter,
                                                width: 0.3,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Text(
                                                    wallet
                                                        .balance
                                                        .toStringAsFixed(
                                                            2),
                                                    style:
                                                        const TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                      fontSize:
                                                          19,
                                                      color: Colors
                                                          .black87,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: 9),
                                                  Text(
                                                    wallet
                                                        .currency,
                                                    style:
                                                        const TextStyle(
                                                      color: Colors
                                                          .grey,
                                                      fontSize:
                                                          13,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          14),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                40),
                                                    child:
                                                        LinearProgressIndicator(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      value:
                                                          0.001, // or wallet.fiatBalance / maxFiat
                                                      minHeight:
                                                          6,
                                                      backgroundColor:
                                                          Colors
                                                              .grey
                                                              .shade300,
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                              Color>(
                                                        Colors
                                                            .green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  )
                                : Container(
                                    width: CalcWidth(
                                        context, 360,
                                        maxWidth: 460),
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      border: Border.all(
                                        color: AppColors
                                            .foundationGreyLighter,
                                        width: 0.3,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                        children: [
                                          Text(
                                            'NO WALLET FOUND',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 16,
                                              color:
                                                  Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 9),
                                          Text(
                                            'Create Wallet', // 👈 dynamic currency name (BTC, ETH, USDT...)
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext
                                                    context) {
                                              // final cryptoAmount =
                                              //     cryptoController
                                              //         .text;
                                              //String tempValue = "bitcoin"; // local state

                                              return BaseView<
                                                      HomeViewModel>(
                                                  onModelReady:
                                                      (model) {
                                                debugPrint(
                                                    "Alladu======");
                                                model.setAppTitle(
                                                    'Deposit');
                                              }, builder:
                                                      (context,
                                                          model,
                                                          child) {
                                                return StatefulBuilder(
                                                    builder:
                                                        (context,
                                                            setStateDialog) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(
                                                            10),
                                                    decoration:
                                                        BoxDecoration(
                                                      color: AppColors
                                                          .white, // Background color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border:
                                                          const Border(
                                                        top:
                                                            BorderSide(
                                                          color:
                                                              AppColors.lightGrey, // Border color
                                                          width:
                                                              1, // Border width
                                                        ),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey
                                                              .withOpacity(0.5), // Light shadow
                                                          blurRadius:
                                                              3,
                                                          offset: const Offset(
                                                              0,
                                                              4),
                                                          spreadRadius:
                                                              1,
                                                        ),
                                                      ],
                                                    ),
                                                    child:
                                                        Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(
                                                              15),
                                                      child:
                                                          Form(
                                                        // key:
                                                        //     model.formKey,
                                                        child:
                                                            Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                context.pop();
                                                              },
                                                              child: Image.asset(
                                                                'assets/images/Left.png',
                                                                color: const Color(0xff161616),
                                                              ),
                                                            ),
                                                            15.0.sbH,
                                                            const Center(
                                                              child: Text(
                                                                'Deposit Cryptocurrency ',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: AppColors.blacks,
                                                                ),
                                                              ),
                                                            ),
                                                            75.0.sbH,
                                                            const Text(
                                                              'Deposit Amount',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColors.foundationGreyLightActive,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                                              decoration: BoxDecoration(
                                                                color: AppColors.background,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(height: 8),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: depositAmount,
                                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                          ],
                                                                          style: const TextStyle(
                                                                            fontSize: 22,
                                                                            color: AppColors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          decoration: const InputDecoration(
                                                                            hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                            border: InputBorder.none,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      IntrinsicWidth(
                                                                        child: DropdownButtonHideUnderline(
                                                                          child: DropdownButton<String>(
                                                                            isExpanded: true,
                                                                            dropdownColor: Colors.white,
                                                                            hint: const Text(
                                                                              'BTC',
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            value: selectedCrypto3,
                                                                            icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                            items: cryptos3.map((coin) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: coin['id'],
                                                                                child: Text(
                                                                                  coin['symbol']!,
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
                                                                              setStateDialog(() {
                                                                                // <-- use dialog's setState
                                                                                selectedCrypto3 = val!;
                                                                              });
                                                                              print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 100),
                                                            AppButton(
                                                                text: 'Deposit',
                                                                onPressed: () {
                                                                  if (depositAmount.text.isNotEmpty) {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                          debugPrint("Alladu======");
                                                                          model.setAppTitle('Deposit');
                                                                        }, builder: (context, model, child) {
                                                                          final cryptox = depositAmount.text;
                                                                          return Container(
                                                                            padding: const EdgeInsets.all(10),
                                                                            decoration: BoxDecoration(
                                                                              color: AppColors.white, // Background color
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: const Border(
                                                                                top: BorderSide(
                                                                                  color: AppColors.lightGrey, // Border color
                                                                                  width: 1, // Border width
                                                                                ),
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                  blurRadius: 3,
                                                                                  offset: const Offset(0, 4),
                                                                                  spreadRadius: 1,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Form(
                                                                                // key:
                                                                                //     model.formKey,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        context.pop();
                                                                                      },
                                                                                      child: Image.asset(
                                                                                        'assets/images/Left.png',
                                                                                        color: const Color(0xff161616),
                                                                                      ),
                                                                                    ),
                                                                                    15.0.sbH,
                                                                                    const Center(
                                                                                      child: Text(
                                                                                        'Confirm Deposit',
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: AppColors.blacks,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    75.0.sbH,
                                                                                    const Center(
                                                                                      child: Text(
                                                                                        'You’re about to deposit',
                                                                                        style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: AppColors.foundationGreyLightActive,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(height: 10),
                                                                                    // Center(
                                                                                    //   child: Image.asset(
                                                                                    //     widget.payCurrency['flag'],
                                                                                    //     width: 40,
                                                                                    //     height: 40,
                                                                                    //   ),
                                                                                    // ),
                                                                                    const SizedBox(height: 15),
                                                                                    Center(
                                                                                      child: Text(
                                                                                        '$cryptox $selectedCrypto3',
                                                                                        style: const TextStyle(
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: AppColors.primary,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    const SizedBox(height: 45),
                                                                                    Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppColors.background,
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          const SizedBox(height: 10),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              const Text(
                                                                                                'Service Fee',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 14,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: AppColors.foundationGreyLightActive,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.green.shade100,
                                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                                ),
                                                                                                child: const Text(
                                                                                                  'Zero Fees',
                                                                                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(height: 13),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              const Text(
                                                                                                'Total',
                                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                              ),
                                                                                              Text(
                                                                                                '$cryptox $selectedCrypto3',
                                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(height: 100),
                                                                                    AppButton(
                                                                                        text: 'Confirm',
                                                                                        onPressed: () {
                                                                                          if (selectedCrypto3.isNotEmpty && cryptox.isNotEmpty) {
                                                                                            model.processDeposit(
                                                                                              context,
                                                                                              selectedCrypto3,
                                                                                              cryptox,
                                                                                            );
                                                                                          } else {
                                                                                            showCustomToast(
                                                                                              'Transaction Failed',
                                                                                              toastType: ToastType.error,
                                                                                            );
                                                                                          }
                                                                                        }),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                                      },
                                                                    );
                                                                  } else {
                                                                    showCustomToast(
                                                                      'Enter Crypto Amount',
                                                                      toastType: ToastType.info,
                                                                    );
                                                                  }
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                          );
                                        },
                                        child: _buildActionButton(
                                            'assets/images/payment.png',
                                            'Receive')),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext
                                              context) {
                                            // final cryptoAmount =
                                            //     cryptoController
                                            //         .text;
                                            //String tempValue = "bitcoin"; // local state

                                            return BaseView<
                                                    HomeViewModel>(
                                                onModelReady:
                                                    (model) {
                                              debugPrint(
                                                  "Alladu======");
                                              model.setAppTitle(
                                                  'Withdraw');
                                            }, builder: (context,
                                                    model,
                                                    child) {
                                              return StatefulBuilder(
                                                  builder: (context,
                                                      setStateDialog) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(
                                                          10),
                                                  decoration:
                                                      BoxDecoration(
                                                    color: AppColors
                                                        .white, // Background color
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10),
                                                    border:
                                                        const Border(
                                                      top:
                                                          BorderSide(
                                                        color: AppColors
                                                            .lightGrey, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Light shadow
                                                        blurRadius:
                                                            3,
                                                        offset:
                                                            const Offset(
                                                                0,
                                                                4),
                                                        spreadRadius:
                                                            1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(
                                                            15),
                                                    child: Form(
                                                      // key:
                                                      //     model.formKey,
                                                      child:
                                                          Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              context.pop();
                                                            },
                                                            child:
                                                                Image.asset(
                                                              'assets/images/Left.png',
                                                              color: const Color(0xff161616),
                                                            ),
                                                          ),
                                                          15.0.sbH,
                                                          const Center(
                                                            child:
                                                                Text(
                                                              'Withdraw Cryptocurrency ',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.blacks,
                                                              ),
                                                            ),
                                                          ),
                                                          75.0.sbH,
                                                          const Text(
                                                            'Withdraw Amount',
                                                            style:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: AppColors.foundationGreyLightActive,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 9),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors.background,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child:
                                                                Column(
                                                              children: [
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: TextField(
                                                                        controller: withdrawamount,
                                                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                        ],
                                                                        style: const TextStyle(
                                                                          fontSize: 22,
                                                                          color: AppColors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                        decoration: const InputDecoration(
                                                                          hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                          border: InputBorder.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    IntrinsicWidth(
                                                                      child: DropdownButtonHideUnderline(
                                                                        child: DropdownButton<String>(
                                                                          isExpanded: true,
                                                                          dropdownColor: Colors.white,
                                                                          hint: const Text(
                                                                            'BTC',
                                                                            style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: AppColors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          value: selectedCrypto4,
                                                                          icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                          items: cryptos4.map((coin) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: coin['id'],
                                                                              child: Text(
                                                                                coin['symbol']!,
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
                                                                            setStateDialog(() {
                                                                              // <-- use dialog's setState
                                                                              selectedCrypto4 = val!;
                                                                            });
                                                                            print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 15),
                                                          Input(
                                                            controller:
                                                                receipient,
                                                            label:
                                                                'Recepient Wallet Address',
                                                            validator:
                                                                (val) {
                                                              if (val!.isEmpty) {
                                                                return 'Enter recepient';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          const SizedBox(
                                                              height: 15),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 9),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors.background,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child: DropdownButton<String>(
                                                                isExpanded: true,
                                                                dropdownColor: Colors.white,
                                                                hint: const Text(
                                                                  'Bitcoin',
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: AppColors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                value: selectedNetwork,
                                                                icon: const Icon(
                                                                  Iconsax.arrow_down_1_bold,
                                                                  color: Color(0xff161616),
                                                                  size: 16,
                                                                ),
                                                                items: network.map((coin) {
                                                                  return DropdownMenuItem<String>(
                                                                    value: coin['id'],
                                                                    child: Text(
                                                                      coin['symbol']!,
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
                                                                  setStateDialog(() {
                                                                    // <-- use dialog's setState
                                                                    selectedNetwork = val!;
                                                                  });
                                                                  print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 100),
                                                          AppButton(
                                                              text: 'Withdraw',
                                                              onPressed: () {
                                                                if (withdrawamount.text.isNotEmpty) {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                        debugPrint("Alladu======");
                                                                        model.setAppTitle('Deposit');
                                                                      }, builder: (context, model, child) {
                                                                        final withdraw = withdrawamount.text;
                                                                        final receiver = receipient.text;
                                                                        return Container(
                                                                          padding: const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                            color: AppColors.white, // Background color
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: const Border(
                                                                              top: BorderSide(
                                                                                color: AppColors.lightGrey, // Border color
                                                                                width: 1, // Border width
                                                                              ),
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                blurRadius: 3,
                                                                                offset: const Offset(0, 4),
                                                                                spreadRadius: 1,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Form(
                                                                              // key:
                                                                              //     model.formKey,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      context.pop();
                                                                                    },
                                                                                    child: Image.asset(
                                                                                      'assets/images/Left.png',
                                                                                      color: const Color(0xff161616),
                                                                                    ),
                                                                                  ),
                                                                                  15.0.sbH,
                                                                                  const Center(
                                                                                    child: Text(
                                                                                      'Confirm Withdraw',
                                                                                      style: TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppColors.blacks,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  75.0.sbH,
                                                                                  const Center(
                                                                                    child: Text(
                                                                                      'You’re about to withdraw',
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: AppColors.foundationGreyLightActive,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 10),
                                                                                  // Center(
                                                                                  //   child: Image.asset(
                                                                                  //     widget.payCurrency['flag'],
                                                                                  //     width: 40,
                                                                                  //     height: 40,
                                                                                  //   ),
                                                                                  // ),
                                                                                  const SizedBox(height: 15),
                                                                                  Center(
                                                                                    child: Text(
                                                                                      '$withdraw $selectedCrypto4',
                                                                                      style: const TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppColors.primary,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  const SizedBox(height: 45),
                                                                                  Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColors.background,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        const SizedBox(height: 10),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Service Fee',
                                                                                              style: TextStyle(
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: AppColors.foundationGreyLightActive,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.green.shade100,
                                                                                                borderRadius: BorderRadius.circular(12),
                                                                                              ),
                                                                                              child: const Text(
                                                                                                'Zero Fees',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 13),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Recepient',
                                                                                              style: TextStyle(
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: AppColors.foundationGreyLightActive,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 190,
                                                                                              child: Text(
                                                                                                receiver,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                softWrap: true,
                                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 13),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Network',
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                            ),
                                                                                            Text(
                                                                                              selectedNetwork,
                                                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 13),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Total',
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                            ),
                                                                                            Text(
                                                                                              '$withdraw $selectedCrypto4',
                                                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 80),
                                                                                  AppButton(
                                                                                      text: 'Confirm',
                                                                                      onPressed: () {
                                                                                        if (selectedCrypto3.isNotEmpty && withdraw.isNotEmpty) {
                                                                                          model.processWithdraw(context, selectedCrypto4, withdraw, selectedNetwork, receiver);
                                                                                        } else {
                                                                                          showCustomToast(
                                                                                            'Transaction Failed',
                                                                                            toastType: ToastType.error,
                                                                                          );
                                                                                        }
                                                                                      }),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                  );
                                                                } else {
                                                                  showCustomToast(
                                                                    'Enter Crypto Amount',
                                                                    toastType: ToastType.info,
                                                                  );
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            });
                                          },
                                        );
                                      },
                                      child: _buildActionButton(
                                        'assets/images/send.png',
                                        'Send',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext
                                              context) {
                                            // final cryptoAmount =
                                            //     cryptoController
                                            //         .text;
                                            //String tempValue = "bitcoin"; // local state

                                            return BaseView<
                                                    HomeViewModel>(
                                                onModelReady:
                                                    (model) {
                                              debugPrint(
                                                  "Alladu======");
                                              model.setAppTitle(
                                                  'Add Wallet');
                                            }, builder: (context,
                                                    model,
                                                    child) {
                                              return StatefulBuilder(
                                                  builder: (context,
                                                      setStateDialog) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(
                                                          10),
                                                  decoration:
                                                      BoxDecoration(
                                                    color: AppColors
                                                        .white, // Background color
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10),
                                                    border:
                                                        const Border(
                                                      top:
                                                          BorderSide(
                                                        color: AppColors
                                                            .lightGrey, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Light shadow
                                                        blurRadius:
                                                            3,
                                                        offset:
                                                            const Offset(
                                                                0,
                                                                4),
                                                        spreadRadius:
                                                            1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(
                                                            15),
                                                    child: Form(
                                                      // key:
                                                      //     model.formKey,
                                                      child:
                                                          Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              context.pop();
                                                            },
                                                            child:
                                                                Image.asset(
                                                              'assets/images/Left.png',
                                                              color: const Color(0xff161616),
                                                            ),
                                                          ),
                                                          15.0.sbH,
                                                          const Center(
                                                            child:
                                                                Text(
                                                              'Create Wallet',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.blacks,
                                                              ),
                                                            ),
                                                          ),
                                                          75.0.sbH,
                                                          const Text(
                                                            'Select Currency',
                                                            style:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: AppColors.foundationGreyLightActive,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 3),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors.background,
                                                              borderRadius: BorderRadius.circular(30),
                                                            ),
                                                            child:
                                                                Column(
                                                              children: [
                                                                const SizedBox(height: 8),
                                                                DropdownButtonHideUnderline(
                                                                  child: DropdownButton<String>(
                                                                    isExpanded: true,
                                                                    dropdownColor: Colors.white,
                                                                    hint: const Text(
                                                                      'BTC',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: AppColors.black,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    value: model.selectedCrypto,
                                                                    icon: const Icon(
                                                                      Iconsax.arrow_down_1_bold,
                                                                      color: Color(0xff161616),
                                                                      size: 16,
                                                                    ),
                                                                    items: model.cryptos.map((coin) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: coin['id'],
                                                                        child: Text(
                                                                          coin['symbol']!,
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
                                                                      setStateDialog(() {
                                                                        // <-- use dialog's setState
                                                                        model.selectedCrypto = val!;
                                                                      });
                                                                      print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 100),
                                                          AppButton(
                                                            text:
                                                                'Create Wallet',
                                                            onPressed:
                                                                () {
                                                              if (model.selectedCrypto.isNotEmpty) {
                                                                model.processAddWallet(
                                                                  context,
                                                                );
                                                              } else {
                                                                showCustomToast(
                                                                  'Please Select Currency',
                                                                  toastType: ToastType.info,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            });
                                          },
                                        );
                                      },
                                      child: _buildActionButton(
                                        'assets/images/exchange.png',
                                        'Add Wallet',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext
                                              context) {
                                            // final cryptoAmount =
                                            //     cryptoController
                                            //         .text;
                                            //String tempValue = "bitcoin"; // local state

                                            return BaseView<
                                                    HomeViewModel>(
                                                onModelReady:
                                                    (model) {
                                              debugPrint(
                                                  "Alladu======");
                                              model.setAppTitle(
                                                  'Transfer');
                                            }, builder: (context,
                                                    model,
                                                    child) {
                                              return StatefulBuilder(
                                                  builder: (context,
                                                      setStateDialog) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(
                                                          10),
                                                  decoration:
                                                      BoxDecoration(
                                                    color: AppColors
                                                        .white, // Background color
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10),
                                                    border:
                                                        const Border(
                                                      top:
                                                          BorderSide(
                                                        color: AppColors
                                                            .lightGrey, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Light shadow
                                                        blurRadius:
                                                            3,
                                                        offset:
                                                            const Offset(
                                                                0,
                                                                4),
                                                        spreadRadius:
                                                            1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(
                                                            15),
                                                    child: Form(
                                                      // key:
                                                      //     model.formKey,
                                                      child:
                                                          Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              context.pop();
                                                            },
                                                            child:
                                                                Image.asset(
                                                              'assets/images/Left.png',
                                                              color: const Color(0xff161616),
                                                            ),
                                                          ),
                                                          15.0.sbH,
                                                          const Center(
                                                            child:
                                                                Text(
                                                              'Transfer to Trade Account',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.blacks,
                                                              ),
                                                            ),
                                                          ),
                                                          75.0.sbH,
                                                          const Text(
                                                            'Amount to Transfer',
                                                            style:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: AppColors.foundationGreyLightActive,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 9),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors.background,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child:
                                                                Column(
                                                              children: [
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: TextField(
                                                                        controller: amount,
                                                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                        ],
                                                                        style: const TextStyle(
                                                                          fontSize: 22,
                                                                          color: AppColors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                        decoration: const InputDecoration(
                                                                          hint: Text('0', style: TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600)),
                                                                          border: InputBorder.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    IntrinsicWidth(
                                                                      child: DropdownButtonHideUnderline(
                                                                        child: DropdownButton<String>(
                                                                          isExpanded: true,
                                                                          dropdownColor: Colors.white,
                                                                          hint: const Text(
                                                                            'BTC',
                                                                            style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: AppColors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          value: selectedCrypto2,
                                                                          icon: const Icon(Iconsax.arrow_down_1_bold, color: Color(0xff161616), size: 16),
                                                                          items: cryptos2.map((coin) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: coin['id'],
                                                                              child: Text(
                                                                                coin['symbol']!,
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
                                                                            setStateDialog(() {
                                                                              // <-- use dialog's setState
                                                                              selectedCrypto2 = val!;
                                                                            });
                                                                            print('after setState selectedCrypto2 = $selectedCrypto2');
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 100),
                                                          AppButton(
                                                              text: 'Transfer',
                                                              onPressed: () {
                                                                if (amount.text.isNotEmpty) {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return BaseView<HomeViewModel>(onModelReady: (model) {
                                                                        debugPrint("Alladu======");
                                                                        model.setAppTitle('Transfer');
                                                                      }, builder: (context, model, child) {
                                                                        final cryptoamount = amount.text;
                                                                        return Container(
                                                                          padding: const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                            color: AppColors.white, // Background color
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: const Border(
                                                                              top: BorderSide(
                                                                                color: AppColors.lightGrey, // Border color
                                                                                width: 1, // Border width
                                                                              ),
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.5), // Light shadow
                                                                                blurRadius: 3,
                                                                                offset: const Offset(0, 4),
                                                                                spreadRadius: 1,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Form(
                                                                              // key:
                                                                              //     model.formKey,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      context.pop();
                                                                                    },
                                                                                    child: Image.asset(
                                                                                      'assets/images/Left.png',
                                                                                      color: const Color(0xff161616),
                                                                                    ),
                                                                                  ),
                                                                                  15.0.sbH,
                                                                                  const Center(
                                                                                    child: Text(
                                                                                      'Confirm Transfer',
                                                                                      style: TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppColors.blacks,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  75.0.sbH,
                                                                                  const Center(
                                                                                    child: Text(
                                                                                      'You’re about to transfer',
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: AppColors.foundationGreyLightActive,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 10),
                                                                                  // Center(
                                                                                  //   child: Image.asset(
                                                                                  //     widget.payCurrency['flag'],
                                                                                  //     width: 40,
                                                                                  //     height: 40,
                                                                                  //   ),
                                                                                  // ),
                                                                                  const SizedBox(height: 15),
                                                                                  Center(
                                                                                    child: Text(
                                                                                      '$cryptoamount $selectedCrypto2',
                                                                                      style: const TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppColors.primary,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  const SizedBox(height: 45),
                                                                                  Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColors.background,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        const SizedBox(height: 10),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Service Fee',
                                                                                              style: TextStyle(
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: AppColors.foundationGreyLightActive,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.green.shade100,
                                                                                                borderRadius: BorderRadius.circular(12),
                                                                                              ),
                                                                                              child: const Text(
                                                                                                'Zero Fees',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 13),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'Total',
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                                            ),
                                                                                            Text(
                                                                                              '$cryptoamount $selectedCrypto2',
                                                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 100),
                                                                                  AppButton(
                                                                                      text: 'Confirm',
                                                                                      onPressed: () {
                                                                                        if (selectedCrypto2.isNotEmpty && cryptoamount.isNotEmpty) {
                                                                                          model.processTransfer(
                                                                                            context,
                                                                                            selectedCrypto2,
                                                                                            cryptoamount,
                                                                                          );
                                                                                        } else {
                                                                                          showCustomToast(
                                                                                            'Transaction Failed',
                                                                                            toastType: ToastType.error,
                                                                                          );
                                                                                        }
                                                                                      }),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                  );
                                                                } else {
                                                                  showCustomToast(
                                                                    'Enter Crypto Amount',
                                                                    toastType: ToastType.info,
                                                                  );
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            });
                                          },
                                        );
                                      },
                                      child: _buildActionButton(
                                          'assets/images/send.png',
                                          'Transfer'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 45,
                                ),
                                const Text(
                                  'Convert to Fiat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 9),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      const Align(
                                        alignment:
                                            Alignment.centerLeft,
                                        child: Text(
                                          "From Crypto",
                                          style: TextStyle(
                                              color: Color(
                                                  0xff161616),
                                              fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                                controller:
                                                    cryptoController,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal:
                                                            true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d*\.?\d*')),
                                                ],
                                                style:
                                                    const TextStyle(
                                                  fontSize: 22,
                                                  color:
                                                      AppColors
                                                          .black,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  hint: Text('0',
                                                      style: TextStyle(
                                                          fontSize:
                                                              22,
                                                          color: AppColors
                                                              .black,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  border:
                                                      InputBorder
                                                          .none,
                                                ),
                                                onChanged: (_) =>
                                                    convert()),
                                          ),
                                          IntrinsicWidth(
                                            child:
                                                DropdownButtonHideUnderline(
                                              child:
                                                  DropdownButton<
                                                      String>(
                                                isExpanded: true,
                                                dropdownColor:
                                                    Colors.white,
                                                value:
                                                    selectedCrypto,
                                                icon: const Icon(
                                                    Iconsax
                                                        .arrow_down_1_bold,
                                                    color: Color(
                                                        0xff161616),
                                                    size: 16),
                                                items: cryptos.map(
                                                    (country) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value:
                                                        country[
                                                            'id'],
                                                    child: Text(
                                                        country[
                                                            'symbol']!,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                15,
                                                            color: AppColors
                                                                .black,
                                                            fontWeight:
                                                                FontWeight.w600)),
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    (value) {
                                                  setState(() {
                                                    selectedCrypto =
                                                        value!;
                                                  });
                                                  convert();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildDivider(),
                                const SizedBox(height: 15),

                                // To Section
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 9),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      const Align(
                                        alignment:
                                            Alignment.centerLeft,
                                        child: Text(
                                            "To Fiat(USD)",
                                            style: TextStyle(
                                                color: Color(
                                                    0xff161616),
                                                fontSize: 14)),
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment:
                                            Alignment.centerLeft,
                                        child: Text(
                                          usdValue == 0.0
                                              ? "\$0.00"
                                              : "\$${usdValue.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color:
                                                AppColors.black,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: AppButton(
                                      width: 180,
                                      onPressed: () {
                                        if (cryptoController
                                            .text.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext
                                                    context) {
                                              final cryptoAmount =
                                                  cryptoController
                                                      .text;
                                              return BaseView<
                                                      HomeViewModel>(
                                                  onModelReady:
                                                      (model) {
                                                debugPrint(
                                                    "Alladu======");
                                                model.setAppTitle(
                                                    'Convert');
                                              }, builder:
                                                      (context,
                                                          model,
                                                          child) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(
                                                          15),
                                                  decoration:
                                                      BoxDecoration(
                                                    color: AppColors
                                                        .white, // Background color
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10),
                                                    border:
                                                        const Border(
                                                      top:
                                                          BorderSide(
                                                        color: AppColors
                                                            .lightGrey, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Light shadow
                                                        blurRadius:
                                                            3,
                                                        offset:
                                                            const Offset(
                                                                0,
                                                                4),
                                                        spreadRadius:
                                                            1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(
                                                            15),
                                                    child: Form(
                                                      // key:
                                                      //     model.formKey,
                                                      child:
                                                          Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              context.pop();
                                                            },
                                                            child:
                                                                Image.asset(
                                                              'assets/images/Left.png',
                                                              color: const Color(0xff161616),
                                                            ),
                                                          ),
                                                          15.0.sbH,
                                                          const Center(
                                                            child:
                                                                Text(
                                                              'Confirm Exchange',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.blacks,
                                                              ),
                                                            ),
                                                          ),
                                                          75.0.sbH,
                                                          const Center(
                                                            child:
                                                                Text(
                                                              'You’re about to convert',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColors.foundationGreyLightActive,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          // Center(
                                                          //   child: Image.asset(
                                                          //     widget.payCurrency['flag'],
                                                          //     width: 40,
                                                          //     height: 40,
                                                          //   ),
                                                          // ),
                                                          const SizedBox(
                                                              height: 15),
                                                          Center(
                                                            child:
                                                                Text(
                                                              '$cryptoAmount $selectedCrypto',
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.primary,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Center(
                                                            child:
                                                                Text(
                                                              'to \$${usdValue.toStringAsFixed(2)}',
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 45),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.all(10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors.background,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child:
                                                                Column(
                                                              children: [
                                                                const SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Service Fee',
                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.green.shade100,
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      child: const Text(
                                                                        'Zero Fees',
                                                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 13),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Total',
                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foundationGreyLightActive),
                                                                    ),
                                                                    Text(
                                                                      '$cryptoAmount $selectedCrypto',
                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 100),
                                                          AppButton(
                                                              text: 'Confirm',
                                                              onPressed: () {
                                                                if (selectedCrypto.isNotEmpty && cryptoAmount.isNotEmpty) {
                                                                  model.processConvert(context, selectedCrypto, cryptoAmount);
                                                                } else {
                                                                  showCustomToast('Transaction Failed', toastType: ToastType.error);
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          );
                                        } else {
                                          showCustomToast(
                                            'Enter Crypto Amount',
                                            toastType:
                                                ToastType.info,
                                          );
                                        }
                                      },
                                      text: 'Convert'),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Recent Transactions',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .white, // Background color
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                        border: Border.all(
                                          color: AppColors
                                              .foundationGreyLighter,
                                          width: 0.3,
                                        ),
                                      ),
                                      child: Theme(
                                        data: Theme.of(context)
                                            .copyWith(
                                          cardColor:
                                              Colors.white,
                                          dividerColor:
                                              Colors.grey,
                                        ),
                                        child: transact.isEmpty
                                            ? const Center(
                                                child: Text(
                                                    "No Transaction found"),
                                              )
                                            : DataTable(
                                                headingRowColor:
                                                    WidgetStateProperty
                                                        .all(
                                                  AppColors
                                                      .background,
                                                ),
                                                dataRowHeight:
                                                    50,
                                                columnSpacing:
                                                    75,
                                                dividerThickness:
                                                    0.1,
                                                columns: const [
                                                  DataColumn(
                                                    label: Text(
                                                      'Type',
                                                      style:
                                                          TextStyle(
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                      label:
                                                          Text(
                                                    'Asset',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label:
                                                          Text(
                                                    'Amount',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label:
                                                          Text(
                                                    'Fiat Amount',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label:
                                                          Text(
                                                    'Status',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                  )),
                                                ],
                                                rows: transact
                                                    .take(
                                                        4) // 👈 only keep 4 transactions
                                                    .map(
                                                        (members) {
                                                  Color
                                                      statusColor;
                                                  switch (members
                                                      .status
                                                      .toLowerCase()) {
                                                    case 'completed':
                                                      statusColor =
                                                          Colors
                                                              .green;
                                                      break;
                                                    case 'pending':
                                                      statusColor =
                                                          Colors
                                                              .orange;
                                                      break;
                                                    case 'failed':
                                                      statusColor =
                                                          Colors
                                                              .red;
                                                      break;
                                                    default:
                                                      statusColor =
                                                          Colors
                                                              .grey;
                                                  }

                                                  return DataRow(
                                                    cells: [
                                                      DataCell(Text(members
                                                              .type
                                                              .isNotEmpty
                                                          ? members
                                                              .type
                                                          : '-')),
                                                      DataCell(
                                                        Text(
                                                          members
                                                              .asset,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(Text(members
                                                          .amount
                                                          .toStringAsFixed(
                                                              2))),
                                                      DataCell(Text(members
                                                          .fiatAmount
                                                          .toStringAsFixed(
                                                              2))),
                                                      DataCell(
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                            horizontal:
                                                                10,
                                                            vertical:
                                                                6,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                statusColor.withOpacity(0.15),
                                                            borderRadius:
                                                                BorderRadius.circular(6),
                                                          ),
                                                          child:
                                                              Text(
                                                            members
                                                                .status,
                                                            style:
                                                                TextStyle(
                                                              color: statusColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenSize.width / 70,
                        ),
                        const Column(
                          children: [],
                        )
                      ],
                    )
            ],
          ),
        ),
      );
    });
  }

  Widget buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(thickness: 1, color: Colors.grey)),
        const SizedBox(width: 8),
        Image.asset('assets/image/exchange.png',
            width: 34, height: 34, color: AppColors.primary),
        const SizedBox(width: 8),
        const Expanded(
            child: Divider(thickness: 1, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButton(String icon, String label) {
    return Column(
      children: [
        Container(
          height: 58,
          width: 58,
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
            ),
          ),
        ),
        8.0.sbH,
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xff161616),
          ),
        ),
      ],
    );
  }
}
