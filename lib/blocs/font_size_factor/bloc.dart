import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/utils/services/local_storage_service.dart';

import 'event.dart';
import 'state.dart';

class FontSizeBloc extends Bloc<FontSizeFactorEvent, FontSizeFactorState> {
  FontSizeBloc() : super(FontSizeFactorInititalState(1));

  @override
  Stream<FontSizeFactorState> mapEventToState(
      FontSizeFactorEvent event) async* {
    if (event is LoadFontSizeFactorEvent) {
      double fontsize;
      try {
        fontsize = await Preferences.getFontSizeFactor();
      } catch (e) {
        fontsize = 1;
      }
      yield FontSizeFactorLoadedState(fontsize);
    } else if (event is ChangedFontSizeFactorEvent) {
      Preferences.setFontSizeFactor(event.size);
      yield FontSizeFactorChangedState(event.size);
    }
  }

  Future<void> close() async {
    Preferences.setFontSizeFactor(state.size);
    super.close();
  }
}
