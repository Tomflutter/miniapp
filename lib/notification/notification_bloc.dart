import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<ReceiveNotification>((event, emit) {
      emit(
        NotificationState(unreadCount: state.unreadCount + 1),
      );
    });

    on<ClearNotifications>((event, emit) {
      emit(const NotificationState(unreadCount: 0));
    });
  }
}
