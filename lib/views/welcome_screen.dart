import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final List<Map<String, String>> testimonials = [
    {
      "name": "Elena D.",
      "role": "New Investor",
      "quote":
          "As a beginner, I didn’t know where to start. Following experienced traders taught me strategies and grew my account without stress.",
    },
    {
      "name": "Mark J.",
      "role": "Daily User",
      "quote":
          "I’ve tried other apps, but this one feels the most secure. Deposits and withdrawals are fast, and I can track everything easily.",
    },
    {
      "name": "Victor S.",
      "role": "Long-Term Holder",
      "quote":
          "I locked my ETH for 90 days and earned steady rewards. The APY was exactly as promised—transparent and trustworthy.",
    },
    {
      "name": "Rachel P.",
      "role": "Day Trader",
      "quote":
          "Most apps made fiat complicated, but here I can fund with my bank card in minutes. Makes crypto way more accessible.",
    },
    {
      "name": "Daniel K.",
      "role": "Business Owner",
      "quote":
          "I use the wallet to accept payments from customers worldwide. Simple setup, and it integrates perfectly with our operations.",
    },
    {
      "name": "Fatima H.",
      "role": "Passive Investor",
      "quote":
          "I put part of my USDT into mid-term staking, and the interest pays for my monthly bills. Reliable and stress-free.",
    },
  ];

  final List<String> trustBadges = [
    "KYC/AML Compliant",
    "Bank-Grade Security",
    "Audited Smart Contracts",
    "10,000+ Users Worldwide",
    "Trusted Payment Providers",
  ];

  final List<Map<String, dynamic>> investments = [
    {
      "title": "BTC Flexible Staking",
      "coin": "BTC",
      "apy": "50%",
      "duration": 30,
      "min": "0.001",
      "max": "1",
    },
    {
      "title": "ETH Flexible Staking",
      "coin": "ETH",
      "apy": "50%",
      "duration": 30,
      "min": "0.01",
      "max": "10",
    },
    {
      "title": "USDT Stable Staking",
      "coin": "USDT",
      "apy": "50",
      "duration": 30,
      "min": "500",
      "max": "10,000",
    },
    {
      "title": "BTC Mid-Term Staking",
      "coin": "BTC",
      "apy": "100%",
      "duration": 90,
      "min": "0.01",
      "max": "2",
    },
    {
      "title": "ETH Mid-Term Staking",
      "coin": "ETH",
      "apy": "100%",
      "duration": 90,
      "min": "0.1",
      "max": "20",
    },
    {
      "title": "USDT Mid-Term Staking",
      "coin": "USDT",
      "apy": "100%",
      "duration": 90,
      "min": "5000",
      "max": "20,000",
    },
    {
      "title": "BTC Long-Term Staking",
      "coin": "BTC",
      "apy": "150%",
      "duration": 180,
      "min": "0.05",
      "max": "5",
    },
    {
      "title": "ETH Long-Term Staking",
      "coin": "ETH",
      "apy": "150%",
      "duration": 180,
      "min": "0.5",
      "max": "50",
    },
    {
      "title": "USDT Long-Term Staking",
      "coin": "USDT",
      "apy": "150%",
      "duration": 180,
      "min": "10,000",
      "max": "50,000",
    },
    {
      "title": "High Yield Altcoin (ADA)",
      "coin": "ADA",
      "apy": "50% 🚀",
      "duration": 60,
      "min": "500 ",
      "max": "5,000",
    },
  ];

  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
    fetchTradingPairs();
    _startAutoScroll();

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

  // Example partner logos (replace with your own asset paths or network images)
  final List<String> partners = [
    "assets/image/binance.png",
    "assets/image/paypal.png",
    "assets/image/card.png",
    "assets/image/visa1.png",
  ];

  void _startAutoScroll() {
    const duration = Duration(milliseconds: 30);
    _timer = Timer.periodic(duration, (timer) {
      if (_scrollController.hasClients) {
        final maxScroll =
            _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;

        if (current >= maxScroll) {
          _scrollController
              .jumpTo(0); // reset to start instantly
        } else {
          _scrollController.animateTo(
            current + 3, // move a few pixels
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    _scrollController.dispose();
    super.dispose();
  }

  final featuresKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final isSmallScreen =
        ResponsiveWidget.isSmallScreen(context);

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
                                scrollToSection(featuresKey);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Product & Services',
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
                                scrollToSection(contactKey);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
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
              Padding(
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
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              BoxDecoration(
                                            color: const Color(
                                                0xffffffff),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        10),
                                          ),
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
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              BoxDecoration(
                                            color: const Color(
                                                0xffffffff),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        10),
                                          ),
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
                                      textAlign:
                                          TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    _loading
                                        ? buildSkeleton()
                                        : Container(
                                            padding:
                                                const EdgeInsets
                                                    .all(10),
                                            decoration:
                                                BoxDecoration(
                                              color: const Color(
                                                  0xffffffff),
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          10),
                                            ),
                                            child:
                                                SingleChildScrollView(
                                              scrollDirection: Axis
                                                  .horizontal, // allow table to scroll
                                              child: DataTable(
                                                dataRowHeight:
                                                    66,
                                                columnSpacing:
                                                    55,
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
                                                        DataCell(
                                                            Row(
                                                          children: [
                                                            Image
                                                                .network(
                                                              coin['image'],
                                                              height: 30,
                                                              width: 30,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              coin['name'],
                                                              style: const TextStyle(color: AppColors.blacks, fontWeight: FontWeight.w600, fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                        DataCell(
                                                            Text(
                                                          "\$${coin['current_price']}",
                                                          style: const TextStyle(
                                                              color: AppColors.foundationGreyLightActive,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15),
                                                        )),
                                                        DataCell(
                                                            Text(
                                                          "${coin['price_change_percentage_24h'].toStringAsFixed(2)}%",
                                                          style:
                                                              TextStyle(
                                                            color: coin['price_change_percentage_24h'] >= 0
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        )),
                                                        DataCell(
                                                            Text(
                                                          "\$${coin['market_cap']}",
                                                          style: const TextStyle(
                                                              color: AppColors.foundationPurpleNormal,
                                                              fontWeight: FontWeight.w500,
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
                                      fontWeight:
                                          FontWeight.w800,
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
                                                const EdgeInsets
                                                    .all(10),
                                            decoration:
                                                BoxDecoration(
                                              color: const Color(
                                                  0xffffffff),
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          10),
                                            ),
                                            child:
                                                SingleChildScrollView(
                                              scrollDirection:
                                                  Axis.horizontal,
                                              child: DataTable(
                                                dataRowHeight:
                                                    66,
                                                columnSpacing:
                                                    55,
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
                                                                color: AppColors.blacks,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        DataCell(
                                                            Text(
                                                                "\$${pair['last']}")),
                                                        DataCell(
                                                            Text(
                                                          pair['volume']
                                                              .toStringAsFixed(2),
                                                          style: const TextStyle(
                                                              color: AppColors.foundationPurpleNormal,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15),
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
                                      fontWeight:
                                          FontWeight.w600,
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
                                padding:
                                    const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color
                                  borderRadius:
                                      BorderRadius.circular(10),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(
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
                                      alignment:
                                          Alignment.topLeft,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.grey.shade200,
                                        child: const Text(
                                          '1',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color:
                                                Colors.black87,
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
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Description
                                    const Text(
                                      'Get started in just a few minutes by signing up with your email or mobile number. Your journey to smarter crypto trading begins here.',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54),
                                      textAlign:
                                          TextAlign.center,
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
                                padding:
                                    const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color
                                  borderRadius:
                                      BorderRadius.circular(10),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(
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
                                      alignment:
                                          Alignment.topLeft,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.grey.shade200,
                                        child: const Text(
                                          '2',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color:
                                                Colors.black87,
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
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Description
                                    const Text(
                                      'Complete a quick identity verification to unlock full access. This ensures a safe and compliant platform for all users.',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54),
                                      textAlign:
                                          TextAlign.center,
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
                                padding:
                                    const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color
                                  borderRadius:
                                      BorderRadius.circular(10),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(
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
                                      alignment:
                                          Alignment.topLeft,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.grey.shade200,
                                        child: const Text(
                                          '3',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color:
                                                Colors.black87,
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
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Description
                                    const Text(
                                      'Easily deposit crypto or local currency into your wallet. We support multiple payment methods so you can start without hassle.',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54),
                                      textAlign:
                                          TextAlign.center,
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
                                padding:
                                    const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color
                                  borderRadius:
                                      BorderRadius.circular(10),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(
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
                                      alignment:
                                          Alignment.topLeft,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.grey.shade200,
                                        child: const Text(
                                          '4',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color:
                                                Colors.black87,
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
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Description
                                    const Text(
                                      'Buy and sell coins instantly, follow top traders with copy trading, or grow your holdings through staking and investment products.',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54),
                                      textAlign:
                                          TextAlign.center,
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
                                          const EdgeInsets.all(
                                              15),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .white, // Background color
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(
                                                    0.5), // Light shadow
                                            blurRadius: 3,
                                            offset: const Offset(
                                                0, 3),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child:
                                          SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                          children: [
                                            // Step number top-left
                                            Align(
                                              alignment:
                                                  Alignment
                                                      .topLeft,
                                              child:
                                                  CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    Colors.grey
                                                        .shade200,
                                                child:
                                                    const Text(
                                                  '1',
                                                  style:
                                                      TextStyle(
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
                                                  TextAlign
                                                      .center,
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
                                                  TextAlign
                                                      .center,
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
                                          const EdgeInsets.all(
                                              15),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .white, // Background color
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(
                                                    0.5), // Light shadow
                                            blurRadius: 3,
                                            offset: const Offset(
                                                0, 4),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child:
                                          SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                          children: [
                                            // Step number top-left
                                            Align(
                                              alignment:
                                                  Alignment
                                                      .topLeft,
                                              child:
                                                  CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    Colors.grey
                                                        .shade200,
                                                child:
                                                    const Text(
                                                  '2',
                                                  style:
                                                      TextStyle(
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
                                                  TextAlign
                                                      .center,
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
                                                  TextAlign
                                                      .center,
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
                                          const EdgeInsets.all(
                                              15),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .white, // Background color
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(
                                                    0.5), // Light shadow
                                            blurRadius: 3,
                                            offset: const Offset(
                                                0, 4),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child:
                                          SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                          children: [
                                            // Step number top-left
                                            Align(
                                              alignment:
                                                  Alignment
                                                      .topLeft,
                                              child:
                                                  CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    Colors.grey
                                                        .shade200,
                                                child:
                                                    const Text(
                                                  '3',
                                                  style:
                                                      TextStyle(
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
                                                  TextAlign
                                                      .center,
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
                                                  TextAlign
                                                      .center,
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
                                          const EdgeInsets.all(
                                              15),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .white, // Background color
                                        borderRadius:
                                            BorderRadius
                                                .circular(10),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(
                                                    0.5), // Light shadow
                                            blurRadius: 3,
                                            offset: const Offset(
                                                0, 4),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child:
                                          SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                          children: [
                                            // Step number top-left
                                            Align(
                                              alignment:
                                                  Alignment
                                                      .topLeft,
                                              child:
                                                  CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    Colors.grey
                                                        .shade200,
                                                child:
                                                    const Text(
                                                  '4',
                                                  style:
                                                      TextStyle(
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
                                                  TextAlign
                                                      .center,
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
                                                  TextAlign
                                                      .center,
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
                    const SizedBox(
                      height: 100,
                    ),
                    ResponsiveWidget.isSmallScreen(context)
                        ? Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // LEFT SIDE
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Copy Experts. Trade Smarter",
                                    style: TextStyle(
                                      fontSize:
                                          24, // slightly smaller for mobile
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Follow experienced traders, mirror their moves, and grow your portfolio effortlessly.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Buttons

                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      DownloadButton(
                                          label:
                                              "Browse top traders",
                                          icon: Icons.person),
                                      DownloadButton(
                                          label:
                                              "Set amount to copy",
                                          icon: Icons
                                              .currency_bitcoin),
                                      DownloadButton(
                                          label:
                                              "Auto-mirror their trades",
                                          icon: Icons.bar_chart),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  AppButton(
                                    text: 'Start Copy Trading',
                                    height: 45,
                                    width: 290,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // RIGHT SIDE (image)
                              Container(
                                key: featuresKey,
                                height: 220,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    top: 20),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image/tradepc.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // LEFT SIDE
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Copy Experts. Trade Smarter",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Follow experienced traders, mirror their moves, and grow your portfolio effortlessly.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    // Buttons row

                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: [
                                        DownloadButton(
                                            label:
                                                "Browse top traders",
                                            icon: Icons.person),
                                        DownloadButton(
                                            label:
                                                "Set amount to copy",
                                            icon: Icons
                                                .currency_bitcoin),
                                        DownloadButton(
                                            label:
                                                "Auto-mirror their trades",
                                            icon:
                                                Icons.bar_chart),
                                      ],
                                    ),

                                    SizedBox(height: 24),
                                    AppButton(
                                      text: 'Start Copy Trading',
                                      height: 45,
                                      width: 290,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 40),

                              // RIGHT SIDE (images mockup)
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment:
                                      Alignment.centerRight,
                                  child: Stack(
                                    children: [
                                      // Desktop image
                                      Container(
                                        key: featuresKey,
                                        height: 300,
                                        width: 650,
                                        decoration:
                                            BoxDecoration(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                          image:
                                              const DecorationImage(
                                            image: AssetImage(
                                                'assets/image/tradepc.jpg'),
                                            fit: BoxFit.cover,
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
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        // Section Title
                        const Text(
                          "Trusted by Thousands of Investors Worldwide",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Testimonials Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount =
                                constraints.maxWidth > 1000
                                    ? 3
                                    : constraints.maxWidth > 600
                                        ? 2
                                        : 1;

                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: testimonials.length,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                final t = testimonials[index];
                                return Card(
                                  elevation: 3,
                                  color: const Color(0xffFFFFFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Row(
                                          children:
                                              List.generate(
                                            5,
                                            (i) => const Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors
                                                    .amber),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 12),
                                        Expanded(
                                          child: Text(
                                            "\"${t["quote"]}\"",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .grey[800],
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 16),
                                        Text(
                                          "- ${t["name"]}, ${t["role"]}",
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            color:
                                                Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 50),

                        // Trust Badges
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 10,
                          children: trustBadges
                              .map(
                                (badge) => Chip(
                                  label: Text(
                                    badge,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87),
                                  ),
                                  backgroundColor:
                                      AppColors.white,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ResponsiveWidget.isSmallScreen(context)
                        ? const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // LEFT SIDE (text + buttons)
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Make Your Crypto Work for You",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Stake, earn fixed APY, or explore flexible savings plans.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 24),

                                  // Buttons row
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      DownloadButton(
                                          label:
                                              "Flexible & fixed-term staking",
                                          icon: Iconsax
                                              .wallet_1_bold),
                                      DownloadButton(
                                          label:
                                              "Stablecoin savings (low risk)",
                                          icon: Icons
                                              .currency_bitcoin),
                                      DownloadButton(
                                          label:
                                              "High-yield farming (advanced users)",
                                          icon: Icons.bar_chart),
                                    ],
                                  ),

                                  SizedBox(height: 24),
                                  AppButton(
                                    text: 'Explore Options',
                                    height: 45,
                                    width: 290,
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              // RIGHT SIDE (cards stacked vertically)
                            ],
                          )
                        // Column(
                        //   children: investments.map((inv) {
                        //     return Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(
                        //               vertical: 8.0),
                        //       child: SizedBox(
                        //         width: 280,
                        //         child: InvestmentCard(
                        //           title: inv["title"],
                        //           coin: inv["coin"],
                        //           apy: inv["apy"],
                        //           durationDays:
                        //               inv["duration"],
                        //           minAmount: inv["min"],
                        //           maxAmount: inv["max"],
                        //           onStake: () {
                        //             debugPrint(
                        //                 "Staking ${inv["title"]}");
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),

                        : Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // LEFT SIDE
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Make Your Crypto Work for You",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Stake, earn fixed APY, or explore flexible savings plans.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    // Buttons row
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: [
                                        DownloadButton(
                                            label:
                                                "Flexible & fixed-term staking",
                                            icon: Iconsax
                                                .wallet_1_bold),
                                        DownloadButton(
                                            label:
                                                "Stablecoin savings (low risk)",
                                            icon: Icons
                                                .currency_bitcoin),
                                        DownloadButton(
                                            label:
                                                "High-yield farming (advanced users)",
                                            icon:
                                                Icons.bar_chart),
                                      ],
                                    ),

                                    SizedBox(height: 24),
                                    AppButton(
                                      text: 'Explore Options',
                                      height: 45,
                                      width: 290,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 40),

                              // RIGHT SIDE (Investment cards in horizontal scroll)
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  key: featuresKey,
                                  height:
                                      350, // 👈 set height to avoid RenderFlex error
                                  child: ListView.builder(
                                    scrollDirection:
                                        Axis.horizontal,
                                    itemCount:
                                        investments.length,
                                    itemBuilder:
                                        (context, index) {
                                      final inv =
                                          investments[index];
                                      return SizedBox(
                                        width:
                                            280, // 👈 fix card width
                                        child: Padding(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                      8.0),
                                          child: InvestmentCard(
                                            title: inv["title"],
                                            coin: inv["coin"],
                                            apy: inv["apy"],
                                            durationDays:
                                                inv["duration"],
                                            minAmount:
                                                inv["min"],
                                            maxAmount:
                                                inv["max"],
                                            onStake: () {
                                              debugPrint(
                                                  "Staking ${inv["title"]}");
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 60, horizontal: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/hero1.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isSmallScreen
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Join thousands of traders & investors today",
                      textAlign: isSmallScreen
                          ? TextAlign.center
                          : TextAlign.left,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppOutlineButton(
                        height: 55,
                        width: 220,
                        text: 'Create Account'),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30),
                color: AppColors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Our Trusted Partners",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: partners.length *
                            3, // duplicate for looping effect
                        itemBuilder: (context, index) {
                          final logo =
                              partners[index % partners.length];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: Image.asset(
                              logo,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveWidget.isSmallScreen(context)
                  ? Container(
                      key: contactKey,
                      height: 700,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 40),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/image/card1.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          // Top row
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Left: Stay Connected
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Stay Connected",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Text(
                                    "Stay updated on new developments and progress with CoinHarbor.",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Right: Newsletter input
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Join our bi-monthly newsletter!",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    height: 45,
                                    width: 270,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                              25),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                            width: 15),
                                        Expanded(
                                          child: TextField(
                                            decoration:
                                                InputDecoration(
                                              hintText:
                                                  "Enter your email here",
                                              border: InputBorder
                                                  .none,
                                              hintStyle: TextStyle(
                                                  color: Colors
                                                          .grey[
                                                      500]),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration:
                                              const BoxDecoration(
                                            color: Color(
                                                0xff8B4513), // Purple button
                                            shape:
                                                BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              // Send logic
                                            },
                                            icon: const Icon(
                                                Icons
                                                    .arrow_forward,
                                                color: Colors
                                                    .white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Social icons
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.facebook,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.linkedin,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.instagram,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.tiktok,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.twitterx,
                                              size: 25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 80),
                          const Divider(color: Colors.white30),
                          const SizedBox(height: 10),

                          // Bottom bar
                          const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "© 2025 CoinHarbor. Copyright and rights reserved",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Terms and Conditions . Privacy Policy",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(
                      key: contactKey,
                      height: 400,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 40),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/image/card1.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          // Top row
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              // Left: Stay Connected
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stay Connected",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    Text(
                                      "Stay updated on new developments and progress\nwith Coinharbor",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right: Newsletter input
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Join our bi-monthly newsletter!",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    height: 45,
                                    width: 270,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                              25),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                            width: 15),
                                        Expanded(
                                          child: TextField(
                                            decoration:
                                                InputDecoration(
                                              hintText:
                                                  "Enter your email here",
                                              border: InputBorder
                                                  .none,
                                              hintStyle: TextStyle(
                                                  color: Colors
                                                          .grey[
                                                      500]),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration:
                                              const BoxDecoration(
                                            color: Color(
                                                0xff8B4513), // Purple button
                                            shape:
                                                BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              // Send logic
                                            },
                                            icon: const Icon(
                                                Icons
                                                    .arrow_forward,
                                                color: Colors
                                                    .white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Social icons
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.facebook,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.linkedin,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.instagram,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.tiktok,
                                              size: 25),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .all(10),
                                          decoration:
                                              const BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Brand(
                                              Brands.twitterx,
                                              size: 25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 80),
                          const Divider(color: Colors.white30),
                          const SizedBox(height: 10),

                          // Bottom bar
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "© 2025 Coinharbor. Copyright and rights reserved",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15),
                              ),
                              Text(
                                "Terms and Conditions . Privacy Policy",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
            ],
          ),
        )
      ],
    );
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
}

class DownloadButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const DownloadButton(
      {super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20, color: AppColors.primary),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black87),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black26),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
      ),
    );
  }
}

class InvestmentCard extends StatelessWidget {
  final String title;
  final String coin;
  final String apy;
  final int durationDays;
  final String minAmount;
  final String maxAmount;
  final VoidCallback onStake;

  const InvestmentCard({
    super.key,
    required this.title,
    required this.coin,
    required this.apy,
    required this.durationDays,
    required this.minAmount,
    required this.maxAmount,
    required this.onStake,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Coin symbol
            Text(
              coin,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            // APY Highlight
            Text(
              "$apy APY",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.foundationGreyLightActive,
              ),
            ),
            const SizedBox(height: 12),

            // Duration
            Row(
              children: [
                const Icon(Iconsax.clock_bold,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  "$durationDays Days",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Range
            Row(
              children: [
                const Icon(Iconsax.wallet_bold,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  "Min $minAmount – Max $maxAmount ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const Spacer(),

            // CTA
            AppButton(
              onPressed: onStake,
              text: 'Stake Now',
              height: 45,
              width: 240,
            ),
          ],
        ),
      ),
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
