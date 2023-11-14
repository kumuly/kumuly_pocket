import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/view_models/notifications.dart';

@immutable
class PocketModeMenuState extends Equatable {
  const PocketModeMenuState({
    required this.nodeId,
    required this.notifications,
    required this.bitcoinUnit,
    required this.localCurrency,
    this.location,
    this.isLocationEnabled = false,
    this.lastSeedBackupDate,
    this.lastStaticChannelBackupDate,
    required this.version,
  });

  final String nodeId;
  final List<Notification> notifications;
  final BitcoinUnit bitcoinUnit;
  final LocalCurrency localCurrency;
  final String? location; // Todo: change to Location type
  final bool? isLocationEnabled;
  final DateTime? lastSeedBackupDate;
  final DateTime? lastStaticChannelBackupDate;
  final String version;

  PocketModeMenuState copyWith({
    String? nodeId,
    List<Notification>? notifications,
    BitcoinUnit? bitcoinUnit,
    LocalCurrency? localCurrency,
    String? location,
    bool? isLocationEnabled,
    DateTime? lastSeedBackupDate,
    DateTime? lastStaticChannelBackupDate,
    String? version,
  }) {
    return PocketModeMenuState(
      nodeId: nodeId ?? this.nodeId,
      notifications: notifications ?? this.notifications,
      bitcoinUnit: bitcoinUnit ?? this.bitcoinUnit,
      localCurrency: localCurrency ?? this.localCurrency,
      location: location ?? this.location,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      lastSeedBackupDate: lastSeedBackupDate ?? this.lastSeedBackupDate,
      lastStaticChannelBackupDate:
          lastStaticChannelBackupDate ?? this.lastStaticChannelBackupDate,
      version: version ?? this.version,
    );
  }

  String get partialNodeId =>
      '${nodeId.substring(0, 8)}...${nodeId.substring(nodeId.length - 8)}';

  @override
  List<Object?> get props => [
        nodeId,
        notifications,
        bitcoinUnit,
        localCurrency,
        location,
        isLocationEnabled,
        lastSeedBackupDate,
        lastStaticChannelBackupDate,
        version,
      ];
}
