
import 'package:asset_management/utils/constants.dart' show AppColors, AppStrings, AppTextStyles;
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: AppColors.primary.withValues(alpha: .1),
      title: Text(
        AppStrings.appTitle,
        style: AppTextStyles.appBarTitle,
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.textPrimary),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }
}
