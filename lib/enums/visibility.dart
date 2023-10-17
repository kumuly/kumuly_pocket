enum Visibility {
  public,
  authenticated,
  private,
  admin,
  group,
}

extension VisibilityExtension on Visibility {
  String get stringValue {
    switch (this) {
      case Visibility.public:
        return 'public';
      case Visibility.authenticated:
        return 'authenticated';
      case Visibility.private:
        return 'private';
      case Visibility.admin:
        return 'admin';
      case Visibility.group:
        return 'group';
      default:
        return 'Unknown';
    }
  }
}
