import 'package:bloc/bloc.dart';

class BottomNavigationBarIndexCubit extends Cubit<int> {
  BottomNavigationBarIndexCubit() : super(0);

  updateIndex(int index) {
    emit(index);
  }
}
