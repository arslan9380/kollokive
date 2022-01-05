import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:kollokvie/services/group_chat_service.dart';
import 'package:kollokvie/services/image_service.dart';
import 'package:kollokvie/services/notification_service.dart';
import 'package:kollokvie/services/post_service.dart';
import 'package:kollokvie/view/ui/friends/friends_viewmodel.dart';
import 'package:kollokvie/view/ui/home/home_viewmodel.dart';
import 'package:kollokvie/view/ui/notifications/notifications_viewmodel.dart';
import 'package:kollokvie/view/ui/signup/signup_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

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
  locator.registerLazySingleton(() => NotificationService());

  locator.registerSingleton<HomeViewModel>(HomeViewModel());
  locator.registerSingleton<NotificationsViewModel>(NotificationsViewModel());
  locator.registerSingleton<SignUpViewModel>(SignUpViewModel());
  locator.registerSingleton<FriendsViewModel>(FriendsViewModel());
}
