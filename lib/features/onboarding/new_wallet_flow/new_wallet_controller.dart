import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/mnemonic_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/features/onboarding/new_wallet_flow/new_wallet_state.dart';
import 'package:kumuly_pocket/services/wallet_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_wallet_controller.g.dart';

@riverpod
class NewWalletController extends _$NewWalletController {
  @override
  NewWalletState build(int inviteCodeLength) {
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

    return NewWalletState(
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

  Future<void> setup() async {
    if (state.mnemonicWords.isEmpty) {
      try {
        // Generate a new mnemonic.
        List<String> mnemonic = await ref
            .read(
              walletServiceImplProvider,
            )
            .generateWallet(
              state.language,
            );
        state = state.copyWith(mnemonicWords: mnemonic);
      } catch (e) {
        print(e);
        const error = CouldNotGenerateWalletException();
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
            mnemonic: MnemonicEntity(
              words: state.mnemonicWords,
              language: state.language,
            ),
            inviteCode: state.inviteCode,
          );
    } catch (e) {
      print(e);
      const error = CouldNotConnectToNodeException();
      state = NewWalletState(
        language: state.language,
        inviteCode: state.inviteCode,
        inviteCodeControllers: state.inviteCodeControllers,
        inviteCodeFocusNodes: state.inviteCodeFocusNodes,
        error: error,
      );
      throw error;
    }

    try {
      // Store the mnemonic.
      await ref
          .read(
            walletServiceImplProvider,
          )
          .saveWallet(
            MnemonicEntity(
              words: state.mnemonicWords,
              language: state.language,
            ),
          );
    } catch (e) {
      print(e);
      const error = CouldNotStoreMnemonicException();
      state = state.copyWith(error: error);
      throw error;
    }
  }
}

class CouldNotGenerateWalletException implements Exception {
  const CouldNotGenerateWalletException();
}

class CouldNotConnectToNodeException implements Exception {
  const CouldNotConnectToNodeException();
}

class CouldNotStoreMnemonicException implements Exception {
  const CouldNotStoreMnemonicException();
}
