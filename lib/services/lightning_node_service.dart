import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/keysend_payment_details_entity.dart';
import 'package:kumuly_pocket/entities/mnemonic_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
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
  Future<void> connect(
    AppNetwork network, {
    MnemonicEntity? mnemonic,
    String? inviteCode,
    String? partnerCredentials,
  });
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
  Future<KeysendPaymentDetailsEntity> keysend(
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
  Future<void> connect(
    AppNetwork network, {
    MnemonicEntity? mnemonic,
    String? inviteCode,
    String? partnerCredentials,
  }) async {
    // The node needs a working directory to store its data.
    final path = await _getWorkingDirectory();

    await _lightningNodeRepository.connect(
      mnemonic != null
          ? _mnemonicRepository
              .mnemonicToSeed(mnemonic) // Use the provided mnemonic.
          : await _mnemonicRepository.getSeed(), // Use the stored mnemonic.
      network,
      breezSdkApiKey,
      path,
      inviteCode: inviteCode,
      partnerCredentials: partnerCredentials,
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

  Future<String> _getWorkingDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = join(appDocDir.path, kBreezSdkWorkingDirName);
    final dir = Directory(path);

    if (!(await dir.exists())) {
      // If the folder doesn't exist yet, create it.
      await dir.create(recursive: true);
    }

    return path;
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
  Future<KeysendPaymentDetailsEntity> keysend(String nodeId, int amountSat) {
    return _lightningNodeRepository.keysend(nodeId, amountSat * 1000);
  }
}
