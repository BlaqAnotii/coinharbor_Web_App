import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // late ScrollController controller;
  // @override
  // void initState() {
  //   controller = ScrollController();

  //   controller.addListener(() {
  //     context.read<DisplayOffset>().changeDisplayOffset(
  //         (MediaQuery.of(context).size.height + controller.position.pixels)
  //             .toInt());
  //   });
  //   super.initState();
  // }

  List<dynamic> _coins = [];
  List<dynamic> _pairs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
    fetchTradingPairs();

    // Refresh every 10 seconds
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   fetchCryptoData();

    //   fetchTradingPairs();
    // });
  }

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

  Future<void> fetchTradingPairs() async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/exchanges/binance/tickers');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // take just the first 10 tickers
      setState(() {
        _pairs = (data['tickers'] as List).take(5).toList();
        _loading = false;
      });
    } else {
      throw Exception('Failed to load trading pairs');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 90,
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 630,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading:
              ResponsiveWidget.isSmallScreen(context)
                  ? true
                  : false, // 👈 This hides the back button
          leading: ResponsiveWidget.isSmallScreen(context)
              ? Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Image.asset(
                      'assets/image/sort.png',
                      height: 10,
                      width: 10,
                      scale: 16,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                )
              : null,
          elevation: 0,
          centerTitle: true,
          title: ResponsiveWidget.isSmallScreen(context)
              ? InkWell(
                  onTap: () {
                    //  context.go('/home');
                  },
                  child: Image.asset(
                    'assets/image/logo.png',
                    scale: 7,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: screenSize.width / 70),
                      InkWell(
                        onTap: () {
                          //  context.go('/home');
                        },
                        child: Image.asset(
                          'assets/image/logo.png',
                          scale: 7,
                        ),
                      ),

                      // const Text(
                      //   'Solevad Energy',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w500,
                      //     letterSpacing: 3,
                      //   ),
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: screenSize.width / 12),
                            InkWell(
                              onTap: () {
                                context.go('/home');
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w500,
                                      fontSize:
                                          screenSize.width *
                                              0.012,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: screenSize.width / 20),
                            InkWell(
                              onTap: () {
                                //  context.go('/about-us');
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'About',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w500,
                                      fontSize:
                                          screenSize.width *
                                              0.012,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: screenSize.width / 20),
                            InkWell(
                              onTap: () {
                                //  context.go('/contact_us');
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Contact Us',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w500,
                                      fontSize:
                                          screenSize.width *
                                              0.012,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.brightness_6),
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   color: Colors.white,
                      //   onPressed: () {
                      //     EasyDynamicTheme.of(context).changeTheme();
                      //   },
                      // ),
                      SizedBox(width: screenSize.width / 10),
                      AppOutlineButton(
                        height: 45,
                        width: 120,
                        onPressed: () {},
                        text: 'Login',
                      ),
                      SizedBox(width: screenSize.width / 90),

                      AppButton(
                        height: 45,
                        width: 120,
                        onPressed: () {},
                        text: 'Sign Up',
                        bg: AppColors.foundationPurpleNormal,
                      ),
                      SizedBox(
                        width: screenSize.width / 50,
                      ),
                    ],
                  ),
                ),
          flexibleSpace: const FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [FirstSection()],
            ),
          ),
        ),

        // Sliver content section
        SliverToBoxAdapter(
          child: Padding(
            padding: ResponsiveWidget.isSmallScreen(context)
                ? const EdgeInsets.symmetric(
                    horizontal: 20,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: 100,
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ResponsiveWidget.isSmallScreen(context)
                    ? Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              'Market Trends',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _loading
                                ? buildSkeleton()
                                : SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.all(
                                              10),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xffffffff),
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                      ),
                                      child: DataTable(
                                        dataRowHeight: 66,
                                        columnSpacing: 55,
                                        dividerThickness: 0.1,
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              "Name",
                                            ),
                                          ),
                                          DataColumn(
                                              label: Text(
                                                  "Price (USD)")),
                                          DataColumn(
                                              label: Text(
                                                  "24h Change %")),
                                          DataColumn(
                                              label: Text(
                                                  "Market Cap")),
                                        ],
                                        rows: _coins.map((coin) {
                                          return DataRow(cells: [
                                            DataCell(Row(
                                              children: [
                                                Image.network(
                                                  coin['image'],
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                const SizedBox(
                                                    width: 8),
                                                Text(
                                                  coin['name'],
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .blacks,
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                      fontSize:
                                                          15),
                                                ),
                                              ],
                                            )),
                                            DataCell(Text(
                                              "\$${coin['current_price']}",
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .foundationGreyLightActive,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 15),
                                            )),
                                            DataCell(Text(
                                              "${coin['price_change_percentage_24h'].toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                color:
                                                    coin['price_change_percentage_24h'] >=
                                                            0
                                                        ? Colors
                                                            .green
                                                        : Colors
                                                            .red,
                                              ),
                                            )),
                                            DataCell(Text(
                                              "\$${coin['market_cap']}",
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .foundationPurpleNormal,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 15),
                                            )),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              'Trading Pairs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _loading
                                ? buildSkeleton()
                                : SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.all(
                                              10),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xffffffff),
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),
                                      ),
                                      child: DataTable(
                                        dataRowHeight: 66,
                                        columnSpacing: 55,
                                        dividerThickness: 0.1,
                                        columns: const [
                                          DataColumn(
                                              label:
                                                  Text("Pair")),
                                          DataColumn(
                                              label: Text(
                                                  "Last Price")),
                                          DataColumn(
                                              label: Text(
                                                  "Volume")),
                                        ],
                                        rows: _pairs.map((pair) {
                                          return DataRow(cells: [
                                            DataCell(
                                              Text(
                                                "${pair['base']}/${pair['target']}",
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .blacks,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                    fontSize:
                                                        15),
                                              ),
                                            ),
                                            DataCell(Text(
                                                "\$${pair['last']}")),
                                            DataCell(Text(
                                              pair['volume']
                                                  .toStringAsFixed(
                                                      2),
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .foundationPurpleNormal,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 15),
                                            )),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 50,
                            ),
                          ])
                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                const Text(
                                  'Market Trends',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                _loading
                                    ? buildSkeleton()
                                    : Container(
                                        padding:
                                            const EdgeInsets.all(
                                                10),
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                              0xffffffff),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                        ),
                                        child:
                                            SingleChildScrollView(
                                          scrollDirection: Axis
                                              .horizontal, // allow table to scroll
                                          child: DataTable(
                                            dataRowHeight: 66,
                                            columnSpacing: 55,
                                            dividerThickness:
                                                0.1,
                                            columns: const [
                                              DataColumn(
                                                label: Text(
                                                  "Name",
                                                ),
                                              ),
                                              DataColumn(
                                                  label: Text(
                                                      "Price (USD)")),
                                              DataColumn(
                                                  label: Text(
                                                      "24h Change %")),
                                              DataColumn(
                                                  label: Text(
                                                      "Market Cap")),
                                            ],
                                            rows: _coins
                                                .map((coin) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(Row(
                                                      children: [
                                                        Image
                                                            .network(
                                                          coin[
                                                              'image'],
                                                          height:
                                                              30,
                                                          width:
                                                              30,
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                                8),
                                                        Text(
                                                          coin[
                                                              'name'],
                                                          style: const TextStyle(
                                                              color: AppColors.blacks,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    )),
                                                    DataCell(
                                                        Text(
                                                      "\$${coin['current_price']}",
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .foundationGreyLightActive,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize:
                                                              15),
                                                    )),
                                                    DataCell(
                                                        Text(
                                                      "${coin['price_change_percentage_24h'].toStringAsFixed(2)}%",
                                                      style:
                                                          TextStyle(
                                                        color: coin['price_change_percentage_24h'] >=
                                                                0
                                                            ? Colors
                                                                .green
                                                            : Colors
                                                                .red,
                                                      ),
                                                    )),
                                                    DataCell(
                                                        Text(
                                                      "\$${coin['market_cap']}",
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .foundationPurpleNormal,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize:
                                                              15),
                                                    )),
                                                  ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ]),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                'Trading Pairs',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _loading
                                  ? buildSkeleton()
                                  : SingleChildScrollView(
                                      scrollDirection:
                                          Axis.horizontal,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(
                                                10),
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                              0xffffffff),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                        ),
                                        child:
                                            SingleChildScrollView(
                                          scrollDirection:
                                              Axis.horizontal,
                                          child: DataTable(
                                            dataRowHeight: 66,
                                            columnSpacing: 55,
                                            dividerThickness:
                                                0.1,
                                            columns: const [
                                              DataColumn(
                                                  label: Text(
                                                      "Pair")),
                                              DataColumn(
                                                  label: Text(
                                                      "Last Price")),
                                              DataColumn(
                                                  label: Text(
                                                      "Volume")),
                                            ],
                                            rows: _pairs
                                                .map((pair) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                        "${pair['base']}/${pair['target']}",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .blacks,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontSize:
                                                                15),
                                                      ),
                                                    ),
                                                    DataCell(Text(
                                                        "\$${pair['last']}")),
                                                    DataCell(
                                                        Text(
                                                      pair['volume']
                                                          .toStringAsFixed(
                                                              2),
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .foundationPurpleNormal,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize:
                                                              15),
                                                    )),
                                                  ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          )
                        ],
                      ),
                ResponsiveWidget.isSmallScreen(context)
                    ? const Column(
                        children: [
                          AppButton(
                            text: 'Get Started ',
                            width: 230,
                            height: 55,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Sign up now to create your own portfolio for free!",
                            style: TextStyle(
                                color: AppColors.blacks,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: Row(
                          children: [
                            AppButton(
                              text: 'Get Started ',
                              width: 230,
                              height: 55,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Sign up now to create your own portfolio for free!",
                              style: TextStyle(
                                  color: AppColors.blacks,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 100,
                ),
                ResponsiveWidget.isSmallScreen(context)
                    ? const Text(
                        'Get Started in 30 Seconds!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: Text(
                          'Get Started in 30 Seconds!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                ResponsiveWidget.isSmallScreen(context)
                    ? Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 400.h,
                            width: 340.w,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Light shadow
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                // Step number top-left
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    child: const Text(
                                      '1',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Icon
                                Image.asset(
                                  'assets/image/email.png',
                                  width: 55,
                                  height: 55,
                                ),
                                const SizedBox(height: 16),
                                // Title
                                const Text(
                                  'Create account',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                // Description
                                const Text(
                                  'Get started in just a few minutes by signing up with your email or mobile number. Your journey to smarter crypto trading begins here.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Button
                                const AppButton(
                                  text: 'Sign Up',
                                  height: 45,
                                  width: 190,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 400.h,
                            width: 340.w,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Light shadow
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                // Step number top-left
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    child: const Text(
                                      '2',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Icon
                                Image.asset(
                                  'assets/image/customer.png',
                                  width: 55,
                                  height: 55,
                                ),
                                const SizedBox(height: 16),
                                // Title
                                const Text(
                                  'Verify KYC',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                // Description
                                const Text(
                                  'Complete a quick identity verification to unlock full access. This ensures a safe and compliant platform for all users.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Button
                                const AppButton(
                                  text: 'Verify',
                                  height: 45,
                                  width: 190,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 400.h,
                            width: 340.w,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Light shadow
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                // Step number top-left
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    child: const Text(
                                      '3',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Icon
                                Image.asset(
                                  'assets/image/wallet.png',
                                  width: 55,
                                  height: 55,
                                ),
                                const SizedBox(height: 16),
                                // Title
                                const Text(
                                  'Fund Wallet',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                // Description
                                const Text(
                                  'Easily deposit crypto or local currency into your wallet. We support multiple payment methods so you can start without hassle.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Button
                                const AppButton(
                                  text: 'Sign Up',
                                  height: 45,
                                  width: 190,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 400.h,
                            width: 340.w,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Light shadow
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                // Step number top-left
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    child: const Text(
                                      '4',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Icon
                                Image.asset(
                                  'assets/image/candle.png',
                                  width: 55,
                                  height: 55,
                                ),
                                const SizedBox(height: 16),
                                // Title
                                const Text(
                                  'Copy Trade & Invest',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                // Description
                                const Text(
                                  'Buy and sell coins instantly, follow top traders with copy trading, or grow your holdings through staking and investment products.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Button
                                const AppButton(
                                  text: 'Sign Up',
                                  height: 45,
                                  width: 190,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 400.h,
                                  width: 80.w,
                                  padding:
                                      const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .white, // Background color
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(
                                                0.5), // Light shadow
                                        blurRadius: 3,
                                        offset:
                                            const Offset(0, 3),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                      children: [
                                        // Step number top-left
                                        Align(
                                          alignment:
                                              Alignment.topLeft,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade200,
                                            child: const Text(
                                              '1',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: Colors
                                                    .black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Icon
                                        Image.asset(
                                          'assets/image/email.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Title
                                        const Text(
                                          'Create account',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight
                                                      .bold),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        // Description
                                        const Text(
                                          'Get started in just a few minutes by signing up with your email or mobile number. Your journey to smarter crypto trading begins here.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black54),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 20),
                                        // Button
                                        const AppButton(
                                          text: 'Sign Up',
                                          height: 45,
                                          width: 190,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 400.h,
                                  width: 80.w,
                                  padding:
                                      const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .white, // Background color
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(
                                                0.5), // Light shadow
                                        blurRadius: 3,
                                        offset:
                                            const Offset(0, 4),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                      children: [
                                        // Step number top-left
                                        Align(
                                          alignment:
                                              Alignment.topLeft,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade200,
                                            child: const Text(
                                              '2',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: Colors
                                                    .black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Icon
                                        Image.asset(
                                          'assets/image/customer.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Title
                                        const Text(
                                          'Verify KYC',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight
                                                      .bold),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        // Description
                                        const Text(
                                          'Complete a quick identity verification to unlock full access. This ensures a safe and compliant platform for all users.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black54),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 20),
                                        // Button
                                        const AppButton(
                                          text: 'Verify',
                                          height: 45,
                                          width: 190,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 400.h,
                                  width: 80.w,
                                  padding:
                                      const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .white, // Background color
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(
                                                0.5), // Light shadow
                                        blurRadius: 3,
                                        offset:
                                            const Offset(0, 4),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                      children: [
                                        // Step number top-left
                                        Align(
                                          alignment:
                                              Alignment.topLeft,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade200,
                                            child: const Text(
                                              '3',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: Colors
                                                    .black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Icon
                                        Image.asset(
                                          'assets/image/wallet.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Title
                                        const Text(
                                          'Fund Wallet',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight
                                                      .bold),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        // Description
                                        const Text(
                                          'Easily deposit crypto or local currency into your wallet. We support multiple payment methods so you can start without hassle.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black54),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 20),
                                        // Button
                                        const AppButton(
                                          text: 'Sign Up',
                                          height: 45,
                                          width: 190,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 400.h,
                                  width: 80.w,
                                  padding:
                                      const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .white, // Background color
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(
                                                0.5), // Light shadow
                                        blurRadius: 3,
                                        offset:
                                            const Offset(0, 4),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                      children: [
                                        // Step number top-left
                                        Align(
                                          alignment:
                                              Alignment.topLeft,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                Colors.grey
                                                    .shade200,
                                            child: const Text(
                                              '4',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: Colors
                                                    .black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Icon
                                        Image.asset(
                                          'assets/image/candle.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        // Title
                                        const Text(
                                          'Copy Trade & Invest',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight
                                                      .bold),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        // Description
                                        const Text(
                                          'Buy and sell coins instantly, follow top traders with copy trading, or grow your holdings through staking and investment products.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black54),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 20),
                                        // Button
                                        const AppButton(
                                          text: 'Sign Up',
                                          height: 45,
                                          width: 190,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildSkeleton() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FirstSection extends StatefulWidget {
  const FirstSection({super.key});

  @override
  State<FirstSection> createState() => _FirstSectionState();
}

class _FirstSectionState extends State<FirstSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> textRevealAnimation;
  late Animation<double> textOpacityAnimation;
  late Animation<double> descriptionAnimation;
  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1700,
      ),
      reverseDuration: const Duration(
        milliseconds: 375,
      ),
    );

    textRevealAnimation = Tween<double>(begin: 60.0, end: 0.0)
        .animate(CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.2,
                curve: Curves.easeOut)));

    textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.3,
                curve: Curves.easeOut)));
    Future.delayed(const Duration(milliseconds: 1000), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

  final List<String> imageList = [
    'assets/image/hero3.jpg',
    'assets/image/hero2.jpg',
    'assets/image/hero1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return ResponsiveWidget.isSmallScreen(context)
        ? SizedBox(
            height: 700,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: imageList.length,
                  itemBuilder: (context, index, realIndex) {
                    // final item = carouselItems[index];
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageList[index]),
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.black54,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 500,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(seconds: 2),
                    onPageChanged: (index, reason) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                ),
                Positioned(
                  left: 50,
                  top: 150,
                  right: 50,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0),
                          constraints: const BoxConstraints(
                              maxWidth: 950),
                          child: const Text(
                            'Trade, Invest & Earn All in One Crypto Wallet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0),
                          constraints: const BoxConstraints(
                              maxWidth:
                                  1000), // Constrain width for better block layout
                          child: Text(
                            'Secure trading, automated copy trading, and high-yield investments.',
                            textAlign: TextAlign
                                .justify, // This aligns both edges
                            style: TextStyle(
                              fontSize: screenSize.width *
                                  0.038, // Adjusted for readability
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppOutlineButton(
                        height: 45,
                        width: 210,
                        onPressed: () {},
                        text: 'Login',
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        height: 45,
                        width: 210,
                        onPressed: () {},
                        text: 'Sign Up',
                        bg: AppColors.foundationPurpleNormal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 700,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: imageList.length,
                  itemBuilder: (context, index, realIndex) {
                    // final item = carouselItems[index];
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageList[index]),
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.black54,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      // child: Padding(
                      //   padding: const EdgeInsets.only(left: 90, top: 130, right: 50),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         item['title']!,
                      //         style: const TextStyle(
                      //           fontSize: 45,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w800,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 20),
                      //       Text(
                      //         item['subtitle']!,
                      //         style: const TextStyle(
                      //           fontSize: 18,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 40),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           context.go('/contact_us');
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           fixedSize: const Size(170, 45),
                      //           backgroundColor: Colors.white,
                      //         ),
                      //         child: const Text(
                      //           'Learn more',
                      //           style: TextStyle(
                      //             fontSize: 13,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    );
                  },
                  options: CarouselOptions(
                    height: 700,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                ),

                // Static Text on top
                Positioned(
                  left: 60,
                  top: 190,
                  right: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0),
                        constraints:
                            const BoxConstraints(maxWidth: 1000),
                        child: const Text(
                          'Trade, Invest & Earn\nAll in One Crypto Wallet',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0),
                        constraints: const BoxConstraints(
                            maxWidth:
                                1000), // Constrain width for better block layout
                        child: Text(
                          'Secure trading, automated copy trading,\nand high-yield investments.',
                          textAlign: TextAlign
                              .justify, // This aligns both edges
                          style: TextStyle(
                            fontSize: screenSize.width *
                                0.018, // Adjusted for readability
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          AppOutlineButton(
                            height: 45,
                            width: 190,
                            onPressed: () {},
                            text: 'Login',
                          ),
                          SizedBox(width: screenSize.width / 90),
                          AppButton(
                            height: 45,
                            width: 190,
                            onPressed: () {},
                            text: 'Sign Up',
                            bg: AppColors.foundationPurpleNormal,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
