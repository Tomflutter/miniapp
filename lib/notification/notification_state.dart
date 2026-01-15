import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final int unreadCount;

  const NotificationState({this.unreadCount = 0});

  @override
  List<Object?> get props => [unreadCount];
}
