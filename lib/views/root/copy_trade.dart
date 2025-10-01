import 'dart:async';

import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/data/model/copy_trade_model.dart';
import 'package:coinharbor/data/model/expert_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CopyTradeScreen extends StatefulWidget {
  const CopyTradeScreen({super.key});

  @override
  State<CopyTradeScreen> createState() =>
      _CopyTradeScreenState();
}

class _CopyTradeScreenState extends State<CopyTradeScreen> {
  List<Expert> experts = [];

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
      List<Expert> fetchedtrans = await model.getAllExperts();
      setState(() {
        experts = fetchedtrans;
      });
    } catch (e) {
      debugPrint("Error fetching stores: $e");
    }
  }

  List<CopyTrade> copy = [];

  Future<void> fetchCopy(HomeViewModel model) async {
    try {
      List<CopyTrade> fetchedtrans = await model.getAllCopy();
      setState(() {
        copy = fetchedtrans;
      });
    } catch (e) {
      debugPrint("Error fetching stores: $e");
    }
  }

  TextEditingController percentController =
      TextEditingController();
  TextEditingController valueController =
      TextEditingController();

  /// ✅ Refresh handler for pull-to-refresh
  Future<void> _handleRefresh(HomeViewModel model) async {
    try {
// await sequentially to avoid type issues with Future.wait and void futures
      await fetchTransaction(model);
      await fetchCopy(model);
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
      fetchCopy(model);
    }, builder: (context, model, child) {
      return SafeArea(
        child: RefreshIndicator(
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
    });
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
          const Text("Top Rated Expert Traders",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Column(
            children: experts
                .take(5)
                .map((expert) => _riderTile(expert, isMobile))
                .toList(),
          ),
        ],
      ),
    );
  }

// Single rider row
  Widget _riderTile(Expert expert, bool isMobile) {
    return InkWell(
      onTap: () {
        if (isMobile) _showSelectDialog(context, expert);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage:
                  AssetImage('assets/images/user_avatar.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trader: ${expert.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  Text('Risk level: ${expert.risklevel}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text("Followers: ${expert.followers}",
                      style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 12)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text("ROI: ${expert.roi}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12)),
                      const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                      "Asset: ${expert.asset}  •  Total Allocated: \$${expert.volume}",
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
                      _showSelectDialog(context, expert);
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
                      "Copy",
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
  void _showSelectDialog(BuildContext context, Expert expert) {
    showDialog(
      context: context,
      builder: (context) {
        bool isMobile = MediaQuery.of(context).size.width < 700;

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
                            "Copy ${expert.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Enter the percentage of the Expert's total capital you want to allocate. Your own allocated amount will be calculated automatically based on this percentage.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          !isMobile
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      "Active Trades: ${expert.activeTrades.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Total Capital Allocated: \$${expert.volume}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Active Trades: ${expert.activeTrades.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Total Capital Allocated: \$${expert.volume}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 12),

                          // ✅ First text field: Enter percentage
                          TextField(
                            controller: percentController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  "Enter % of Total Capital",
                              labelStyle:
                                  const TextStyle(fontSize: 13),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: AppColors.background,
                                  )),
                            ),
                            onChanged: (value) {
                              double percent =
                                  double.tryParse(value) ?? 0;
                              double total =
                                  expert.volume.toDouble();
                              double calculated =
                                  (percent / 100) * total;

                              setState(() {
                                valueController.text = calculated
                                    .toStringAsFixed(2);
                              });
                            },
                          ),
                          const SizedBox(height: 15),

                          // ✅ Second text field: Read-only calculated value
                          TextField(
                            controller: valueController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Calculated Amount",
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
                                    if (percentController
                                            .text.isNotEmpty &&
                                        valueController
                                            .text.isNotEmpty) {
                                      model.processCopyTrade(
                                        context,
                                        expert.id,
                                        percentController.text,
                                        valueController.text,
                                      );
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
          const Text("Copied Trades",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Column(
            children: copy
                .map((copys) => _orderTile(copys))
                .toList(),
          )
        ],
      ),
    );
  }

  // Single order row
  Widget _orderTile(CopyTrade copy) {
    Color statusColor;
    switch (copy.status) {
      case "active":
        statusColor = Colors.green;
        break;
      case "paused":
        statusColor = Colors.orange;
        break;
      case "stopped":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

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
                      copy.traderName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    if (copy.status != "stopped")
                      InkWell(
                        onTap: () {
                          model.processstopCopyTrade(
                              context, copy.copyId);
                        },
                        child: const Text(
                          'Stop Copy Trade',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Allocation: \$${copy.allocationAmount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                Text("Currency: ${copy.allocationCurrency}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        fontSize: 14)),
                Text("Current value: \$${copy.currentValue}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        fontSize: 14)),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status: ${copy.status}",
                        style: TextStyle(color: statusColor)),
                    Text(
                        DateFormat('MMM d, yyyy • h:mm a')
                            .format(copy.createdAt),
                        style:
                            const TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          );
        });
  }
}
