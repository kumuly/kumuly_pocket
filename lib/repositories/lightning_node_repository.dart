import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/recommended_fees_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
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
  Stream<int?> get spendableBalanceMsat;
  Stream<int?> get onChainBalanceMsat;
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
  Future<void> payInvoice({required String bolt11, int? amountMsat});
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
  Future<void> disconnect();
}

class BreezeSdkLightningNodeRepository implements LightningNodeRepository {
  BreezeSdkLightningNodeRepository(
    this._breezSdk,
  );

  final BreezSDK _breezSdk;

  @override
  Stream<int?> get spendableBalanceMsat {
    return _breezSdk.nodeStateStream.map(
      (nodeState) => nodeState?.maxPayableMsat,
    );
  }

  @override
  Stream<int?> get onChainBalanceMsat {
    return _breezSdk.nodeStateStream.map(
      (nodeState) => nodeState?.onchainBalanceMsat,
    );
  }

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
    final response = await _breezSdk.signMessage(request: request);
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
        await _breezSdk.receivePayment(request: paymentRequest);
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
  Future<void> payInvoice({required String bolt11, int? amountMsat}) async {
    await _breezSdk.sendPayment(bolt11: bolt11, amountMsat: amountMsat);

    //await _breezSdk.sendPayment(bolt11: bolt11, amountSats: amountSats);
  }

  @override
  Future<void> sendToKey(String nodeId, int amountSat) async {
    await _breezSdk.sendSpontaneousPayment(
        nodeId: nodeId, amountSats: amountSat);
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
        await _breezSdk.receiveOnchain(reqData: const ReceiveOnchainRequest());

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

    await _breezSdk.sendOnchain(
      onchainRecipientAddress: destinationAddress,
      amountSat: amountSat,
      satPerVbyte: satPerVbyte,
      pairHash: currentFees.feesHash,
    );
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
}
