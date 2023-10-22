import 'package:kumuly_pocket/entities/merchant_entity.dart';
import 'package:kumuly_pocket/repositories/merchant_repository.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'merchant_service.g.dart';

@riverpod
MerchantService firebaseMerchantService(FirebaseMerchantServiceRef ref) {
  final merchantRepository = ref.watch(firebaseMerchantRepositoryProvider);

  return FirebaseMerchantService(
    merchantRepository: merchantRepository,
  );
}

@riverpod
Stream<MerchantEntity?> connectedMerchant(ConnectedMerchantRef ref) {
  final connectedAccount = ref.watch(connectedAccountProvider);

  if (connectedAccount.asData?.value == null) {
    return Stream.value(null);
  }

  final id = connectedAccount.asData!.value.nodeId;
  final merchantService = ref.watch(firebaseMerchantServiceProvider);

  return merchantService.getMerchantStream(id);
}

abstract class MerchantService {
  Stream<MerchantEntity?> getMerchantStream(id);
  Future<void> createWalletAndMerchant(String nodeId, MerchantEntity merchant);
  Future<MerchantEntity?> getMerchant(String merchantId);
  Future<int> getMerchantWalletBalance(String merchantId);
}

class FirebaseMerchantService implements MerchantService {
  FirebaseMerchantService({required this.merchantRepository});

  final MerchantRepository merchantRepository;

  @override
  Stream<MerchantEntity?> getMerchantStream(id) {
    return merchantRepository.getMerchantEntityStream(id);
  }

  @override
  Future<void> createWalletAndMerchant(
    String nodeId,
    MerchantEntity merchant,
  ) async {
    await merchantRepository.createMerchantWallet(nodeId);
    // Todo: upload logo to firebase storage and get the url
    const logoUrl = '';
    await merchantRepository.registerMerchant(
      id: nodeId,
      merchant: merchant,
    );
  }

  @override
  Future<MerchantEntity?> getMerchant(String nodeId) async {
    return merchantRepository.get(nodeId);
  }

  @override
  Future<int> getMerchantWalletBalance(String merchantId) async {
    final balance =
        await merchantRepository.getMerchantWalletBalance(merchantId);
    return balance;
  }
}
