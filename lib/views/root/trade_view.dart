import 'dart:async';
import 'package:coinharbor/resources/charts.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class TradeViewScreen extends StatefulWidget {
  const TradeViewScreen({super.key});

  @override
  State<TradeViewScreen> createState() =>
      _TradeViewScreenState();
}

class _TradeViewScreenState extends State<TradeViewScreen> {
  final TextEditingController _coinController =
      TextEditingController(text: "bitcoin");

  String _coinId = "bitcoin";
  String _selectedCurrency = "usd";
  int _selectedDays = 1;
  Timer? _timer;

  final List<String> currencies = [
    "usd",
    "eur",
    "ngn",
    "gbp",
    "jpy"
  ];
  final Map<String, int> timeframes = {
    "1 Day": 1,
    "7 Days": 7,
    "30 Days": 30,
    "90 Days": 90,
    "Max": 365,
  };

  @override
  void initState() {
    super.initState();

    // ✅ Start auto-refresh every second
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
              setState(() {}); // rebuild chart with fresh data

      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ Stop timer when leaving screen
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final isSmallScreen =
        MediaQuery.of(context).size.width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Coin Input (responsive: row on wide, column on small)
              isSmallScreen
                  ? Column(
                      children: [
                        TextField(
                          controller: _coinController,
                          decoration: InputDecoration(
                            labelText:
                                "Enter coinId (e.g. bitcoin, ethereum, solana)",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color:
                                        AppColors.background)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                              width: 180,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  _coinId = _coinController.text
                                      .trim()
                                      .toLowerCase();
                                });
                              },
                              text: 'Load'),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 500,
                      child: Row(children: [
                        Expanded(
                          child: SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _coinController,
                              decoration: InputDecoration(
                                labelText:
                                    "Enter coinId (e.g. bitcoin, ethereum, solana)",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            30),
                                    borderSide: const BorderSide(
                                        color: AppColors
                                            .background)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppButton(
                            width: 180,
                            height: 45,
                            onPressed: () {
                              setState(() {
                                _coinId = _coinController.text
                                    .trim()
                                    .toLowerCase();
                              });
                            },
                            text: 'Load'),
                      ]),
                    ),
              const SizedBox(height: 16),

              // 🔹 Currency Dropdown
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Text("Currency: "),
                  DropdownButton<String>(
                    value: _selectedCurrency,
                    items: currencies
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(
                            () => _selectedCurrency = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔹 Timeframe Dropdown
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Text("Timeframe: "),
                  DropdownButton<int>(
                    value: _selectedDays,
                    items: timeframes.entries
                        .map((e) => DropdownMenuItem(
                              value: e.value,
                              child: Text(e.key),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDays = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔹 Chart (responsive height)
              Container(
                height: isSmallScreen
                    ? 500
                    : constraints.maxHeight * 1,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: CandleChartWidget(
                  key: ValueKey(
                      '$_coinId-$_selectedCurrency-$_selectedDays'),
                  coinId: _coinId,
                  vsCurrency: _selectedCurrency,
                  days: _selectedDays,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
