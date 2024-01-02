import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_state.dart';
import 'package:kumuly_pocket/services/wallet_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build(int inviteCodeLength) {
    ref.onDispose(() {
      for (var controller in state.inviteCodeControllers) {
        controller.dispose();
      }
      for (var focusNode in state.inviteCodeFocusNodes) {
        focusNode.dispose();
      }
    });

    final inviteCodeControllers = List.generate(
      inviteCodeLength,
      (_) => TextEditingController(),
    );
    final inviteCodeFocusNodes = List.generate(
      inviteCodeLength,
      (_) => FocusNode(),
    );

    return OnboardingState(
      inviteCodeControllers: inviteCodeControllers,
      inviteCodeFocusNodes: inviteCodeFocusNodes,
    );
  }

  void setWalletRecoveryLanguage(MnemonicLanguage language) {
    state = state.copyWith(language: language);
  }

  void inviteCodeChangeHandler(int index, String value) {
    const dashIndex = 4; // To skip the dash in the invite code.
    if (value.isEmpty && index > 0) {
      state.inviteCodeFocusNodes[
              index - 1 == dashIndex ? dashIndex - 1 : index - 1]
          .requestFocus();
    }
    if (value.length == 1 && index < inviteCodeLength - 1) {
      state.inviteCodeFocusNodes[
              index + 1 == dashIndex ? dashIndex + 1 : index + 1]
          .requestFocus();
    }

    // Set the invite code if all the invite code fields are filled,
    // otherwise set it to empty.
    String inviteCode = '';
    for (var i = 0; i < state.inviteCodeControllers.length; i++) {
      if (i == dashIndex) {
        inviteCode += '-';
        continue;
      }
      if (state.inviteCodeControllers[i].text.isNotEmpty) {
        inviteCode += state.inviteCodeControllers[i].text;
        continue;
      }
      inviteCode = '';
      break;
    }

    state = state.copyWith(inviteCode: inviteCode);

    // Remove the focus from the invite code field if the invite code is
    // completed.
    if (inviteCode.isNotEmpty) {
      state.inviteCodeFocusNodes[index].unfocus();
    }
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

  void addNumberToPinConfirmation(String number) {
    if (state.pinConfirmation.length < 4) {
      state = state.copyWith(pinConfirmation: state.pinConfirmation + number);
    }
  }

  void removeNumberFromPinConfirmation() {
    if (state.pinConfirmation.isNotEmpty) {
      state = state.copyWith(
          pinConfirmation: state.pinConfirmation
              .substring(0, state.pinConfirmation.length - 1));
    }
  }

  Future<void> setup() async {
    if (state.error is! CouldNotSetPinException) {
      // If the pin could not be set, it means connecting to the node already worked and the wallet is already generated.
      // We should not generate a new mnemonic for the same invite code in that case or it will give an error. One mnemonic per invite code.
      try {
        // Generate and set a mnemonic.
        await ref
            .read(
              walletServiceImplProvider,
            )
            .generateWallet(
              state.language,
            );
      } catch (e) {
        print(e);
        const error = CouldNotSetupWalletException();
        state = state.copyWith(error: error);
        throw error;
      }
    }

    try {
      // Now try to connect to a Breez SDK node.
      await ref
          .watch(
            breezeSdkLightningNodeServiceProvider,
          )
          .connect(
            AppNetwork.bitcoin, // Todo: Get network from App Network Provider
            inviteCode: state.inviteCode,
          );
    } catch (e) {
      print(e);
      const error = CouldNotConnectToNodeException();
      state = OnboardingState(
        language: state.language,
        inviteCode: state.inviteCode,
        inviteCodeControllers: state.inviteCodeControllers,
        inviteCodeFocusNodes: state.inviteCodeFocusNodes,
        pin: '',
        pinConfirmation: '',
        error: error,
      );
      throw error;
    }

    try {
      // Set the pin.
      await ref
          .read(
            walletServiceImplProvider,
          )
          .setPin(state.pin);
    } catch (e) {
      print(e);
      const error = CouldNotSetPinException();
      state = state.copyWith(error: error);
      throw error;
    }
  }
}

class CouldNotSetupWalletException implements Exception {
  const CouldNotSetupWalletException();
}

class CouldNotConnectToNodeException implements Exception {
  const CouldNotConnectToNodeException();
}

class CouldNotSetPinException implements Exception {
  const CouldNotSetPinException();
}
