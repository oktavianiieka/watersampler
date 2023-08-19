import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? iconColor;
  final Object? result;
  final double? elevation;
  final bool useLeading;
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleStyle,
    this.backgroundColor,
    this.iconColor,
    this.result,
    this.elevation,
    this.useLeading = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: useLeading ? true : false,
      title: Text(
        title!,
        style: titleStyle,
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      leading: useLeading
          ? InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: iconColor,
              ),
            )
          : null,
    );
  }
}
