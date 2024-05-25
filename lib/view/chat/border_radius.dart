// Flutter imports:
import 'package:flutter/material.dart';

BorderRadius getBorderRadiusForCurrentUser(
    bool isSameUserAsPrev, bool isSameUserAsNext) {
  if (isSameUserAsPrev && isSameUserAsNext) {
    return const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        topRight: Radius.circular(3),
        bottomRight: Radius.circular(3));
  } else if (isSameUserAsPrev) {
    return const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        topRight: Radius.circular(22),
        bottomRight: Radius.circular(3));
  } else {
    return const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
        topRight: Radius.circular(3));
  }
}

BorderRadius getBorderRadiusForOtherUser(
    bool isSameUserAsPrev, bool isSameUserAsNext) {
  if (isSameUserAsPrev && isSameUserAsNext) {
    return const BorderRadius.only(
        topLeft: Radius.circular(3),
        bottomLeft: Radius.circular(3),
        topRight: Radius.circular(22),
        bottomRight: Radius.circular(22));
  } else if (isSameUserAsPrev) {
    return const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(3));
  } else {
    return const BorderRadius.only(
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
        topLeft: Radius.circular(3));
  }
}

EdgeInsets getPaddingForCurrentUser(
    bool isSameUserAsPrev, bool isSameUserAsNext) {
  if (isSameUserAsPrev && !isSameUserAsNext) {
    return const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 1.0);
  } else if (isSameUserAsPrev && isSameUserAsNext) {
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 1.0);
  } else {
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 1.0);
  }
}

EdgeInsets getPaddingForOtherUser(
    bool isSameUserAsPrev, bool isSameUserAsNext) {
  if (isSameUserAsPrev && !isSameUserAsNext) {
    return const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 1.0);
  } else if (isSameUserAsPrev && isSameUserAsNext) {
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 1.0);
  } else {
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 1.0);
  }
}
