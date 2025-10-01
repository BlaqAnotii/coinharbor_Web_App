import 'dart:async';

import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/copy_trade_model.dart';
import 'package:coinharbor/data/model/expert_model.dart';
import 'package:coinharbor/data/model/invest_history_model.dart';
import 'package:coinharbor/data/model/investment_options_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() =>
      _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  List<InvestmentOption> options = [];

  Timer? _timer; // ✅ store the timer reference

  @override
  void initState() {
    super.initState();

    // ✅ Start auto-refresh every second
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final model = HomeViewModel(); // ⚠️ Replace with your provider/get_it if needed
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _handleRefresh(model);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ Stop timer when leaving screen
    super.dispose();
  }


  Future<void> fetchTransaction(HomeViewModel model) async {
    try {
      List<InvestmentOption> fetchedtrans =
          await model.getAllInvOption();
      setState(() {
        options = fetchedtrans;
      });
    } catch (e) {
      debugPrint("Error fetching stores: $e");
    }
  }

  List<InvestmentHistory> history = [];

  Future<void> fetchInvest(HomeViewModel model) async {
    try {
      List<InvestmentHistory> fetchedtrans =
          await model.getAllInvest();
      setState(() {
        history = fetchedtrans;
      });
    } catch (e) {
      debugPrint("Error fetching stores: $e");
    }
  }

   /// ✅ Refresh handler for pull-to-refresh
  Future<void> _handleRefresh(HomeViewModel model) async {
    try {
// await sequentially to avoid type issues with Future.wait and void futures
      await fetchTransaction(model);
      await fetchInvest(model);
    } catch (e, st) {
      debugPrint('Error refreshing account screen: $e\n$st');
      showCustomToast('Failed to refresh data',
          toastType: ToastType.error);
      // rethrow if you want RefreshIndicator to show error higher up (not required)
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(onModelReady: (model) {
      fetchTransaction(model);
      fetchInvest(model);
    }, builder: (context, model, child) {
        return SafeArea(
          child:  RefreshIndicator(
              onRefresh: () => _handleRefresh(model),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 700;
            
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      const SizedBox(
                        height: 30,
                      ),
                      // Responsive layout
                      isMobile
                          ? Column(
                              children: [
                                _buildRidersList(isMobile: true),
                                const SizedBox(height: 16),
                                _buildOrderHistory(),
                              ],
                            )
                          : Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: _buildRidersList(
                                        isMobile: false)),
                                const SizedBox(width: 16),
                                Expanded(
                                    flex: 2,
                                    child: _buildOrderHistory()),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }

  // Riders list
  Widget _buildRidersList({required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.background,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Investment Options",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Column(
            children: options
                .map((opt) => _riderTile(opt, isMobile))
                .toList(),
          ),
        ],
      ),
    );
  }

// Single rider row
  Widget _riderTile(InvestmentOption opt, bool isMobile) {
    String getCoinImage(String coin) {
      switch (coin.toUpperCase()) {
        case "BTC":
          return "assets/images/bitcoin.png";
        case "ETH":
          return "assets/images/ethereum.png";
        case "USDT":
          return "assets/images/money.png";
        default:
          return "assets/images/bitcoin.png"; // fallback
      }
    }

    return GestureDetector(
      onTap: () {
        if (isMobile) _showSelectDialog(context, opt);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  AssetImage(getCoinImage(opt.coin)),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(opt.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  Text('Coin: ${opt.coin}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text("Duration: ${opt.durationDays}",
                      style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 12)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text("APY: ${opt.apy}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                      "Min_Amount: ${opt.minAmount}  •  Max_amount: ${opt.maxAmount}",
                      style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 8),

                // On desktop → show message, call, select
                // On mobile → show only call
                // if (!isMobile)
                //   IconButton(
                //       onPressed: () {},
                //       icon: const Icon(Icons.chat_bubble_outline)),
                // if (!isMobile)
                //   IconButton(
                //       onPressed: () {},
                //       icon: const Icon(Icons.phone_outlined)),

                if (!isMobile)
                  ElevatedButton(
                    onPressed: () {
                      _showSelectDialog(context, opt);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      "Stake",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(
                            0xffFFFFFF,
                          )),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show Dialog when "Select" is tapped
  void _showSelectDialog(
      BuildContext context, InvestmentOption opt) {
    showDialog(
      context: context,
      builder: (context) {
        bool isMobile = MediaQuery.of(context).size.width < 700;

        TextEditingController amountController =
            TextEditingController();

        return BaseView<HomeViewModel>(
            onModelReady: (model) {},
            builder: (context, model, child) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: isMobile ? 0 : 400,
                      right: isMobile ? 0 : 400,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: isMobile
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(60),
                      decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius:
                              BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Investment Type: ${opt.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter the amount of ${opt.coin} coin you intend to invest",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ✅ First text field: Enter percentage
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Enter Amount",
                              labelStyle:
                                  const TextStyle(fontSize: 13),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: AppColors.background,
                                  )),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ✅ Action buttons
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              const SizedBox(width: 8),
                              AppButton(
                                  onPressed: () {
                                    if (amountController
                                        .text.isNotEmpty) {
                                      model
                                          .processStartInvestment(
                                              context,
                                              opt.id,
                                              amountController
                                                  .text);
                                    }
                                  },
                                  width: 180,
                                  height: 40,
                                  text: 'Confirm')
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }

  // Order history card
  Widget _buildOrderHistory() {
    return BaseView<HomeViewModel>(onModelReady: (model) {
      fetchInvest(model);
    }, builder: (context, model, child) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.background,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Investment History",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Column(
              children: history
                  .map((histories) => _orderTile(histories))
                  .toList(),
            )
          ],
        ),
      );
    });
  }

  // Single order row
  Widget _orderTile(InvestmentHistory history) {
    Color statusColor;
    switch (history.status) {
      case "active":
        statusColor = Colors.orange;
        break;
      case "completed":
        statusColor = Colors.green;
        break;
      case "redeemed":
        statusColor = Colors.blue;
        break;
      case "cancelled":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return BaseView<HomeViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      history.optionName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    if (history.status != "cancelled" &&
                        history.status != "redeemed" &&
                        history.status != "completed" &&
                        history.status != "withdrawn")
                      InkWell(
                        onTap: () {
                          model.processWithdrawInvestment(
                              context, history.investmentId);
                        },
                        child: const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.green,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Acc Fiat: \$${history.accruedFiat.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Staked amount: \$${history.amount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Status: ${history.status}",
                    style: TextStyle(color: statusColor)),
                (!isMobile)
                    ? Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              DateFormat('MMM d, yyyy • h:mm a')
                                  .format(history.startDate),
                              style: const TextStyle(
                                  color: Colors.grey)),
                          const Text('   -    ',
                              style:
                                  TextStyle(color: Colors.grey)),
                          Text(
                              DateFormat('MMM d, yyyy • h:mm a')
                                  .format(history.endDate),
                              style: const TextStyle(
                                  color: Colors.grey)),
                        ],
                      )
                    : Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Start ${DateFormat('MMM d, yyyy • h:mm a').format(history.startDate)}",
                              style: const TextStyle(
                                  color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                              "End ${DateFormat('MMM d, yyyy • h:mm a').format(history.endDate)}",
                              style: const TextStyle(
                                  color: Colors.grey)),
                        ],
                      )
              ],
            ),
          );
        });
  }
}
