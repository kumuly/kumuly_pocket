import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/payment.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({
    super.key,
    required this.title,
    required this.payments,
    required this.loadPayments,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final String title;
  final List<Payment> payments;
  final Future<void> Function({bool refresh}) loadPayments;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: textTheme.caption1(
              Palette.neutral[120],
              FontWeight.bold,
              wordSpacing: 1,
            ),
          ),
        ),
        LazyList(
          neverScrollable: true,
          items: payments
              .map(
                (payment) => PaymentHistoryItem(
                  payment,
                  key: Key(
                    payment.id,
                  ),
                ),
              )
              .toList(),
          loadItems: loadPayments,
          limit: limit,
          hasMore: hasMore,
          isLoading: isLoading,
          isLoadingError: isLoadingError,
          loadingIndicator: const PaymentHistoryLoadingIndicator(),
          emptyIndicator: PaymentHistoryIndicatorText(
            copy.noPaymentsYet,
          ),
          errorIndicator: PaymentHistoryIndicatorText(
            copy.errorWhileLoadingPayments,
          ),
          noMoreItemsIndicator: PaymentHistoryIndicatorText(
            copy.endOfPayments,
          ),
        ),
      ],
    );
  }
}

class PaymentHistoryItem extends ConsumerWidget {
  const PaymentHistoryItem(this.payment, {required super.key});

  final Payment payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final copy = AppLocalizations.of(context)!;

    final unit = ref.watch(bitcoinUnitProvider);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Palette.neutral[20],
        radius: 16,
        child: DynamicIcon(
          icon: payment.direction == PaymentDirection.incoming
              ? 'assets/icons/receive_arrow.svg'
              : 'assets/icons/send_arrow.svg',
          color: payment.direction == PaymentDirection.incoming
              ? Palette.success[50]
              : Palette.lilac[100],
          size: 12.5,
        ),
      ),
      title: payment.direction == PaymentDirection.incoming
          ? Text(copy.received)
          : Text(copy.sent),
      titleTextStyle: textTheme.display2(
        Palette.neutral[80],
        FontWeight.w400,
      ),
      subtitle: Text(
        payment.dateTime,
        style: textTheme.caption1(
          Palette.neutral[120],
          FontWeight.w400,
        ),
      ),
      subtitleTextStyle: textTheme.caption1(
        Palette.neutral[60],
        FontWeight.w500,
      ),
      trailing: Text(
        '${payment.direction == PaymentDirection.incoming ? '+' : '-'} ${ref.watch(displayBitcoinAmountProvider(payment.amountSat))} ${unit.name.toUpperCase()}',
        style: textTheme.display2(
          payment.direction == PaymentDirection.incoming
              ? Palette.success[50]
              : Palette.neutral[70],
          FontWeight.w500,
        ),
      ),
    );
  }
}

// Todo: extract this to a separate file as it can be used in multiple places
class PaymentHistoryLoadingIndicator extends StatelessWidget {
  const PaymentHistoryLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      title: LottieBuilder.asset(
        'assets/lottie/loading_animation.json',
        width: 96.0,
        height: 24.0,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(
              const ['**'],
              value: Palette.neutral[50],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentHistoryIndicatorText extends StatelessWidget {
  const PaymentHistoryIndicatorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kSpacing5,
      ),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        text,
        style: textTheme.body3(
          Palette.neutral[50],
          FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
