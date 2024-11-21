import 'package:flutter/material.dart';

class UserProfilInherited extends InheritedWidget {
  final Function functionInUserProfilShowInShow;

  const UserProfilInherited({
    Key? key,
    required Widget child,
    required this.functionInUserProfilShowInShow,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static UserProfilInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProfilInherited>();
  }
}