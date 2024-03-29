import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/bip21_entity.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/keysend_payment_details_entity.dart';
import 'package:kumuly_pocket/entities/lnurl_pay_entity.dart';
import 'package:kumuly_pocket/entities/paid_invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_request_entity.dart';
import 'package:kumuly_pocket/entities/recommended_fees_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lightning_node_repository.g.dart';

@riverpod
LightningNodeRepository breezeSdkLightningNodeRepository(
  BreezeSdkLightningNodeRepositoryRef ref,
) {
  return BreezeSdkLightningNodeRepository(
    ref.watch(breezSdkProvider),
  );
}

abstract class LightningNodeRepository {
  Future<String> get nodeId;
  Future<int> get spendableBalanceMsat;
  Future<int> get onChainBalanceMsat;
  Future<int> get inboundLiquidityMsat;
  Future<RecommendedFeesEntity> get recommendedFees;
  Stream<PaidInvoiceEntity> get paidInvoiceStream;
  Future<SwapInfoEntity?> get inProgressSwap;
  Future<String> connect(
    Uint8List seed,
    AppNetwork network,
    String apiKey,
    String workingDir, {
    String? inviteCode,
    String? partnerCredentials,
  });
  Future<String> signMessage(String message);
  Future<InvoiceEntity> createInvoice({
    required int amountMsat,
    String? description,
    int? expiry,
  });
  Future<InvoiceEntity> decodeInvoice(String invoice);
  Future<PaymentRequestEntity> decodePaymentRequest(String paymentRequest);
  Future<void> payInvoice(
      {required String bolt11, int? amountMsat}); // Todo: add return type
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountMsat, {
    String? comment,
    bool useMinimumAmount,
  }); // Todo: add return type
  Future<KeysendPaymentDetailsEntity> keysend(
    String nodeId,
    int amountMsat,
  ); // Todo: add return type
  Future<int> estimateChannelOpeningFeeMsat(int amountSat);
  Future<SwapInfoEntity> swapIn();
  Future<void> swapOut(
    String destinationAddress,
    int amountSat,
    int satPerVbyte,
  );
  Future<void> disconnect();
}

class BreezeSdkLightningNodeRepository implements LightningNodeRepository {
  BreezeSdkLightningNodeRepository(
    this._breezSdk,
  );

  final BreezSDK _breezSdk;

  @override
  Future<String> get nodeId async => _breezSdk.nodeInfo().then(
        (nodeInfo) => nodeInfo?.id ?? '',
      );

  @override
  Future<int> get spendableBalanceMsat => _breezSdk.nodeInfo().then(
        (nodeInfo) => nodeInfo?.maxPayableMsat ?? 0,
      );

  @override
  Future<int> get onChainBalanceMsat => _breezSdk.nodeInfo().then(
        (nodeInfo) => nodeInfo?.onchainBalanceMsat ?? 0,
      );

  @override
  Future<RecommendedFeesEntity> get recommendedFees async {
    final response = await _breezSdk.recommendedFees();
    return RecommendedFeesEntity(
      fastest: response.fastestFee,
      fast: response.halfHourFee,
      medium: response.hourFee,
      slow: response.economyFee,
      cheapest: response.minimumFee,
    );
  }

  @override
  Stream<PaidInvoiceEntity> get paidInvoiceStream =>
      _breezSdk.invoicePaidStream.map(
        (event) => PaidInvoiceEntity(
          bolt11: event.bolt11,
          paymentHash: event.paymentHash,
          amountSat: event.payment!.amountMsat ~/ 1000,
        ),
      );

  @override
  Future<SwapInfoEntity?> get inProgressSwap async {
    SwapInfo? swap = await _breezSdk.inProgressSwap();

    print('swap in progress: $swap');

    if (swap == null) {
      return null;
    }

    return SwapInfoEntity(
      swap.bitcoinAddress,
      swap.maxAllowedDeposit,
      swap.minAllowedDeposit,
      String.fromCharCodes(swap.paymentHash),
      swap.paidMsat ~/ 1000,
    );
  }

  @override
  Future<String> connect(
    Uint8List seed,
    AppNetwork network,
    String apiKey,
    String workingDir, {
    String? inviteCode,
    String? partnerCredentials,
  }) async {
    print('Connecting to Breez node with seed: $seed');
    try {
      NodeConfig nodeConfig = NodeConfig.greenlight(
        config: GreenlightNodeConfig(
          partnerCredentials: null,
          inviteCode: inviteCode,
        ),
      );
      Config config = await _breezSdk.defaultConfig(
        envType: network.breezSdkEnvironmentType,
        apiKey: apiKey,
        nodeConfig: nodeConfig,
      );
      // Change the necesarry default config settings
      config = config.copyWith(workingDir: workingDir);

      // Connect
      await _breezSdk.connect(config: config, seed: seed);
      // Connect to an LSP
      String? lspId = await _breezSdk.lspId();
      // Todo: organize code so that the LSP might be down,
      // but at least the node can be connected and it doesn't prevent the user of using the app
      if (lspId == null) {
        throw Exception('Failed to obtain LSP id');
      }
      _breezSdk.connectLSP(lspId);

      final nodeInfo = await _breezSdk.nodeInfo();
      if (nodeInfo == null) {
        throw Exception('Failed to obtain Breez node info');
      }

      final nodeId = nodeInfo.id;

      return nodeId;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to initialize Breez node: $e');
    }
  }

  @override
  Future<String> signMessage(String message) async {
    final request = SignMessageRequest(message: message);
    final response = await _breezSdk.signMessage(req: request);
    return response.signature;
  }

  @override
  Future<InvoiceEntity> createInvoice({
    required int amountMsat,
    String? description,
    int? expiry,
  }) async {
    final paymentRequest = ReceivePaymentRequest(
      amountMsat: amountMsat,
      description: description ?? '',
      expiry: expiry,
    );
    final receivePaymentResponse =
        await _breezSdk.receivePayment(req: paymentRequest);
    return InvoiceEntity(
      bolt11: receivePaymentResponse.lnInvoice.bolt11,
      payeePubkey: receivePaymentResponse.lnInvoice.payeePubkey,
      paymentHash: receivePaymentResponse.lnInvoice.paymentHash,
      description: receivePaymentResponse.lnInvoice.description,
      descriptionHash: receivePaymentResponse.lnInvoice.descriptionHash,
      amountMsat: receivePaymentResponse.lnInvoice.amountMsat,
      timestamp: receivePaymentResponse.lnInvoice.timestamp,
      expiry: receivePaymentResponse.lnInvoice.expiry,
      routingHints: receivePaymentResponse.lnInvoice.routingHints,
      paymentSecret: receivePaymentResponse.lnInvoice.paymentSecret,
      openingFeeParams: receivePaymentResponse.openingFeeParams,
      openingFeeMsat: receivePaymentResponse.openingFeeMsat,
    );
  }

  @override
  Future<PaymentRequestEntity> decodePaymentRequest(
    String paymentRequest,
  ) async {
    try {
      InputType inputType = await _breezSdk.parseInput(input: paymentRequest);

      if (inputType is InputType_LnUrlPay) {
        return PaymentRequestEntity(
            type: PaymentRequestType.lnurlPay,
            lnurlPay: LnurlPayEntity(
              lnurl: paymentRequest,
              minSendableSat: inputType.data.minSendable ~/ 1000,
              maxSendableSat: inputType.data.maxSendable ~/ 1000,
              metadata: inputType.data.metadataStr,
            ));
      } else if (inputType is InputType_Bolt11) {
        return PaymentRequestEntity(
          type: PaymentRequestType.bolt11,
          invoice: InvoiceEntity(
            bolt11: inputType.invoice.bolt11,
            payeePubkey: inputType.invoice.payeePubkey,
            paymentHash: inputType.invoice.paymentHash,
            description: inputType.invoice.description,
            descriptionHash: inputType.invoice.descriptionHash,
            amountMsat: inputType.invoice.amountMsat,
            timestamp: inputType.invoice.timestamp,
            expiry: inputType.invoice.expiry,
            routingHints: inputType.invoice.routingHints,
            paymentSecret: inputType.invoice.paymentSecret,
            minFinalCltvExpiryDelta: inputType.invoice.minFinalCltvExpiryDelta,
          ),
        );
      } else if (inputType is InputType_NodeId) {
        return PaymentRequestEntity(
            type: PaymentRequestType.nodeId, nodeId: inputType.nodeId);
      } else if (inputType is InputType_BitcoinAddress) {
        if (inputType.address.amountSat == null &&
            inputType.address.label == null &&
            inputType.address.message == null) {
          return PaymentRequestEntity(
              type: PaymentRequestType.bitcoinAddress,
              bitcoinAddress: inputType.address.address);
        }
        return PaymentRequestEntity(
          type: PaymentRequestType.bip21,
          bip21: Bip21Entity(
            bitcoin: inputType.address.address,
            amountSat: inputType.address.amountSat,
            label: inputType.address.label,
            message: inputType.address.message,
          ),
        );
      } else {
        throw Exception('Unsupported payment request type');
      }
    } catch (error) {
      // Todo: make custom error
      rethrow;
    }
  }

  @override
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountMsat, {
    String? comment,
    bool useMinimumAmount =
        false, // For fixed amount links, specify a bit more in amountMsat and set this to true, to avoid the error of amount being too low when price changes rapidly
  }) async {
    InputType inputType = await _breezSdk.parseInput(input: paymentLink);
    if (inputType is! InputType_LnUrlPay) {
      throw LnUrlPayInvalidLink();
    }

    if (amountMsat < inputType.data.minSendable) {
      throw LnUrlPayMinAmount(inputType.data.minSendable.toString());
    }

    if (!useMinimumAmount && amountMsat > inputType.data.maxSendable) {
      throw LnUrlPayMaxAmount(inputType.data.maxSendable.toString());
    }

    print("PAYING LNURLPAY");
    LnUrlPayResult result = await _breezSdk.lnurlPay(
      req: LnUrlPayRequest(
        data: inputType.data,
        amountMsat: useMinimumAmount ? inputType.data.minSendable : amountMsat,
        comment: comment,
      ),
    );
    print('Payment result: $result');
    if (result is LnUrlPayResult_EndpointError) {
      print('Endpoint error: ${result.data.reason}');
      throw LnUrlPayFailure(result.data.reason);
    }
    if (result is LnUrlPayResult_PayError) {
      print('Pay error: ${result.data.reason}');
      ReportIssueRequest req = ReportIssueRequest.paymentFailure(
        data: ReportPaymentFailureDetails(
          paymentHash: result.data.paymentHash,
        ),
      );
      print('Reporting issue for hash: ${result.data.paymentHash}');
      await BreezSDK().reportIssue(req: req);
      print('Issue reported');
      throw LnUrlPayFailure(result.data.reason);
    }

    if (result is LnUrlPayResult_EndpointSuccess) {
      print('Endpoint success SuccessActionProcessesed data: ${result.data}');
      print(
          'Endpoint success SuccessActionProcessesed data data: ${result.data.successAction}');
      print('Paymenthash: ${result.data.paymentHash}');
    }

    print('LNURLPAY Payment successful');
  }

  @override
  Future<void> payInvoice({required String bolt11, int? amountMsat}) async {
    final request = SendPaymentRequest(
      bolt11: bolt11,
      amountMsat: amountMsat,
    );

    try {
      await _breezSdk.sendPayment(req: request);
    } catch (e) {
      print('$e');
      final invoice = await decodeInvoice(bolt11);
      ReportIssueRequest req = ReportIssueRequest.paymentFailure(
        data: ReportPaymentFailureDetails(
          paymentHash: invoice.paymentHash,
        ),
      );
      print('Reporting issue for hash: ${invoice.paymentHash}');
      await BreezSDK().reportIssue(req: req);
      print('Issue reported');
      rethrow;
    }
  }

  @override
  Future<KeysendPaymentDetailsEntity> keysend(
    String nodeId,
    int amountMsat,
  ) async {
    final request =
        SendSpontaneousPaymentRequest(nodeId: nodeId, amountMsat: amountMsat);
    final response = await _breezSdk.sendSpontaneousPayment(req: request);

    if (response.payment.details is PaymentDetails_Ln) {
      PaymentDetails_Ln details = response.payment.details as PaymentDetails_Ln;
      return KeysendPaymentDetailsEntity(
        paymentHash: details.data.paymentHash,
        paymentTime: response.payment.paymentTime,
      );
    } else {
      throw Exception('Unexpected payment details type');
    }
  }

  @override
  Future<int> estimateChannelOpeningFeeMsat(int amountSat) async {
    try {
      final req = OpenChannelFeeRequest(
        amountMsat: amountSat * 1000,
      );
      final response = await _breezSdk.openChannelFee(req: req);
      return response.feeMsat ?? 0;
    } catch (e) {
      print(e);
      throw EstimateChannelOpeningFeeException(e.toString());
    }
  }

  @override
  Future<SwapInfoEntity> swapIn() async {
    try {
      final swapInfo =
          await _breezSdk.receiveOnchain(req: const ReceiveOnchainRequest());

      print('swap info generated: $swapInfo');
      return SwapInfoEntity(
        swapInfo.bitcoinAddress,
        swapInfo.maxAllowedDeposit,
        swapInfo.minAllowedDeposit,
        String.fromCharCodes(swapInfo.paymentHash),
        swapInfo.paidMsat ~/ 1000,
      );
    } catch (e) {
      print(e);
      throw SwapInException(e.toString());
    }
  }

  @override
  Future<void> swapOut(
    String destinationAddress,
    int amountSat,
    int satPerVbyte,
  ) async {
    final reverseSwapFeesRequest = ReverseSwapFeesRequest(
      sendAmountSat: amountSat,
    );
    ReverseSwapPairInfo currentFees = await _breezSdk.fetchReverseSwapFees(
      req: reverseSwapFeesRequest,
    );
    final request = SendOnchainRequest(
      onchainRecipientAddress: destinationAddress,
      amountSat: amountSat,
      satPerVbyte: satPerVbyte,
      pairHash: currentFees.feesHash,
    );
    await _breezSdk.sendOnchain(req: request);
  }

  @override
  Future<void> disconnect() async {
    await _breezSdk.disconnect();
  }

  @override
  Future<int> get inboundLiquidityMsat => _breezSdk.nodeStateStream
      .map(
        (nodeState) => nodeState?.inboundLiquidityMsats ?? 0,
      )
      .first;

  @override
  Future<InvoiceEntity> decodeInvoice(String bolt11) async {
    LNInvoice invoice = await _breezSdk.parseInvoice(bolt11);

    return InvoiceEntity(
      bolt11: invoice.bolt11,
      payeePubkey: invoice.payeePubkey,
      paymentHash: invoice.paymentHash,
      description: invoice.description,
      descriptionHash: invoice.descriptionHash,
      amountMsat: invoice.amountMsat,
      timestamp: invoice.timestamp,
      expiry: invoice.expiry,
      routingHints: invoice.routingHints,
      paymentSecret: invoice.paymentSecret,
      minFinalCltvExpiryDelta: invoice.minFinalCltvExpiryDelta,
    );
  }
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

class SwapInException implements Exception {
  SwapInException(this.message);

  final String message;
}

class EstimateChannelOpeningFeeException implements Exception {
  EstimateChannelOpeningFeeException(this.message);

  final String message;
}
