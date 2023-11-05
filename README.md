# kumuly_pocket

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Contributing

### Code generation

This project uses riverpod with code generation. To generate the code and keep watching for changes, run `dart run build_runner watch`.

### Internationalization

This project uses the [flutter_localizations](https://pub.dev/packages/flutter_localizations) package for internationalization. The internationalization files are located in `lib/l10n/`. This package also generates the `lib/l10n/l10n.dart` file which contains the `AppLocalizations` class. This class contains all the keys for the internationalization files. To generate the `l10n.dart` file, run `flutter pub run` from the project root directory.

### Workflow

#### Add new copy to the internationalization files

When implementing a new feature which involves new views with new copy, first add all the copy you see in the views to the internationalization files in `lib/l10n/`.

!Do not hardcode copy in the views!

In the end it is less work to directly add the copy to the internationalization files than to add it hardcoded to the views first and then later having to search for it again and replace it with the internationalization key.

Before adding a new label, check if it already exists in the internationalization files. If it does, use the existing key instead of creating a new one.

#### PageView vs Route

When implementing a new feature which involves different new screens, first decide which screens should be reachable directly through a separate route and which should only be reachable after the first and subsequent screens. If the screens form a cohesive flow and the second screen should only be reachable from the first screen and the third only from the second, they form a cohesive flow and you should use a `PageView` instead of routing between them. A combination of having a `PageView` and routes is also possible. Following are examples of features in the project for the possible combinations:

- PageView only: [receive_sats_flow](lib/features/receive_sats_flow)
  The folder contains a `receive_sats_flow.dart` file where the `PageView` is defined, and only this `ReceiveSatsFlow` is reachable through a route, not the other screens in the flow. They are only reachable through the `PageView`. Every screen in the flow has its own folder with a screen file and a controller and state file in case the state that origins from the screen is needed in other screens in the flow.
- Route only: [landing](lib/features/landing), [pocket](lib/features/pocket), [contacts](lib/features/contacts) etc.
  These features only have one screen and are reachable through a route. They do not need a `PageView`. They can route to other flows though, like the pocket starting the receive sats flow, or contacts the add contact flow, but they themselves are not part of a flow and are directly reachable through a route only.
- PageView and a direct route to other screens in the flow too: [promo_flow](lib/features/promo_flow)
  This feature has a `PageView` to get the details of a promo, pay for the promo and then get the instructions and code to redeem the promo. These steps form a consecutive flow and some screens like the `PromoPaidScreen` should never be routed to without having paid on the `PromoDetailsScreen`. After the promo is paid, the instructions and code to redeem the promo should always be shown, so it makes sense to add them all in a PageView and add a route to the flow in the app router, named `promo-flow`. Once a promo is paid though, it can be possible to navigate to the `PromoCodeScreen` directly, from the overview of all paid promos for example. Therefore the `PromoPaidScreen` does has its own route in the app router too, named `promo-code`. This way, the `PromoPaidScreen` can be reached directly from the overview of all paid promos, but it can also be reached through the `PageView` of the `PromoFlow`, as it is part of that flow too.

Make sure to add `parentNavigatorKey: _rootNavigatorKey` to the GoRoute of the routes that should be pushed on the stack of the root navigator. This way, the route will be pushed on the stack of the root navigator instead of the stack of the navigator of the current context, like for example in the pocket or merchant mode bottom navigation context. This way, the back button will always work as expected and the screens will take up the full screen instead of having the bottom navigation visible.

#### State controller vs local state

When implementing a new feature which involves state, first decide if the data that origintates on that screen should be local to the screen or if it should be available in the following screens of the feature's flow too. If the state should be shared with other screens of the flow, create a state controller for the state. If the state should be local to the screen, use the local state of the screen.
The easiest way is to start with the local state of the screen and only create a state controller when the state needs to be shared with other screens of the flow. You can follow these basic steps:

1. Create PageView of the flow
2. Create first screen of the flow and add it to the PageView
3. Manage the state of the screen with the local state of the screen
4. Create second screen of the flow and add it to the PageView
5. If second screen needs to access the state of the first screen, create a state controller for the state of the first screen and use the state controller in the second screen.

# Problems and solutions encountered during development

## (Xcode): Target release_ios_bundle_flutter_assets failed: Exception: Failed to codesign

### Solution

Run `xattr -cr assets` or `find assets -type f -exec xattr -c {} \;` from the project root directory.
