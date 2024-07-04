import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_unread_messages_count.dart';
// part 'unread_messages_count_state.dart';

class UnreadMessagesCountCubit extends Cubit<Map<String, int>> {
  final FetchUnreadMessagesCount fetchUnreadMessagesCount;
  late StreamSubscription<Map<String, int>> messagesSubscription;

  UnreadMessagesCountCubit(this.fetchUnreadMessagesCount) : super({});

  void unreadMessagesCountFetched() {
    final response = fetchUnreadMessagesCount.call(unit);
    response.fold(
      (l) => emit(state), // Emit current state in case of error
      (stream) {
        // log('stream ' + stream.toString());
        // Clear the current state

        // Listen to the new stream and update the state

        messagesSubscription = stream.listen((element) {
          emit({});
          // log('element' + element.toString());
          emit(element);
        });
      },
    );
  }

  void closeStreamController() {
    messagesSubscription.cancel();
    emit({});
  }

  @override
  void onChange(Change<Map<String, int>> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
