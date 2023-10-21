import 'dart:async';

import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/features/sign_in/sign_in_state.dart';
import 'package:kumuly_pocket/view_models/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  SignInState build(
    AuthenticationService authenticationService,
    AccountService accountService,
    LightningNodeService lightningNodeService,
  ) {
    // Dispose the subscription when the controller is disposed.
    ref.onDispose(() {
      _accountsStateChangedSubscription?.cancel();
    });

    // Listen to changes in the accounts list.
    _accountsStateChangedSubscription =
        accountService.accountsStateChanged.listen((accounts) {
      state = state.copyWith(
        accounts: accounts
            .map((entity) => Account.fromAccountEntity(entity))
            .toList(),
      );
    });

    // Get and set the initial accounts list.
    final initialAccounts = accountService.accounts
        .map((entity) => Account.fromAccountEntity(entity))
        .toList();

    return SignInState(accounts: initialAccounts);
  }

  StreamSubscription<List<AccountEntity>>? _accountsStateChangedSubscription;

  void setSelectedAccount(Account account) {
    state = state.copyWith(selectedAccount: account);
  }

  void addNumberToPin(String number) {
    if (state.pin.length < 4) {
      state = state.copyWith(pin: state.pin + number);
    }
  }

  void removeNumberFromPin() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
    }
  }

  Future<void> signIn() async {
    // Todo: Error handling and loading state
    print('Signing in...');
    final nodeId = state.selectedAccount.nodeId;
    final AccountEntity accountEntity = await accountService.getAccount(nodeId);

    // Connect to the node of the account
    await lightningNodeService.existingNodeConnect(
      nodeId,
      accountEntity.workingDirPath,
      AppNetwork.bitcoin, // Todo: Get network from App Network Provider
    );
    print(
      'Connected to node with id: $nodeId and working dir path: ${accountEntity.workingDirPath}',
    );

    // Log in the user to its account.
    await authenticationService.logIn(nodeId);
    print('User logged in with account id: $nodeId');
  }
}
