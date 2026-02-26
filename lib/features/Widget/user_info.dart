import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class UserInfo extends StatelessWidget {
  final String? name;
  final String? subName;
  const UserInfo({super.key, this.name, this.subName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.sh(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.seconderyColor,
              fontSize: context.sp(12),
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            subName!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.subHeadingColor,
              fontSize: context.sp(12),
              fontWeight: FontWeight.w400,
              fontFamily: 'Raleway',
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
