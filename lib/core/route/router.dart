import 'package:go_router/go_router.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/view/chat/chat_view.dart';
import 'package:p2pbookshare/view/chat/chats_list_view.dart';
import 'package:p2pbookshare/view/landing_view.dart';
import 'package:p2pbookshare/view/login/login_view.dart';
import 'package:p2pbookshare/view/notifications/notification_view.dart';
import 'package:p2pbookshare/view/outgoing_req/outgoing_req_details_view.dart';
import 'package:p2pbookshare/view/request_book/request_book_view.dart';
import 'package:p2pbookshare/view/settings/setting_view.dart';
import 'package:p2pbookshare/view/user_book/user_book_details_view.dart';

class AppRouter {
  static GoRouter returnRouter(bool isAuth) {
    final GoRouter router = GoRouter(
      initialLocation: '/landing',
      routes: routeBase,
      redirect: (context, state) {
        if (!isAuth) {
          // Redirect to login if not authenticated
          if (state.uri.toString() != '/login') {
            return '/login';
          }
        }
        return null;
        // No redirection if authenticated or already on the login route
      },
    );
    return router;
  }

  ///list of route base for the router
  static List<RouteBase> routeBase = <RouteBase>[
    GoRoute(
      name: AppRouterConstants.loginView,
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      name: AppRouterConstants.landingView,
      path: '/landing',
      builder: (context, state) => const LandingView(),
    ),
    GoRoute(
      name: AppRouterConstants.notificationView,
      path: '/notificationView',
      builder: (context, state) => const NotificationView(),
    ),
    GoRoute(
      name: AppRouterConstants.chatsListView,
      path: '/chatsListView',
      builder: (context, state) => const ChatsListView(),
    ),
    GoRoute(
      path:
          '/${AppRouterConstants.userBookDetailsView}/:heroKey', // Define "heroKey" as a path parameter
      name: AppRouterConstants.userBookDetailsView,
      builder: (context, state) {
        // Retrieve book and additionalInfo from pathParameters
        final Book book = state.extra as Book;
        String heroKey = state.pathParameters['heroKey'] as String;
        return UserBookDetailsView(
          bookData: book,
          heroKey: heroKey,
        );
      },
    ),
    GoRoute(
      path: '/${AppRouterConstants.requestBookView}/:heroKey',
      name: AppRouterConstants.requestBookView,
      builder: (context, state) {
        final Book book = state.extra as Book;
        String heroKey = state.pathParameters['heroKey'] as String;
        return RequestBookView(
          bookData: book,
          heroKey: heroKey,
        );
      },
    ),
    GoRoute(
      path: '/${AppRouterConstants.outgoingRequestDetailsView}',
      name: AppRouterConstants.outgoingRequestDetailsView,
      builder: (context, state) {
        final BorrowRequest bookRequestModel = state.extra as BorrowRequest;
        // String heroKey = state.pathParameters['heroKey'] as String;
        return OutgoingReqDetailsView(
          bookrequestModel: bookRequestModel,
        );
      },
    ),
    GoRoute(
      path:
          '/${AppRouterConstants.chatView}/:receiverId/:receiverName/:chatRoomId/:receiverimgUrl/:bookId',
      name: AppRouterConstants.chatView,
      builder: (context, state) {
        String receiverId = state.pathParameters['receiverId'] as String;
        String receiverName = state.pathParameters['receiverName'] as String;
        String chatRoomId = state.pathParameters['chatRoomId'] as String;
        String receiverimgUrl =
            state.pathParameters['receiverimgUrl'] as String;
        String bookId = state.pathParameters['bookId'] as String;
        return ChatView(
            receiverId: receiverId,
            receiverName: receiverName,
            chatRoomId: chatRoomId,
            receiverimgUrl: receiverimgUrl,
            bookId: bookId);
      },
    ),
    GoRoute(
      name: AppRouterConstants.settingView,
      path: '/setting',
      builder: (context, state) => const SettingView(),
    )
  ];
}
