import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/transaction_type.dart';
import 'package:kumuly_pocket/router/app_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/transaction_list_item_view_model.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider_section_heading.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.loadTransactions,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<TransactionListItemViewModel> transactions;
  final Future<void> Function({bool refresh}) loadTransactions;
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
        LazyList(
          neverScrollable: true,
          items: transactions.asMap().entries.map((entry) {
            final index = entry.key;
            final transaction = entry.value;
            final previousTransaction =
                index > 0 ? transactions[index - 1] : null;
            return TransactionListItem(
              transaction,
              key: Key(
                transaction.id,
              ),
              showDateDivider: previousTransaction == null ||
                  previousTransaction.day != transaction.day ||
                  previousTransaction.month != transaction.month ||
                  previousTransaction.year != transaction.year,
            );
          }).toList(),
          loadItems: loadTransactions,
          limit: limit,
          hasMore: hasMore,
          isLoading: isLoading,
          isLoadingError: isLoadingError,
          loadingIndicator: const TransactionListLoadingIndicator(),
          emptyIndicator: TransactionListIndicatorText(
            copy.noTransactionsYet,
          ),
          errorIndicator: TransactionListIndicatorText(
            copy.errorWhileLoadingTransactions,
          ),
          noMoreItemsIndicator: TransactionListIndicatorText(
            copy.endOfTransactions,
          ),
        ),
      ],
    );
  }
}

class TransactionListItem extends ConsumerWidget {
  const TransactionListItem(
    this.transaction, {
    required super.key,
    this.showDateDivider = false,
  });

  final TransactionListItemViewModel transaction;
  final bool showDateDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final copy = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Column(
      children: [
        if (showDateDivider)
          DashedDividerSectionHeading(
            title: transaction.isToday
                ? copy.today
                : transaction.isYesterday
                    ? copy.yesterday
                    : transaction.formatLocaleDate(
                        languageCode,
                      )!,
          ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Palette.neutral[20],
            radius: 16,
            child: DynamicIcon(
              icon: transaction.isIncoming
                  ? 'assets/icons/receive_arrow.svg'
                  : 'assets/icons/send_arrow.svg',
              color: transaction.isIncoming
                  ? Palette.success[50]
                  : Palette.lilac[100],
              size: 12.5,
            ),
          ),
          title: transaction.isIncoming ? Text(copy.received) : Text(copy.sent),
          titleTextStyle: textTheme.display2(
            Palette.neutral[80],
            FontWeight.w400,
          ),
          subtitle: Text(
            transaction.formatLocaleTime(
                  languageCode,
                ) ??
                copy.pending,
          ),
          subtitleTextStyle: textTheme.caption1(
            Palette.neutral[60],
            FontWeight.w500,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BitcoinAmountDisplay(
                prefix: transaction.isIncoming ? '+ ' : '- ',
                amountSat: transaction.amountSat,
                amountStyle: textTheme.display2(
                  transaction.isIncoming
                      ? Palette.success[50]
                      : Palette.neutral[120],
                  FontWeight.w500,
                ),
                hideUnit: true,
              ),
              LocalCurrencyAmountDisplay(
                prefix: '≈ ',
                showSymbol: true,
                showCode: false,
                amountSat: transaction.amountSat,
                amountStyle: textTheme.caption1(
                  Palette.neutral[70],
                  FontWeight.normal,
                ),
              )
            ],
          ),
          onTap: () {
            if (transaction.type == TransactionType.lightningPayment) {
              router.pushNamed(
                AppRoute.paymentDetails.name,
                pathParameters: {
                  'hash': transaction.id,
                },
              );
            }
          },
        ),
      ],
    );
  }
}

// Todo: extract this to a separate file as it can be used in multiple places
class TransactionListLoadingIndicator extends StatelessWidget {
  const TransactionListLoadingIndicator({super.key});

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

class TransactionListIndicatorText extends StatelessWidget {
  const TransactionListIndicatorText(this.text, {super.key});

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
