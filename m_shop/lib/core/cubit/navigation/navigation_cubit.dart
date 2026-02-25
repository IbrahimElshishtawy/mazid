import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(2); // Default to Home (index 2)

  void setIndex(int index) => emit(index);
}
