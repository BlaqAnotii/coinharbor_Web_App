
import 'package:coinharbor/controllers/auth_vm.dart';
import 'package:coinharbor/controllers/home.vm.dart';
import 'package:coinharbor/controllers/login.vm.dart';
import 'package:coinharbor/repository/auth_repository.dart';
import 'package:coinharbor/resources/routes.dart';
import 'package:coinharbor/services/app_cache.dart';
import 'package:get_it/get_it.dart';
import '../controllers/base.vm.dart';
import 'navigation_service.dart';
import 'user_services.dart';

GetIt getIt = GetIt.I;

void setupLocator() {
  getIt.registerLazySingleton<AppRouteConfig>(() => AppRouteConfig());
  getIt.registerLazySingleton<AppData>(() => AppData());
  getIt.registerLazySingleton<UserServices>(() => UserServices());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  /*getIt.registerLazySingleton<AppCache>(() => AppCache());
  */
  registerViewModel();
}

void registerViewModel() {
  getIt.registerFactory<BaseViewModel>(() => BaseViewModel());
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel());
  getIt.registerFactory<LoginViewModel>(() => LoginViewModel());
  getIt.registerFactory<AuthViewModel>(() => AuthViewModel());

  //View Model
}
