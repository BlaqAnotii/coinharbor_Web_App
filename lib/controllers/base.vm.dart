import 'dart:convert';
import 'dart:io';


import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/repository/auth_repository.dart';
import 'package:coinharbor/resources/events.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_cache.dart';
import '../services/locator.dart';
import '../services/user_services.dart';

enum ViewState { Idle, Loading, Success, Error }

class BaseViewModel extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;
  String? errorMessage;
  UserServices userService = getIt<UserServices>();
  AuthRepository authRepo = getIt<AuthRepository>();

  AppData cache = getIt<AppData>();

  ViewState get viewState => _viewState;

  int cartItemsCount = 0;

  set viewState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  void setError(String? error) {
    errorMessage = error;
    notifyListeners();
  }

  bool isLoading = false;

  void startLoader() {
    if (!isLoading) {
      isLoading = true;
      viewState = ViewState.Loading;
      notifyListeners();
    }
  }

  void stopLoader() {
    if (isLoading) {
      isLoading = false;
      viewState = ViewState.Loading;
      notifyListeners();
    }
  }

  void setAppTitle(String title) {
    userServices.cache.eventBus!.fire(ApplicationEvent(title, "app_title"));
  }
}
