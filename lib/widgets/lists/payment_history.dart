import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/payment.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';

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
          items: payments
              .map(
                (payment) => Text(
                  payment.paymentHash,
                  key: Key(
                    payment.paymentHash,
                  ),
                ),
              )
              .toList(),
          loadItems: loadPayments,
          limit: limit,
          hasMore: hasMore,
          isLoading: isLoading,
          isLoadingError: isLoadingError,
          emptyIndicator: null, // TODO: implement emptyIndicator
          errorIndicator: null, // TODO: implement errorIndicator
          noMoreItemsIndicator: null, // TODO: implement noMoreItemsIndicator
        ),
      ],
    );
  }
}
