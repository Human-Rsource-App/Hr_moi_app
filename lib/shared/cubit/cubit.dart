import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/cubit/states.dart';

class HrMoiCubit extends Cubit<HrMoiStates> {
  HrMoiCubit() : super(InitialState());
  static HrMoiCubit get(BuildContext context) => BlocProvider.of(context);
}
