import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';

abstract class MexiContent extends StatelessWidget {
  const MexiContent({
    super.key,
  });

  List<Widget> getContents(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: getContents(context),
          ),
        ),
      ),
    );
  }
}
