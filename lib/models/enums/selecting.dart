enum Selecting {
  FROM,
  TO,
}

extension SelectingExtension on Selecting {
  String get value {
    switch (this) {
      case Selecting.FROM:
        return 'From';
      case Selecting.TO:
        return 'To';
      default:
        return null;
    }
  }
}

