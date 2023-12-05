import 'package:kumuly_pocket/features/for_you/for_you_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'for_you_controller.g.dart';

@riverpod
class ForYouController extends _$ForYouController {
  @override
  ForYouState build() {
    // Todo: replace with real data obtained from API
    final List<String> tabs = [
      '+',
      'Promos 🔥',
      'Tickets',
      'Transportation',
      'Subscriptions',
      'Merchants map',
    ];

    // Todo: get Promos from API

    return ForYouState(tabs: tabs, selectedTab: 1);
  }

  void onTabSelectHandler(int index) {
    // Todo: query products for tab and set them in state too

    state = state.copyWith(selectedTab: index);
  }
}
