import 'dart:convert';

import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/data/model/wallet_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

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

  double usdValue = 0.0;

  String selectedCrypto = "bitcoin"; // default
  final List<Map<String, String>> cryptos = [
    {"id": "bitcoin", "symbol": "BTC"},
    {"id": "ethereum", "symbol": "ETH"},
    {"id": "tether", "symbol": "USDT"},
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
    cryptoController
        .addListener(convert); // auto-update on typing
  }

  @override
  void dispose() {
    cryptoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var mobile = ResponsiveWidget.isSmallScreen(context);
    var desktop = ResponsiveWidget.isLargeScreen(context);

    return BaseView<HomeViewModel>(onModelReady: (model) {
      getUserDetails(model);

      loadwallets(model);
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
                                        fontSize: 26,
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
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
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
                                                : '\$${user!.fiatBalance.toStringAsFixed(2)}',
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  const Text(
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
                                                  const SizedBox(
                                                      height: 9),
                                                  const Text(
                                                    'Create Wallet', // 👈 dynamic currency name (BTC, ETH, USDT...)
                                                    style:
                                                        TextStyle(
                                                      color: Colors
                                                          .grey,
                                                      fontSize:
                                                          14,
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
                                                          0.001, // 👉 you can replace with wallet.fiatBalance if needed
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
                                          ),
                                        ]),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: CalcWidth(
                                          context, 690,
                                          maxWidth: 720),
                                      height: 255.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                          border: Border.all(
                                            color: AppColors
                                                .foundationGreyLighter,
                                            width: 0.3,
                                          )),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Recent Transactions',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    Colors.black,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
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
                                        GestureDetector(
                                            onTap: () {},
                                            child: _buildActionButton(
                                                'assets/images/payment.png',
                                                'Receive')),
                                        GestureDetector(
                                          onTap: () {},
                                          child:
                                              _buildActionButton(
                                            'assets/images/send.png',
                                            'Send',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child:
                                              _buildActionButton(
                                            'assets/images/exchange.png',
                                            'Convert',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
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
                                                            .arrow_down_1,
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
                                          onPressed: () {},
                                          text: 'Convert'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 53,
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
                            SizedBox(
                              width: CalcWidth(context, 690,
                                  maxWidth: 720),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: CalcWidth(
                                          context, 690,
                                          maxWidth: 720),
                                      height: 255.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                          border: Border.all(
                                            color: AppColors
                                                .foundationGreyLighter,
                                            width: 0.3,
                                          )),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Recent Transactions',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    Colors.black,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
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
