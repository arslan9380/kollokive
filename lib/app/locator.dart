import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/friend_service.dart';
import 'package:tajeer/services/group_chat_service.dart';
import 'package:tajeer/services/image_service.dart';
import 'package:tajeer/services/post_service.dart';
import 'package:tajeer/view/ui/friends/friends_viewmodel.dart';
import 'package:tajeer/view/ui/home/home_viewmodel.dart';
import 'package:tajeer/view/ui/notifications/notifications_viewmodel.dart';
import 'package:tajeer/view/ui/signup/signup_viewmodel.dart';

final locator = GetIt.instance;

@injectableInit
void setupLocator() {
  locator.registerLazySingleton(() => CommonUiService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => PostService());
  locator.registerLazySingleton(() => ImageService());
  locator.registerLazySingleton(() => FriendService());
  locator.registerLazySingleton(() => GroupChatService());

  locator.registerSingleton<HomeViewModel>(HomeViewModel());
  locator.registerSingleton<NotificationsViewModel>(NotificationsViewModel());
  locator.registerSingleton<SignUpViewModel>(SignUpViewModel());
  locator.registerSingleton<FriendsViewModel>(FriendsViewModel());
}
