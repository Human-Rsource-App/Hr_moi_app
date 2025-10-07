import 'package:bloc/bloc.dart';
import 'package:hr_moi/shared/cubit/states.dart';

class HrMoiCubit extends Cubit<HrMoiStates> {
  HrMoiCubit() : super(InitialState());
}
