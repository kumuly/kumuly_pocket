import 'dart:async';
import 'dart:io';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/bip21_entity.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/keysend_payment_details_entity.dart';
import 'package:kumuly_pocket/entities/lnurl_pay_entity.dart';
import 'package:kumuly_pocket/entities/paid_invoice_entity.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/entities/payment_request_entity.dart';
import 'package:kumuly_pocket/entities/recommended_fees_entity.dart';
import 'package:kumuly_pocket/entities/swap_in_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/on_chain_fee_velocity.dart';
import 'package:kumuly_pocket/enums/transaction_direction.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/enums/transaction_status.dart';
import 'package:kumuly_pocket/enums/transaction_type.dart';
import 'package:kumuly_pocket/environment_variables.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:kumuly_pocket/services/lightning_node/lightning_node_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_lightning_node_service.g.dart';

@Riverpod(keepAlive: true)
LightningNodeService breezeSdkLightningNodeService(
    BreezeSdkLightningNodeServiceRef ref) {
  final breezSdk = ref.watch(breezSdkProvider);
  return BreezSdkLightningNodeService(
    breezSdk,
  );
}

@riverpod
Future<int> spendableBalanceSat(SpendableBalanceSatRef ref) {
  final lightningNodeService = ref.watch(breezeSdkLightningNodeServiceProvider);
  return lightningNodeService.spendableBalanceSat;
}

class BreezSdkLightningNodeService implements LightningNodeService {
  BreezSdkLightningNodeService(this._breezSdk);

  final BreezSDK _breezSdk;

  @override
  Stream<int> get onChainBalanceSatStream => _breezSdk.nodeStateStream.map(
        (state) => state == null ? 0 : state.onchainBalanceMsat ~/ 1000,
      );

  @override
  Stream<int> get channelsBalanceSatStream => _breezSdk.nodeStateStream.map(
        (state) => state == null ? 0 : state.channelsBalanceMsat ~/ 1000,
      );

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
  Future<String> get nodeId async => _breezSdk.nodeInfo().then(
        (nodeInfo) => nodeInfo?.id ?? '',
      );

  @override
  Future<List<SwapInEntity>> get swapInsInProgress async {
    final swapInfo = await _breezSdk.inProgressSwap();

    print('---------------------------------------------');
    print('swapInfo: $swapInfo');

    if (swapInfo == null) {
      return [];
    }

    print('swapInfo.bitcoinAddress: ${swapInfo.bitcoinAddress}');
    print('swapInfo.createdAt: ${swapInfo.createdAt}');
    print('swapInfo.lockHeight: ${swapInfo.lockHeight}');
    print('swapInfo.paymentHash: ${hex.encode(swapInfo.paymentHash)}');
    print('swapInfo.preimage: ${swapInfo.preimage}');
    print('swapInfo.privateKey: ${swapInfo.privateKey}');
    print('swapInfo.publicKey: ${swapInfo.publicKey}');
    print('swapInfo.swapperPublicKey: ${swapInfo.swapperPublicKey}');
    print('swapInfo.script: ${swapInfo.script}');
    print('swapInfo.bolt11: ${swapInfo.bolt11}');
    print('swapInfo.paidMsat: ${swapInfo.paidMsat}');
    print('swapInfo.confirmedSats: ${swapInfo.confirmedSats}');
    print('swapInfo.unconfirmedSats: ${swapInfo.unconfirmedSats}');
    print('swapInfo.status: ${swapInfo.status}');
    print('swapInfo.refundTxIds: ${swapInfo.refundTxIds}');
    print('swapInfo.unconfirmedTxIds: ${swapInfo.unconfirmedTxIds}');
    print('swapInfo.confirmedTxIds: ${swapInfo.confirmedTxIds}');
    print('swapInfo.minAllowedDeposit: ${swapInfo.minAllowedDeposit}');
    print('swapInfo.maxAllowedDeposit: ${swapInfo.maxAllowedDeposit}');
    print('swapInfo.lastRedeemError: ${swapInfo.lastRedeemError}');
    print(
        'swapInfo.channelOpeningFees.validUntil: ${swapInfo.channelOpeningFees?.validUntil}');
    print(
        'swapInfo.channelOpeningFees.maxClientToSelfDelay: ${swapInfo.channelOpeningFees?.maxClientToSelfDelay}');
    print(
        'swapInfo.channelOpeningFees.maxIdleTime: ${swapInfo.channelOpeningFees?.maxIdleTime}');
    print(
        'swapInfo.channelOpeningFees.minMsat: ${swapInfo.channelOpeningFees?.minMsat}');
    print(
        'swapInfo.channelOpeningFees.promise: ${swapInfo.channelOpeningFees?.promise}');
    print(
        'swapInfo.channelOpeningFees.proportional: ${swapInfo.channelOpeningFees?.proportional}');
    print('---------------------------------------------');

    return [
      SwapInEntity(
        bitcoinAddress: swapInfo.bitcoinAddress,
        paymentHash: hex.encode(swapInfo.paymentHash),
        bolt11: swapInfo.bolt11,
        unconfirmedAmountSat:
            swapInfo.unconfirmedSats > 0 ? swapInfo.unconfirmedSats : null,
        confirmedAmountSat:
            swapInfo.confirmedSats > 0 ? swapInfo.confirmedSats : null,
        paidAmountSat: swapInfo.paidMsat > 0 ? swapInfo.paidMsat ~/ 1000 : null,
        txIds: swapInfo.confirmedTxIds,
      ),
    ];
  }

  @override
  Future<String> drainOnChainFunds() async {
    const prepReq = PrepareRedeemOnchainFundsRequest(
      toAddress:
          'bc1pdam46xm8ymzy9rs3ufffzl6dky5n5eygcy7dkzqqs6g8u8vuynxqcase8q',
      satPerVbyte: 40,
    );
    await _breezSdk.prepareRedeemOnchainFunds(req: prepReq);
    const req = RedeemOnchainFundsRequest(
      toAddress:
          'bc1pdam46xm8ymzy9rs3ufffzl6dky5n5eygcy7dkzqqs6g8u8vuynxqcase8q',
      satPerVbyte: 40,
    );
    final res = await _breezSdk.redeemOnchainFunds(req: req);
    print('Redeem txID: ${res.txid}');
    return hex.encode(res.txid);
  }

  Future<void> printNodeInfo() async {
    final nodeInfo = await _breezSdk.nodeInfo();
    print('Node info: $nodeInfo');
    print('channelsBalanceMsat: ${nodeInfo!.channelsBalanceMsat ~/ 1000}');
    print('onchainBalanceMsat: ${nodeInfo.onchainBalanceMsat ~/ 1000}');
    print(
        'pendingOnchainBalanceMsat: ${nodeInfo.pendingOnchainBalanceMsat ~/ 1000}');
    nodeInfo.utxos.forEach((element) {
      print('utxo:${hex.encode(element.txid)}');
    });
    print('maxPayableMsat: ${nodeInfo.maxPayableMsat ~/ 1000}');
    print('maxReceivableMsat: ${nodeInfo.maxReceivableMsat ~/ 1000}');
    print(
        'maxSinglePaymentAmountMsat: ${nodeInfo.maxSinglePaymentAmountMsat ~/ 1000}');
    print('maxChanReserveMsats: ${nodeInfo.maxChanReserveMsats ~/ 1000}');
    print('connectedPeers: ${nodeInfo.connectedPeers}');
    print('inboundLiquidityMsats: ${nodeInfo.inboundLiquidityMsats ~/ 1000}');
  }

  Future<bool> get isSwapInProgress async =>
      await _breezSdk.inProgressSwap() != null;

  @override
  Future<int> get inboundLiquiditySat => _breezSdk.nodeStateStream
      .map(
        (nodeState) =>
            nodeState == null ? 0 : nodeState.inboundLiquidityMsats ~/ 1000,
      )
      .first;

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
        apiKey: breezSdkApiKey,
        nodeConfig: nodeConfig,
      );
      // Change the necesarry default config settings
      config = config.copyWith(workingDir: path);

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

      print('Connected to node with nodeId: $nodeId');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to initialize Breez node: $e');
    }
  }

  @override
  Future<InvoiceEntity> createInvoice(
    int amountSat,
    String? description,
    int? expiry,
  ) async {
    final paymentRequest = ReceivePaymentRequest(
      amountMsat: amountSat * 1000,
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
  Future<void> payInvoice({required String bolt11, int? amountSat}) async {
    final amountMsat = amountSat == null ? null : amountSat * 1000;
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

  @override
  Future<void> swapOut(
    String bitcoinAddress,
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
      onchainRecipientAddress: bitcoinAddress,
      amountSat: amountSat,
      satPerVbyte: satPerVbyte,
      pairHash: currentFees.feesHash,
    );
    await _breezSdk.sendOnchain(req: request);
  }

  @override
  Future<int> getChannelOpeningFeeEstimate(int amountSat) async {
    try {
      final inbound = await inboundLiquiditySat;

      if (inbound <= amountSat) {
        final req = OpenChannelFeeRequest(
          amountMsat: amountSat * 1000,
        );
        final response = await _breezSdk.openChannelFee(req: req);
        return response.feeMsat == null ? 0 : response.feeMsat! ~/ 1000;
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
      final swapInfo =
          await _breezSdk.receiveOnchain(req: const ReceiveOnchainRequest());

      return SwapInfoEntity(
        swapInfo.bitcoinAddress,
        swapInfo.maxAllowedDeposit,
        swapInfo.minAllowedDeposit,
        String.fromCharCodes(swapInfo.paymentHash),
        swapInfo.paidMsat ~/ 1000,
      );
    } catch (e) {
      print(e);
      throw GetSwapInInfoException(e.toString());
    }
  }

  @override
  Future<int> get spendableBalanceSat => _breezSdk.nodeInfo().then(
        (nodeInfo) =>
            nodeInfo == null ? 0 : nodeInfo.channelsBalanceMsat ~/ 1000,
      );

  @override
  Future<int> get onChainBalanceSat => _breezSdk.nodeInfo().then(
        (nodeInfo) =>
            nodeInfo == null ? 0 : nodeInfo.onchainBalanceMsat ~/ 1000,
      );

  Future<void> printRefundables() async {
    final refundables = await _breezSdk.listRefundables();
    print('Refundables: ${refundables.length}');
    for (var refundable in refundables) {
      print('Refundable}');
      print('Swap address: ${refundable.bitcoinAddress}');
      print('Confirmed sats: ${refundable.confirmedSats} sat');
      print('Unconfirmed sats: ${refundable.unconfirmedSats} sat');
      print('Paid sats: ${refundable.paidMsat ~/ 1000} sat');
    }
  }

  @override
  // TODO: implement receptionAmountLimits
  //Future<ReceptionAmountLimits> get receptionAmountLimits =>
  //    throw UnimplementedError();

  @override
  Future<Map<OnChainFeeVelocity, int>> get recommendedFees async {
    final response = await _breezSdk.recommendedFees();
    return RecommendedFeesEntity(
      fastest: response.fastestFee,
      fast: response.halfHourFee,
      medium: response.hourFee,
      slow: response.economyFee,
      cheapest: response.minimumFee,
    ).toMap();
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
    await _breezSdk.disconnect();
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
  Future<(int? minAmountSat, int? maxAmountSat)> getLnurlPayAmounts(
    String paymentLink,
  ) async {
    try {
      final PaymentRequestEntity decodedRequest;

      InputType inputType = await _breezSdk.parseInput(input: paymentLink);

      if (inputType is InputType_LnUrlPay) {
        decodedRequest = PaymentRequestEntity(
            type: PaymentRequestType.lnurlPay,
            lnurlPay: LnurlPayEntity(
              lnurl: paymentLink,
              minSendableSat: inputType.data.minSendable ~/ 1000,
              maxSendableSat: inputType.data.maxSendable ~/ 1000,
              metadata: inputType.data.metadataStr,
            ));
      } else {
        // Todo: throw a custom error type exception.
        throw Exception('Not an LNURL pay link');
      }

      return (
        decodedRequest.lnurlPay!.minSendableSat,
        decodedRequest.lnurlPay!.maxSendableSat
      );
    } catch (e) {
      print(e);
      throw Exception('Failed to get LNURL pay amounts');
    }
  }

  @override
  Future<void> payLnUrlPay(
    String paymentLink,
    int amountSat, {
    String? comment,
    bool useMinimumAmount = false,
  }) async {
    final amountMsat = amountSat * 1000;
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
  Stream<SwapInfoEntity> inProgressSwapPolling(Duration interval) {
    // Use a StreamController to control the stream
    var controller = StreamController<SwapInfoEntity>();

    var timer = Timer.periodic(interval, (Timer t) async {
      SwapInfo? swap = await _breezSdk.inProgressSwap();

      print('swap in progress: $swap');

      if (swap != null) {
        controller.add(SwapInfoEntity(
          swap.bitcoinAddress,
          swap.maxAllowedDeposit,
          swap.minAllowedDeposit,
          String.fromCharCodes(swap.paymentHash),
          swap.paidMsat ~/ 1000,
        ));
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
  Future<KeysendPaymentDetailsEntity> keysend(
      String nodeId, int amountSat) async {
    final request = SendSpontaneousPaymentRequest(
        nodeId: nodeId, amountMsat: amountSat * 1000);
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

  @override
  Future<String> signMessage(String message) async {
    final request = SignMessageRequest(message: message);
    final response = await _breezSdk.signMessage(req: request);
    return response.signature;
  }
}
