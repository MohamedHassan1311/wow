import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../app/core/app_event.dart';
import '../../app/core/app_state.dart';
import '../../data/config/di.dart';
import '../repo/dashboard_repo.dart';

class DashboardBloc extends Bloc<AppEvent, AppState> {
  final DashboardRepo repo;
  DashboardBloc({required this.repo}) : super(Start()) {
    updateSelectIndex(0);
  }

  static DashboardBloc get instance => sl<DashboardBloc>();


  final selectIndex = BehaviorSubject<int>();
  updateSelectIndex(int v) {
    selectIndex.sink.add(v);
    if (v != 1) {
      repo.removeProductType();
    }
  }

  Stream<int> get selectIndexStream => selectIndex.stream.asBroadcastStream();
}
