import 'package:equatable/equatable.dart';
import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/enums/time_unit.dart';

class Account extends Equatable {
  const Account({
    required this.alias,
    required this.nodeId,
    this.lastLogin,
  });

  final String alias;
  final String nodeId;
  final DateTime? lastLogin;

  // from account_entity
  factory Account.fromAccountEntity(AccountEntity accountEntity) {
    return Account(
      alias: accountEntity.alias,
      nodeId: accountEntity.nodeId,
      lastLogin: accountEntity.lastLogin,
    );
  }

  /// Empty account which represents an unauthenticated account.
  static const empty = Account(
    alias: '',
    nodeId: '',
  );

  /// Convenience getter to determine whether the current account is empty.
  bool get isEmpty => this == Account.empty;

  /// Convenience getter to determine whether the current account is not empty.
  bool get isNotEmpty => this != Account.empty;

  /// Get the 5 first and 5 last characters of the node id with ellipsis in the
  ///   middle for display purposes.
  String get partialNodeId =>
      '${nodeId.substring(0, 5)}...${nodeId.substring(nodeId.length - 5)}';

  (int?, TimeUnit?) get timeSinceLastLogin {
    if (lastLogin == null) {
      return (null, null);
    } else {
      final now = DateTime.now();
      final difference = now.difference(lastLogin!);
      final days = difference.inDays;
      final hours = difference.inHours;
      final minutes = difference.inMinutes;
      final seconds = difference.inSeconds;

      if (days > 0) {
        return (days, TimeUnit.days);
      } else if (hours > 0) {
        return (hours, TimeUnit.hours);
      } else if (minutes > 0) {
        return (minutes, TimeUnit.minutes);
      } else {
        return (seconds, TimeUnit.seconds);
      }
    }
  }

  @override
  List<Object?> get props => [alias, nodeId, lastLogin];
}
