import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/entities/payment_request_entity.dart';
import 'package:kumuly_pocket/entities/recommended_fees_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/lightning_channel_state.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/enums/payment_status.dart' as enums;
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
  Future<int> get spendableBalanceMsat;
  Future<int> get onChainBalanceMsat;
  Future<int> get inboundLiquidityMsat;
  Future<RecommendedFeesEntity> get recommendedFees;
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
    Uint8List? preimage,
    OpeningFeeParams? openingFeeParams,
    bool? useDescriptionHash,
    int? expiry,
    int? cltv,
  });
  Future<PaymentRequestEntity> decodePaymentRequest(String paymentRequest);
  Future<void> payInvoice({required String bolt11, int? amountMsat});
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountMsat,
    String? comment,
  );
  Future<void> sendToKey(
    String nodeId,
    int amountSat,
  );
  Future<int> estimateChannelOpeningFeeMsat(int amountSat);
  Future<SwapInfoEntity> swapIn();
  Future<void> swapOut(
    String destinationAddress,
    int amountSat,
    int satPerVbyte,
  );
  Future<List<PaymentEntity>> getPayments({
    PaymentDirection? direction,
    int? fromTimestamp,
    int? toTimestamp,
    bool? includeFailures,
    int? offset,
    int? limit,
  });
  Future<void> disconnect();
}

class BreezeSdkLightningNodeRepository implements LightningNodeRepository {
  BreezeSdkLightningNodeRepository(
    this._breezSdk,
  );

  final BreezSDK _breezSdk;

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
  Future<String> connect(
    Uint8List seed,
    AppNetwork network,
    String apiKey,
    String workingDir, {
    String? inviteCode,
    String? partnerCredentials,
  }) async {
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
    Uint8List? preimage,
    OpeningFeeParams? openingFeeParams,
    bool? useDescriptionHash,
    int? expiry,
    int? cltv,
  }) async {
    final paymentRequest = ReceivePaymentRequest(
      amountMsat: amountMsat,
      description: description ?? '',
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
      String paymentRequest) async {
    try {
      InputType inputType = await _breezSdk.parseInput(input: paymentRequest);
      int? amountSat;
      int amountMsat = 0;
      int? maxAmountSat;
      String? description;
      String? nodeId;
      String? bitcoinAddress;

      if (inputType is InputType_LnUrlPay) {
        amountMsat = inputType.data.minSendable;
        maxAmountSat = inputType.data.maxSendable ~/ 1000;
        print('lnurlpay metadataStr: ${inputType.data.metadataStr}');
      } else if (inputType is InputType_Bolt11) {
        amountMsat = inputType.invoice.amountMsat ?? 0;
        description = inputType.invoice.description;
      } else if (inputType is InputType_NodeId) {
        nodeId = inputType.nodeId;
      } else if (inputType is InputType_BitcoinAddress) {
        amountSat = inputType.address.amountSat;
        bitcoinAddress = inputType.address.address;
      } else {
        throw Exception('Unsupported payment request type');
      }

      return PaymentRequestEntity(
        type: PaymentRequestType.lnurlPay,
        amountSat: amountSat ?? amountMsat ~/ 1000,
        maxAmountSat: maxAmountSat,
        description: description,
        nodeId: nodeId,
        bitcoinAddress: bitcoinAddress,
      );
    } catch (error) {
      // Todo: make custom error
      rethrow;
    }
  }

  @override
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountMsat,
    String? comment,
  ) async {
    InputType inputType = await _breezSdk.parseInput(input: paymentLink);
    if (inputType is! InputType_LnUrlPay) {
      throw LnUrlPayInvalidLink();
    }

    if (amountMsat < inputType.data.minSendable) {
      //
      throw LnUrlPayMinAmount(inputType.data.minSendable.toString());
    }

    if (amountMsat > inputType.data.maxSendable) {
      throw LnUrlPayMaxAmount(inputType.data.maxSendable.toString());
    }

    print("PAYING LNURLPAY");
    LnUrlPayResult result = await _breezSdk.lnurlPay(
      req: LnUrlPayRequest(
        data: inputType.data,
        amountMsat: amountMsat,
        comment: comment,
      ),
    );
    print('Payment result: $result');
    if (result is LnUrlPayResult_EndpointError) {
      throw LnUrlPayFailure(result.data.reason);
    }

    if (result is LnUrlPayResult_EndpointSuccess) {
      print('Endpoint success SuccessActionProcessesed data: ${result.data}');
      print(
          'Endpoint success SuccessActionProcessesed data data: ${result.data?.data}');
    }

    print('LNURLPAY Payment successful');
  }

  @override
  Future<void> payInvoice({required String bolt11, int? amountMsat}) async {
    final request = SendPaymentRequest(
      bolt11: bolt11,
      amountMsat: amountMsat,
    );
    await _breezSdk.sendPayment(req: request);

    //await _breezSdk.sendPayment(bolt11: bolt11, amountSats: amountSats);
  }

  @override
  Future<void> sendToKey(String nodeId, int amountMsat) async {
    final request =
        SendSpontaneousPaymentRequest(nodeId: nodeId, amountMsat: amountMsat);
    await _breezSdk.sendSpontaneousPayment(req: request);
  }

  @override
  Future<int> estimateChannelOpeningFeeMsat(int amountSat) async {
    /* final response = await _breezSdk.openChannelFee(
        amountMsat: amountSat * 1000,
    );
    return response.feeMsat;*/
    return 0;
  }

  @override
  Future<SwapInfoEntity> swapIn() async {
    final swapInfo =
        await _breezSdk.receiveOnchain(req: const ReceiveOnchainRequest());

    return SwapInfoEntity(
      swapInfo.bitcoinAddress,
      swapInfo.maxAllowedDeposit,
      swapInfo.minAllowedDeposit,
      swapInfo.channelOpeningFees?.proportional,
      swapInfo.channelOpeningFees?.validUntil,
    );
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
  Future<List<PaymentEntity>> getPayments({
    PaymentDirection? direction,
    int? fromTimestamp,
    int? toTimestamp,
    bool? includeFailures,
    int? offset,
    int? limit,
  }) async {
    PaymentTypeFilter? filter = direction == null
        ? PaymentTypeFilter.All
        : direction == PaymentDirection.incoming
            ? PaymentTypeFilter.Received
            : PaymentTypeFilter.Sent;
    ListPaymentsRequest req = ListPaymentsRequest(
      filter: filter,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
      includeFailures: includeFailures,
      offset: offset,
      limit: limit,
    );
    List<Payment> payments = await _breezSdk.listPayments(req: req);
    return payments.map((payment) {
      if (payment.details is PaymentDetails_Ln) {
        PaymentDetails_Ln details = payment.details as PaymentDetails_Ln;

        return PaymentEntity(
          id: payment.id,
          direction: payment.paymentType == PaymentType.Received
              ? PaymentDirection.incoming
              : PaymentDirection.outgoing,
          paymentTime: payment.paymentTime,
          amountMsat: payment.amountMsat,
          feeMsat: payment.feeMsat,
          status: payment.status == PaymentStatus.Complete
              ? enums.PaymentStatus.complete
              : payment.status == PaymentStatus.Failed
                  ? enums.PaymentStatus.failed
                  : enums.PaymentStatus.pending,
          description: payment.description,
          lightningPaymentDetails: LightningPaymentDetailsEntity(
            paymentHash: details.data.paymentHash,
            label: details.data.label,
            destinationPubkey: details.data.destinationPubkey,
            paymentPreimage: details.data.paymentPreimage,
            keysend: details.data.keysend,
            bolt11: details.data.bolt11,
            lnurlSuccessAction: LnurlSuccessAction(
              description:
                  details.data.lnurlSuccessAction is SuccessActionProcessed_Aes
                      ? (details.data.lnurlSuccessAction!.data
                              as SuccessActionProcessed_Aes)
                          .data
                          .description
                      : details.data.lnurlSuccessAction
                              is SuccessActionProcessed_Url
                          ? (details.data.lnurlSuccessAction!.data
                                  as SuccessActionProcessed_Url)
                              .data
                              .description
                          : null,
              plaintext:
                  details.data.lnurlSuccessAction is SuccessActionProcessed_Aes
                      ? (details.data.lnurlSuccessAction!.data
                              as SuccessActionProcessed_Aes)
                          .data
                          .plaintext
                      : null,
              message: details.data.lnurlSuccessAction
                      is SuccessActionProcessed_Message
                  ? (details.data.lnurlSuccessAction!.data
                          as SuccessActionProcessed_Message)
                      .data
                      .message
                  : null,
              url: details.data.lnurlSuccessAction is SuccessActionProcessed_Url
                  ? (details.data.lnurlSuccessAction!.data
                          as SuccessActionProcessed_Url)
                      .data
                      .url
                  : null,
            ),
            lnAddress: details.data.lnAddress,
            lnurlMetadata: details.data.lnurlMetadata,
            lnurlWithdrawEndpoint: details.data.lnurlWithdrawEndpoint,
          ),
        );
      }

      PaymentDetails_ClosedChannel details =
          payment.details as PaymentDetails_ClosedChannel;

      return PaymentEntity(
        id: payment.id,
        direction: payment.paymentType == PaymentType.Received
            ? PaymentDirection.incoming
            : PaymentDirection.outgoing,
        paymentTime: payment.paymentTime,
        amountMsat: payment.amountMsat,
        feeMsat: payment.feeMsat,
        status: payment.status == PaymentStatus.Complete
            ? enums.PaymentStatus.complete
            : payment.status == PaymentStatus.Failed
                ? enums.PaymentStatus.failed
                : enums.PaymentStatus.pending,
        description: payment.description,
        closedChannelPaymentDetails: ClosedChannelPaymentDetailsEntity(
          shortChannelId: details.data.shortChannelId,
          state: details.data.state == ChannelState.Closed
              ? LightningChannelState.closed
              : details.data.state == ChannelState.Opened
                  ? LightningChannelState.opened
                  : details.data.state == ChannelState.PendingClose
                      ? LightningChannelState.pendingClose
                      : LightningChannelState.pendingOpen,
          fundingTxid: details.data.fundingTxid,
        ),
      );
    }).toList();
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
