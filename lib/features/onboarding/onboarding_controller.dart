import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/mnemonic_length.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_state.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/services/mnemonic_service.dart';
import 'package:kumuly_pocket/services/pin_derived_encrypted_key_management_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    const kInviteCodeLength = 9;
    final inviteCodeControllers = List.generate(
      kInviteCodeLength,
      (_) => TextEditingController(),
    );
    final inviteCodeFocusNodes = List.generate(
      kInviteCodeLength,
      (_) => FocusNode(),
    );

    ref.onDispose(() {
      for (var controller in state.inviteCodeControllers) {
        controller.dispose();
      }
      for (var focusNode in state.inviteCodeFocusNodes) {
        focusNode.dispose();
      }
    });

    const mnemonicLength = MnemonicLength.words12;

    return OnboardingState(
      inviteCodeLength: kInviteCodeLength,
      inviteCodeControllers: inviteCodeControllers,
      inviteCodeFocusNodes: inviteCodeFocusNodes,
      mnemonicLength: mnemonicLength,
      recoveredWords: List.generate(mnemonicLength.length, (_) => ''),
    );
  }

  void inviteCodeChangeHandler(int index, String value) {
    const dashIndex = 4; // To skip the dash in the invite code.
    if (value.isEmpty && index > 0) {
      state.inviteCodeFocusNodes[
              index - 1 == dashIndex ? dashIndex - 1 : index - 1]
          .requestFocus();
    }
    if (value.length == 1 && index < state.inviteCodeControllers.length - 1) {
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

  Future<void> generateMnemonic() async {
    try {
      // Generate a new mnemonic.
      final mnemonic = await ref
          .read(
            masterKeyEncryptedMnemonicServiceProvider,
          )
          .createMnemonic(state.mnemonicLength);
      print('Mnemonic generated: $mnemonic');
      state = state.copyWith(mnemonic: mnemonic);
    } catch (e) {
      print(e);
      const error = CouldNotGenerateMnemonicException();
      state = state.copyWith(error: error);
      throw error;
    }
  }

  void wordChangeHandler(int index, String word) {
    // TODO: validate word and only add the word to the recovered words if it is valid
    // TODO: set suggested words
    final recoveredWords = [
      ...state.recoveredWords.sublist(0, index),
      word,
      ...state.recoveredWords.sublist(index + 1),
    ];

    final hasAllRecoveryWords =
        recoveredWords.length == state.mnemonicLength.length &&
            recoveredWords.every((word) => word.isNotEmpty);

    state = state.copyWith(
      recoveredWords: recoveredWords,
      mnemonic: hasAllRecoveryWords ? recoveredWords.join(' ') : '',
    );
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

  Future<void> confirmPin() async {
    try {
      // Set the pin.
      await ref
          .read(
            masterKeyManagementServiceProvider,
          )
          .init(state.pin);
    } catch (e) {
      print(e);
      const error = CouldNotSetPinException();
      state = state.copyWith(error: error);
      throw error;
    }
  }

  Future<void> connectNode() async {
    try {
      // Now try to connect to a Breez SDK node.
      await ref
          .watch(
            breezeSdkLightningNodeServiceProvider,
          )
          .connect(
            ref.watch(
              bitcoinNetworkProvider,
            ),
            state.mnemonic,
            inviteCode: state.inviteCode,
          );
    } catch (e) {
      print(e);
      const error = CouldNotConnectToNodeException();
      state = state.copyWith(
        error: error,
      );
      throw error;
    }
  }

  Future<void> storeMnemonic() async {
    try {
      // Store the mnemonic.
      await ref
          .read(
            masterKeyEncryptedMnemonicServiceProvider,
          )
          .storeMnemonic(
            state.mnemonic,
            MasterKeyEncryptedMnemonicService.kDefaultMnemonicLabel,
            state.pin,
          );
    } catch (e) {
      print(e);
      const error = CouldNotStoreMnemonicException();
      state = state.copyWith(error: error);
      throw error;
    }
  }
}

class CouldNotSetPinException implements Exception {
  const CouldNotSetPinException();
}

class CouldNotGenerateMnemonicException implements Exception {
  const CouldNotGenerateMnemonicException();
}

class CouldNotConnectToNodeException implements Exception {
  const CouldNotConnectToNodeException();
}

class CouldNotStoreMnemonicException implements Exception {
  const CouldNotStoreMnemonicException();
}
