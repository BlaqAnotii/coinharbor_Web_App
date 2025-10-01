import 'dart:convert';

import 'package:coinharbor/controllers/base.vm.dart';
import 'package:coinharbor/data/model/copy_trade_model.dart';
import 'package:coinharbor/data/model/expert_model.dart';
import 'package:coinharbor/data/model/invest_history_model.dart';
import 'package:coinharbor/data/model/investment_options_model.dart';
import 'package:coinharbor/data/model/kyc_model.dart';
import 'package:coinharbor/data/model/transaction_model.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/data/model/wallet_model.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel {
  User? user;
  Future<User?> getUser() async {
    try {
      startLoader();
      final fetchedUser = await userService.getUserDetail();
      user = fetchedUser;
      notifyListeners();
      stopLoader();
      return user;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
      return null;
    }
  }

   KycData? kyc;
  Future<User?> getKycstatus() async {
    try {
      startLoader();
      final fetchedUser = await userService.getKycDetail();
      kyc = fetchedUser;
      notifyListeners();
      stopLoader();
      return user;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
      return null;
    }
  }

  Future<List<Wallet>> getAllWallet() async {
    try {
      startLoader();
      var wallets = await userService.getWallet();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  Future<List<Transaction>> getAllTransaction() async {
    try {
      startLoader();
      var wallets = await userService.getTransaction();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  Future<List<Expert>> getAllExperts() async {
    try {
      startLoader();
      var wallets = await userService.getExperts();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  Future<List<CopyTrade>> getAllCopy() async {
    try {
      startLoader();
      var wallets = await userService.getCopy();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  Future<List<InvestmentOption>> getAllInvOption() async {
    try {
      startLoader();
      var wallets = await userService.getInvOptions();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  Future<List<InvestmentHistory>> getAllInvest() async {
    try {
      startLoader();
      var wallets = await userService.getInvest();
      stopLoader();
      return wallets;
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
    return [];
  }

  final TextEditingController cryptoController =
      TextEditingController();

  double usdValue = 0.0;

  String selectedCrypto = "BITCOIN"; // default
  final List<Map<String, String>> cryptos = [
    {"id": "BITCOIN", "symbol": "BTC"},
    {"id": "ETHEREUM", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
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

  final TextEditingController amount = TextEditingController();

  final TextEditingController currency = TextEditingController();

  Future processConvert(BuildContext context, String currency,
      String amount) async {
    try {
      startLoader();
      var data = {
        "currency": currency,
        "amount": amount,
      };

      print("Payload: $data");

      var responseData = await authRepo.convert(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ??
              "Crypto Converted Successfully",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processLogout(BuildContext context) async {
    try {
      startLoader();

      var responseData = await userService.logout();

      stopLoader();
      context.replace('/login');
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processTransfer(BuildContext context, String currency,
      String amount) async {
    try {
      startLoader();
      var data = {
        "currency": currency,
        "amount": amount,
      };

      print("Payload: $data");

      var responseData = await authRepo.transfer(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Transfer is Successful",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processStartInvestment(
      BuildContext context, int optid, String amount) async {
    try {
      startLoader();
      var data = {
        "option_id": optid,
        "amount": amount,
      };

      print("Payload: $data");

      var responseData = await authRepo.startInvestment(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Successful Investment",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processWithdrawInvestment(
    BuildContext context,
    int opid,
  ) async {
    try {
      startLoader();
      var data = {"investment_id": opid};

      print("Payload: $data");

      var responseData = await authRepo.withdrawInvest(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Investment Withdrawn",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processCopyTrade(BuildContext context, int id,
      String percent, String amount) async {
    try {
      startLoader();
      var data = {
        "trader_id": id,
        "allocation_amount": amount,
        "allocation_percent": percent
      };

      print("Payload: $data");

      var responseData = await authRepo.copytrade(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Copy Trade is Successful",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processstopCopyTrade(
    BuildContext context,
    int id,
  ) async {
    try {
      startLoader();
      var data = {"copy_id": id};

      print("Payload: $data");

      var responseData = await authRepo.stopcopytrade(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Copy Trade is Stopped",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processDeposit(BuildContext context, String currency,
      String amount) async {
    try {
      startLoader();
      var data = {"currency": currency, "amount": amount};

      print("Payload: $data");

      var responseData = await authRepo.deposit(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');
        final res = responseData['data'];

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: const Color(0xffFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Deposit Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    responseData['message'] ??
                        'Deposit address retrieved successfully. Send funds to this address and wait for admin confirmation.',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRow("Currency", res['currency']),
                  _buildRow("Network", res['network']),

                  // Address row with copy button
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Address:  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                            width: 90,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10),
                                border: Border.all(
                                    width: 0.3,
                                    color: AppColors.darkGrey)),
                            child: Text(
                              res['address'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy,
                              size: 18, color: Colors.blueGrey),
                          tooltip: "Copy address",
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: res['address']));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Address copied to clipboard")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  _buildRow("Amount", res['amount']),
                  _buildRow("Fiat Equivalent",
                      '\$${res['fiat_equivalent']}'),
                  _buildRow("Status", res['status']),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text(
                    "Close",
                    style:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
        print('ALERT DIALOG SEEN:::: $responseData');

        // showCustomToast(
        //   responseData['message'] ?? "Deposit Request is pending",
        //   toastType: ToastType.success,
        // );
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processWithdraw(BuildContext context, String currency,
      String amount, String network, String recepient) async {
    try {
      startLoader();
      var data = {
        "currency": currency,
        "to": recepient,
        "amount": amount,
        "network": network
      };

      print("Payload: $data");

      var responseData = await authRepo.withdraw(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ??
              "Withdraw Request is pending",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processAddWallet(
    BuildContext context,
  ) async {
    try {
      startLoader();
      var data = {
        "currency": selectedCrypto,
      };

      print("Payload: $data");

      var responseData = await authRepo.addWallet(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Wallet Added",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }
}

Widget _buildRow(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
