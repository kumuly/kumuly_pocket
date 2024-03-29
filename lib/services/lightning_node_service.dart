import 'dart:async';
import 'dart:io';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/keysend_payment_details_entity.dart';
import 'package:kumuly_pocket/entities/paid_invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/on_chain_fee_velocity.dart';
import 'package:kumuly_pocket/enums/transaction_direction.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/enums/transaction_status.dart';
import 'package:kumuly_pocket/enums/transaction_type.dart';
import 'package:kumuly_pocket/environment_variables.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'lightning_node_service.g.dart';

@riverpod
LightningNodeService breezeSdkLightningNodeService(
    BreezeSdkLightningNodeServiceRef ref) {
  final lightningNodeRepository =
      ref.watch(breezeSdkLightningNodeRepositoryProvider);
  final breezSdk = ref.watch(breezSdkProvider);
  return BreezSdkLightningNodeService(
    lightningNodeRepository,
    breezSdk,
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
  Future<PaidInvoiceEntity> waitForPayment({
    String? bolt11,
    String? paymentHash,
  });
  Stream<SwapInfoEntity> inProgressSwapPolling(Duration interval);
  Future<void> connect(
    AppNetwork network,
    String mnemonic, {
    String? inviteCode,
    String? partnerCredentials,
  });
  Future<InvoiceEntity> createInvoice(
    int amountSat,
    String? description,
    int? expiry,
  );
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
  Future<SwapInfoEntity> getSwapInInfo();
  Future<int> get spendableBalanceSat;
  Future<int> get onChainBalanceSat;
  //Future<ReceptionAmountLimitsEntity> get receptionAmountLimits;
  Future<Map<OnChainFeeVelocity, int>> get recommendedFees;
  Future<List<PaymentEntity>> getPaymentHistory({
    int? offset,
    int? limit,
  });
  Future<PaymentEntity?> getPaymentByHash(String hash);
  Future<void> disconnect();
}

class BreezSdkLightningNodeService implements LightningNodeService {
  BreezSdkLightningNodeService(this._lightningNodeRepository, this._breezSdk);

  final LightningNodeRepository _lightningNodeRepository;
  final BreezSDK _breezSdk;

  @override
  Future<void> connect(
    AppNetwork network,
    String mnemonic, {
    String? inviteCode,
    String? partnerCredentials,
  }) async {
    // The node needs a working directory to store its data.
    final path = await _getWorkingDirectory();
    final seed = await _breezSdk.mnemonicToSeed(mnemonic);

    await _lightningNodeRepository.connect(
      seed,
      network,
      breezSdkApiKey,
      path,
      inviteCode: inviteCode,
      partnerCredentials: partnerCredentials,
    );
  }

  @override
  Future<InvoiceEntity> createInvoice(
    int amountSat,
    String? description,
    int? expiry,
  ) async {
    final amountMsat = amountSat * 1000;
    return _lightningNodeRepository.createInvoice(
      amountMsat: amountMsat,
      description: description,
      expiry: expiry,
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
    try {
      final inbound =
          await _lightningNodeRepository.inboundLiquidityMsat ~/ 1000;

      print('inbound: $inbound');

      if (inbound <= amountSat) {
        return (await _lightningNodeRepository
                .estimateChannelOpeningFeeMsat(amountSat)) ~/
            1000;
      }

      return 0;
    } catch (e) {
      print(e);
      throw GetChannelOpeningFeeEstimateException(e.toString());
    }
  }

  @override
  Future<SwapInfoEntity> getSwapInInfo() async {
    try {
      return _lightningNodeRepository.swapIn();
    } catch (e) {
      print(e);
      throw GetSwapInInfoException(e.toString());
    }
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
    TransactionDirection? direction,
    int? fromTimestamp,
    int? toTimestamp,
    bool? includeFailures,
    int? offset,
    int? limit,
  }) async {
    List<PaymentTypeFilter>? filters;

    if (direction != null) {
      filters = [
        direction == TransactionDirection.incoming
            ? PaymentTypeFilter.Received
            : PaymentTypeFilter.Sent,
      ];
    }

    ListPaymentsRequest req = ListPaymentsRequest(
      filters: filters,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
      includeFailures: includeFailures,
      offset: offset,
      limit: limit,
    );
    List<Payment> payments = await _breezSdk.listPayments(req: req);
    // Only keep LN payments and remove closed channel payments
    payments.removeWhere(
        (payment) => payment.details is PaymentDetails_ClosedChannel);
    return payments
        .map((payment) => _paymentEntityFromPayment(payment))
        .toList();
  }

  @override
  Future<PaidInvoiceEntity> waitForPayment(
      {String? bolt11, String? paymentHash}) {
    return _lightningNodeRepository.paidInvoiceStream.firstWhere((event) {
      print('waitForPayment: $event');
      if ((bolt11 != null && bolt11 == event.bolt11) ||
          (paymentHash != null && paymentHash == event.paymentHash)) {
        return true;
      }
      return false;
    });
  }

  @override
  Stream<SwapInfoEntity> inProgressSwapPolling(Duration interval) {
    // Use a StreamController to control the stream
    var controller = StreamController<SwapInfoEntity>();

    var timer = Timer.periodic(interval, (Timer t) async {
      var swap = await _lightningNodeRepository.inProgressSwap;
      if (swap != null) {
        controller.add(swap);
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

  @override
  Future<PaymentEntity?> getPaymentByHash(String hash) async {
    final payment = await _breezSdk.paymentByHash(hash: hash);
    if (payment == null) {
      return null;
    }
    return _paymentEntityFromPayment(payment);
  }

  PaymentEntity _paymentEntityFromPayment(Payment payment) {
    PaymentDetails_Ln details = payment.details as PaymentDetails_Ln;

    return PaymentEntity(
      id: details.data.paymentHash,
      receivedAmountSat: payment.paymentType == PaymentType.Received
          ? payment.amountMsat ~/ 1000
          : 0,
      sentAmountSat: payment.paymentType == PaymentType.Sent
          ? payment.amountMsat ~/ 1000
          : 0,
      timestamp: payment.paymentTime,
      status: payment.status == PaymentStatus.Pending
          ? TransactionStatus.pending
          : payment.status == PaymentStatus.Complete
              ? TransactionStatus.complete
              : payment.status == PaymentStatus.Failed
                  ? TransactionStatus.failed
                  : TransactionStatus.unknown,
      type: TransactionType.lightningPayment,
      feeAmountSat: payment.feeMsat ~/ 1000,
      description: payment.description,
      destinationPubkey: details.data.destinationPubkey,
      paymentPreimage: details.data.paymentPreimage,
      keysend: details.data.keysend,
      bolt11: details.data.bolt11,
      lnurlSuccessAction: details.data.lnurlSuccessAction == null
          ? null
          : LnurlSuccessAction(
              description:
                  details.data.lnurlSuccessAction is SuccessActionProcessed_Aes
                      ? ((details.data.lnurlSuccessAction!
                                  as SuccessActionProcessed_Aes)
                              .result as AesSuccessActionDataResult_Decrypted)
                          .data
                          .description
                      : details.data.lnurlSuccessAction
                              is SuccessActionProcessed_Url
                          ? (details.data.lnurlSuccessAction!
                                  as SuccessActionProcessed_Url)
                              .data
                              .description
                          : null,
              plaintext:
                  details.data.lnurlSuccessAction is SuccessActionProcessed_Aes
                      ? ((details.data.lnurlSuccessAction!
                                  as SuccessActionProcessed_Aes)
                              .result as AesSuccessActionDataResult_Decrypted)
                          .data
                          .plaintext
                      : null,
              message: details.data.lnurlSuccessAction
                      is SuccessActionProcessed_Message
                  ? (details.data.lnurlSuccessAction!
                          as SuccessActionProcessed_Message)
                      .data
                      .message
                  : null,
              url: details.data.lnurlSuccessAction is SuccessActionProcessed_Url
                  ? (details.data.lnurlSuccessAction!
                          as SuccessActionProcessed_Url)
                      .data
                      .url
                  : null,
            ),
      lnAddress: details.data.lnAddress,
      lnurlMetadata: details.data.lnurlMetadata,
      lnurlWithdrawEndpoint: details.data.lnurlWithdrawEndpoint,
    );
  }
}

class GetSwapInInfoException implements Exception {
  GetSwapInInfoException(this.message);

  final String message;
}

class GetChannelOpeningFeeEstimateException implements Exception {
  GetChannelOpeningFeeEstimateException(this.message);

  final String message;
}
