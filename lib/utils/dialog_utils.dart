import 'package:flutter/material.dart';

import '../widgets/dialog/yes_no_dialog.dart';

class DialogUtils {
  DialogUtils._internal();

  static void showYesNoDialog({
    required BuildContext context,
    String title = '',
    String content = '',
    String yesButtonText = '確定',
    String noButtonText = '取消',
    VoidCallback? onYesPress,
    VoidCallback? onNoPress,
  }) {
    showViewDialog(
        context,
        YesNoDialog(
          hideNoButton: false,
          title: title,
          content: content,
          yesButtonText: yesButtonText,
          noButtonText: noButtonText,
          onYesPress: onYesPress,
          onNoPress: onNoPress,
        )
    );
  }

  static void showYesDialog({
    required BuildContext context,
    String title = '',
    String content = '',
    String yesButtonText = '確定',
    VoidCallback? onYesPress,
  }) {
    showViewDialog(
        context,
        YesNoDialog(
          hideNoButton: true,
          title: title,
          content: content,
          yesButtonText: yesButtonText,
          noButtonText: '',
          onYesPress: onYesPress,
          onNoPress: null,
        )
    );
  }

  static void showViewDialog(BuildContext context, Widget dialogView) {
    Future(() {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.6, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return dialogView;
        },
      );
    });
  }
}