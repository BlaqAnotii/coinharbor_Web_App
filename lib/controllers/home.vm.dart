import 'dart:convert';

import 'package:coinharbor/controllers/base.vm.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:coinharbor/data/model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeViewModel extends BaseViewModel {

  User? user;
  Future<User?> getUser() async {
    try {
      startLoader();
      final fetchedUser =
          await userService.getUserDetail();
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

  final TextEditingController cryptoController = TextEditingController();

  double usdValue = 0.0;

  String selectedCrypto = "BITCOIN"; // default
  final List<Map<String, String>> cryptos = [
    {"id": "BITCOIN", "symbol": "BTC"},
    {"id": "ETHEREUM", "symbol": "ETH"},
    {"id": "USDT", "symbol": "USDT"},
  ];

  Future<double> fetchCryptoPrice(String id) async {
    final url = Uri.parse("https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=usd");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data[id]["usd"] as num).toDouble();
    } else {
      throw Exception("Failed to load price");
    }
  }

 

}
