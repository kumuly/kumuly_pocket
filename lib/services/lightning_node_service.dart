import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/entities/recommended_fees_entity.dart';
import 'package:kumuly_pocket/entities/swap_in_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/enums/on_chain_fee_velocity.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/environment_variables.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:kumuly_pocket/repositories/mnemonic_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lightning_node_service.g.dart';

@riverpod
LightningNodeService breezeSdkLightningNodeService(
    BreezeSdkLightningNodeServiceRef ref) {
  final lightningNodeRepository =
      ref.watch(breezeSdkLightningNodeRepositoryProvider);
  final mnemonicRepository = ref.watch(secureStorageMnemonicRepositoryProvider);
  return BreezSdkLightningNodeService(
    lightningNodeRepository,
    mnemonicRepository,
  );
}

/*@riverpod
class SpendableBalanceSat extends _$SpendableBalanceSat {
  @override
  Stream<int?> build() {
    final lightningNodeService =
        ref.watch(breezeSdkLightningNodeServiceProvider);
    return lightningNodeService.spendableBalanceSat;
  }
}*/

@riverpod
Future<int> spendableBalanceSat(SpendableBalanceSatRef ref) {
  final lightningNodeService = ref.watch(breezeSdkLightningNodeServiceProvider);
  return lightningNodeService.spendableBalanceSat;
}

abstract class LightningNodeService {
  Stream<bool> streamInvoicePayment({String? bolt11, String? paymentHash});
  Stream<String> inProgressSwapPolling(Duration interval);
  Future<(String nodeId, String workingDirPath)> newNodeConnect(
    String alias,
    List<String> mnemonicWords,
    MnemonicLanguage language,
    AppNetwork network,
    String apiKey, {
    String? inviteCode,
    String? partnerCredentials,
  });
  Future<void> existingNodeConnect(
    String nodeId,
    String workingDirPath,
    AppNetwork network,
  );
  Future<InvoiceEntity> createInvoice(int amountSat, String? description);
  Future<(int? minAmountSat, int? maxAmountSat)> getLnurlPayAmounts(
    String paymentLink,
  );
  Future<void> payInvoice({required String bolt11, int? amountSat});
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountSat, {
    String? comment,
    bool useMinimumAmount,
  });
  Future<void> keysend(
    String nodeId,
    int amountSat,
  );
  Future<void> swapOut(String bitcoinAddress, int amountSat, int satPerVbyte);
  Future<int> getChannelOpeningFeeEstimate(int amountSat);
  Future<SwapInInfoEntity> getSwapInInfo(int amountSat);
  Future<int> get spendableBalanceSat;
  Future<int> get onChainBalanceSat;
  //Future<ReceptionAmountLimitsEntity> get receptionAmountLimits;
  Future<Map<OnChainFeeVelocity, int>> get recommendedFees;
  Future<List<PaymentEntity>> getPaymentHistory({
    int? offset,
    int? limit,
  });
  Future<void> disconnect();
}

class BreezSdkLightningNodeService implements LightningNodeService {
  BreezSdkLightningNodeService(
    this._lightningNodeRepository,
    this._mnemonicRepository,
  );

  final LightningNodeRepository _lightningNodeRepository;
  final MnemonicRepository _mnemonicRepository;

  @override
  Future<(String nodeId, String workingDirPath)> newNodeConnect(
    String alias,
    List<String> mnemonicWords,
    MnemonicLanguage language,
    AppNetwork network,
    String apiKey, {
    String? inviteCode,
    String? partnerCredentials,
  }) async {
    // The node needs to be initialized with a seed derived from the mnemonic.
    final seed = _mnemonicRepository.wordsToSeed(mnemonicWords, language);

    // The node needs a working directory to store its data.
    final path = await _setupWorkingDirectory(alias);

    final nodeId = await _lightningNodeRepository.connect(
      seed,
      network,
      apiKey,
      path,
      inviteCode: inviteCode,
      partnerCredentials: partnerCredentials,
    );

    return (nodeId, path);
  }

  @override
  Future<void> existingNodeConnect(
    String nodeId,
    String workingDirPath,
    AppNetwork network,
  ) async {
    // Get the mnemonic for the alias from secure storage.
    List<String> words = await _mnemonicRepository.getWords(nodeId);
    // Todo: take correct language instead of hardcoding english.
    final seed =
        _mnemonicRepository.wordsToSeed(words, MnemonicLanguage.english);

    // Connect to the breez node.
    await _lightningNodeRepository.connect(
      seed,
      network,
      breezSdkApiKey,
      workingDirPath,
    );
  }

  @override
  Future<InvoiceEntity> createInvoice(
      int amountSat, String? description) async {
    final amountMsat = amountSat * 1000;
    return _lightningNodeRepository.createInvoice(
      amountMsat: amountMsat,
      description: description,
    );
  }

  @override
  Future<void> payInvoice({required String bolt11, int? amountSat}) async {
    final amountMsat = amountSat == null ? null : amountSat * 1000;
    await _lightningNodeRepository.payInvoice(
      bolt11: bolt11,
      amountMsat: amountMsat,
    );
  }

  @override
  Future<void> swapOut(
    String bitcoinAddress,
    int amountSat,
    int satPerVbyte,
  ) async {
    await _lightningNodeRepository.swapOut(
      bitcoinAddress,
      amountSat,
      satPerVbyte,
    );
  }

  @override
  Future<int> getChannelOpeningFeeEstimate(int amountSat) async {
    final inbound = await _lightningNodeRepository.inboundLiquidityMsat ~/ 1000;
    int feeMsat = 0;
    if (inbound <= amountSat) {
      feeMsat = await _lightningNodeRepository
              .estimateChannelOpeningFeeMsat(amountSat) ~/
          1000;
    }

    return feeMsat;
  }

  @override
  Future<SwapInInfoEntity> getSwapInInfo(int amountSat) async {
    final swapInfoEntity = await _lightningNodeRepository.swapIn();
    final feeEstimate = swapInfoEntity.proportionalChannelOpeningFee == null
        ? null
        : swapInfoEntity.proportionalChannelOpeningFee! * amountSat ~/ 1000000;
    final feeExpiryTimestamp = swapInfoEntity.feeExpiry == null
        ? null
        : DateTime.parse(swapInfoEntity.feeExpiry!).millisecondsSinceEpoch ~/
            1000;

    return SwapInInfoEntity(
      swapInfoEntity.bitcoinAddress,
      swapInfoEntity.maxAmount,
      swapInfoEntity.minAmount,
      feeEstimate,
      feeExpiryTimestamp,
    );
  }

  @override
  Future<int> get spendableBalanceSat =>
      _lightningNodeRepository.spendableBalanceMsat.then(
        (msat) => msat ~/ 1000,
      );

  @override
  Future<int> get onChainBalanceSat =>
      _lightningNodeRepository.onChainBalanceMsat.then(
        (msat) => msat ~/ 1000,
      );

  @override
  // TODO: implement receptionAmountLimits
  //Future<ReceptionAmountLimits> get receptionAmountLimits =>
  //    throw UnimplementedError();

  @override
  Future<Map<OnChainFeeVelocity, int>> get recommendedFees async {
    return (await _lightningNodeRepository.recommendedFees).toMap();
  }

  Future<String> _setupWorkingDirectory(String alias) async {
    // Create a new folder for the user to have a separate working directory
    //  from nodes of other users on the same device/app.
    // The folder name is the hash of the alias to avoid special
    // characters and a timestamp so that later accounts can have the same name as the previous name of an older account where the name got changed for already.
    final aliasHash = _hash('$alias ${DateTime.now()}');
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = join(appDocDir.path, aliasHash);
    final dir = Directory(path);

    if (await dir.exists()) {
      throw FileSystemException(
        'Working directory already used for other node',
        path,
      );
    } else {
      await dir.create(recursive: true);
    }

    return path;
  }

  // Todo: move this function to a common crypto utilities file and use it in the pin repository as well.
  String _hash(String message) {
    final bytes = utf8.encode(message);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  Future<void> disconnect() async {
    await _lightningNodeRepository.disconnect();
  }

  @override
  Future<(int? minAmountSat, int? maxAmountSat)> getLnurlPayAmounts(
      String paymentLink) async {
    final decodedRequest =
        await _lightningNodeRepository.decodePaymentRequest(paymentLink);

    if (decodedRequest.type != PaymentRequestType.lnurlPay) {
      // Todo: throw a custom error type exception.
      throw Exception('Invalid payment link');
    }

    return (
      decodedRequest.lnurlPay!.minSendableSat,
      decodedRequest.lnurlPay!.maxSendableSat
    );
  }

  @override
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountSat, {
    String? comment,
    bool useMinimumAmount = false,
  }) async {
    return _lightningNodeRepository.payLnUrlPay(
      paymentLink,
      amountSat * 1000,
      comment: comment,
      useMinimumAmount: useMinimumAmount,
    );
  }

  @override
  Future<List<PaymentEntity>> getPaymentHistory({
    int? offset,
    int? limit,
  }) =>
      _lightningNodeRepository.getPayments(offset: offset, limit: limit);

  @override
  Stream<bool> streamInvoicePayment({String? bolt11, String? paymentHash}) {
    return _lightningNodeRepository.paidInvoiceStream.map((event) {
      print('paidInvoiceStream: $event');
      final paidInvoice = event.$1;
      final paidHash = event.$2;
      if ((bolt11 != null && bolt11 == paidInvoice) ||
          (paymentHash != null && paymentHash == paidHash)) {
        return true;
      }
      return false;
    });
  }

  @override
  Stream<String> inProgressSwapPolling(Duration interval) {
    // Use a StreamController to control the stream
    var controller = StreamController<String>();

    var timer = Timer.periodic(interval, (Timer t) async {
      var swapAddress = await _lightningNodeRepository.inProgressSwap;
      if (swapAddress != null) {
        controller.add(swapAddress);
      }
    });

    // Handle stream cancellation
    controller.onCancel = () {
      timer.cancel();
    };

    // Return the stream
    return controller.stream;
  }

  @override
  Future<void> keysend(String nodeId, int amountSat) {
    return _lightningNodeRepository.keysend(nodeId, amountSat * 1000);
  }
}
