import 'dart:convert';

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
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState
    extends State<TransactionsScreen> {
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var mobile = ResponsiveWidget.isSmallScreen(context);
    var desktop = ResponsiveWidget.isLargeScreen(context);

    return BaseView<HomeViewModel>(onModelReady: (model) {
      getUserDetails(model);

      loadwallets(model);
      fetchTransaction(model);
    }, builder: (context, model, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              desktop
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: CalcWidth(context, 690,
                                      maxWidth: 720),
                                  height: 155.0,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      image:
                                          const DecorationImage(
                                        image: AssetImage(
                                            'assets/image/dashboard.png'),
                                        fit: BoxFit.cover,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                      horizontal: 20,
                                      vertical: 13,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        const Text(
                                          'Main Account',
                                          style: TextStyle(
                                              color:
                                                  Colors.white,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                            height: 9),
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
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 29,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        AppButton3(
                                            onPressed: () {
                                              context.go(
                                                  '/homepage?tab=Dashboard');
                                            },
                                            width: 145,
                                            height: 35,
                                            text: "Add Funds")
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width / 70,
                                ),
                                Container(
                                    width: CalcWidth(
                                        context, 320,
                                        maxWidth: 320),
                                    height: 155.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                        border: Border.all(
                                          color: AppColors
                                              .background,
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
                                                        60,
                                                    columnSpacing:
                                                        45,
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
                                                          fontSize:
                                                              12,
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Description',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label:
                                                              Text(
                                                        'Date/Time',
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
                                                        // 👈 only keep 4 transactions
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
                                                              Text(members.description)),
                                                          DataCell(
                                                              Text(members.createdAt)),
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
                                ])
                          ],
                        ),
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 13,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Main Account',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17),
                                    ),
                                    const SizedBox(height: 9),
                                    Text(
                                      (user == null)
                                          ? '\$1.00'
                                          : NumberFormat
                                              .currency(
                                              locale:
                                                  'en_US', // US formatting style
                                              symbol:
                                                  '\$', // Currency symbol
                                            ).format(
                                              user!.fiatBalance),
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 29,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppButton3(
                                        onPressed: () {
                                          context.go(
                                              '/homepage?tab=Dashboard');
                                        },
                                        width: 145,
                                        height: 35,
                                        text: "Add Funds")
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            // const SizedBox(
                            //   height: 25,
                            // ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors
                                        .foundationGreyLighter,
                                    width: 0.3,
                                  ),
                                ),
                                child: Theme(
                                  data:
                                      Theme.of(context).copyWith(
                                    cardColor: Colors.white,
                                    dividerColor: Colors.grey,
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
                                            AppColors.background,
                                          ),
                                          dataRowHeight: 60,
                                          columnSpacing: 45,
                                          dividerThickness: 0.1,
                                          columns: const [
                                            DataColumn(
                                              label: Text(
                                                'Type',
                                                style: TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                                label: Text(
                                              'Asset',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Amount',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Fiat Amount',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                                fontSize: 12,
                                              ),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Description',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Date/Time',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Status',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            )),
                                          ],
                                          rows: transact
                                              // 👈 only keep 4 transactions
                                              .map((members) {
                                            Color statusColor;
                                            switch (members
                                                .status
                                                .toLowerCase()) {
                                              case 'completed':
                                                statusColor =
                                                    Colors.green;
                                                break;
                                              case 'pending':
                                                statusColor =
                                                    Colors
                                                        .orange;
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
                                                          FontWeight
                                                              .w600,
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
                                                DataCell(Text(members
                                                    .description)),
                                                DataCell(Text(members
                                                    .createdAt)),
                                                DataCell(
                                                  Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal:
                                                          10,
                                                      vertical:
                                                          6,
                                                    ),
                                                    decoration:
                                                        BoxDecoration(
                                                      color: statusColor
                                                          .withOpacity(
                                                              0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Text(
                                                      members
                                                          .status,
                                                      style:
                                                          TextStyle(
                                                        color:
                                                            statusColor,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
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
                        )
                      ],
                    ),
            ],
          ),
        ),
      );
    });
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
