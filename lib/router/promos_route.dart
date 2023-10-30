import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/promos/promo_details_screen.dart';
import 'package:kumuly_pocket/features/promos/promo_paid_screen.dart';
import 'package:kumuly_pocket/features/promos/promos_screen.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

// This is the route for the overview of all promos
final promosRoute = GoRoute(
  path: '/promos',
  name: 'promos',
  builder: (context, state) => const PromosScreen(),
  routes: [
    GoRoute(
      path: 'details',
      name: 'promos-details',
      builder: (context, state) =>
          PromoDetailsScreen(promo: state.extra as Promo),
    ),
    GoRoute(
      path: 'paid',
      name: 'promos-paid',
      builder: (context, state) => const PromoPaidScreen(),
    )
  ],
);

// This is the route to go directly to the promo details
//  coming from the For You tab for example. This route is different to make the back button
//  go back to the For You tab instead of to the Promos tab.
// The name or path can be checked in the Screen to determine if it was
//  navigated to from the For You tab or the Promos tab.
final promoRoute = [
  GoRoute(
    path: '/promo-details',
    name: 'promo-details',
    builder: (context, state) =>
        PromoDetailsScreen(promo: state.extra as Promo),
  ),
  GoRoute(
    path: '/promo-paid',
    name: 'promo-paid',
    builder: (context, state) => const PromoPaidScreen(),
  ),
];
