import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';
import 'package:homez/features/take_look/data/repo/take_look_repo.dart';

part 'take_look_state.dart';

class TakeLookCubit extends Cubit<TakeLookState> {
  TakeLookCubit({required this.takeLookRepo}) : super(TakeLookInitial());
  TakeLookRepo takeLookRepo;
  Future<void> takeLook({required int apartmentId}) async {
    try {
      final response =
          await takeLookRepo.takeLookData(apartmentId: apartmentId);
      response.fold((l) => emit(TakeLookFailed()),
          (r) => emit(TakeLookSuccess(takeLookData: r)));
    } catch (e) {
      emit(TakeLookFailed());
    }
  }
}
