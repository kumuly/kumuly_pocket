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

### Workflow

#### Add new copy to the internationalization files

When implementing a new feature which involves new views with new copy, first add all the copy you see in the views to the internationalization files in `lib/l10n/`.

!Do not hardcode copy in the views!

In the end it is less work to directly add the copy to the internationalization files than to add it hardcoded to the views first and then later having to search for it again and replace it with the internationalization key.

Before adding a new label, check if it already exists in the internationalization files. If it does, use the existing key instead of creating a new one.
