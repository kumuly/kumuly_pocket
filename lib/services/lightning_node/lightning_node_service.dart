import 'dart:async';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/keysend_payment_details_entity.dart';
import 'package:kumuly_pocket/entities/paid_invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/entities/payment_request_entity.dart';
import 'package:kumuly_pocket/entities/swap_in_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/on_chain_fee_velocity.dart';

abstract class LightningNodeService {
  Future<String> get nodeId;
  Stream<int> get onChainBalanceSatStream;
  Stream<int> get channelsBalanceSatStream;
  Future<List<SwapInEntity>> get swapInsInProgress;
  Future<int> get inboundLiquiditySat;
  Stream<PaidInvoiceEntity> get paidInvoiceStream;
  Stream<SwapInfoEntity> inProgressSwapPolling(Duration interval);
  Future<String> drainOnChainFunds();
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
  Future<InvoiceEntity> decodeInvoice(String invoice);
  Future<PaymentRequestEntity> decodePaymentRequest(String paymentRequest);
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
  Future<String> signMessage(String message);
}

class GetSwapInInfoException implements Exception {
  GetSwapInInfoException(this.message);

  final String message;
}

class GetChannelOpeningFeeEstimateException implements Exception {
  GetChannelOpeningFeeEstimateException(this.message);

  final String message;
}

/// Thrown when an input is an invalid LnUrlPay link.
class LnUrlPayInvalidLink implements Exception {}

/// Thrown when the amount is less than the minimum sendable amount when paying a LNURLPay.
/// The error message is the minimum amount.
class LnUrlPayMinAmount implements Exception {
  LnUrlPayMinAmount(this.message);

  final String message;
}

/// Thrown when the amount is greater than the maximum sendable amount when paying a LNURLPay.
/// The error message is the maximum amount.
class LnUrlPayMaxAmount implements Exception {
  LnUrlPayMaxAmount(this.message);

  final String message;
}

/// Thrown when paying an LnUrlPay fails.
/// The error message is the reason for the failure.
class LnUrlPayFailure implements Exception {
  LnUrlPayFailure(this.message);

  final String message;
}
