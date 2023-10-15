import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class ActionsBottomSheetModal extends StatelessWidget {
  const ActionsBottomSheetModal({
    super.key,
    required this.actionIcons,
    required this.actionTitles,
    required this.actionOnPresseds,
  });

  final List<DynamicIcon> actionIcons;
  final List<String> actionTitles;
  final List<VoidCallback> actionOnPresseds;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const DynamicIcon(icon: Icons.close),
                  onPressed: GoRouter.of(context).pop,
                ),
              ),
            ],
          ),
          const SizedBox(height: kExtraSmallSpacing),
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: actionIcons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    leading: actionIcons[index],
                    title: Text(
                      actionTitles[index],
                      style: textTheme.display2(
                        Palette.neutral[80],
                        FontWeight.w600,
                      ),
                    ),
                    onTap: actionOnPresseds[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    color: Palette.neutral[30]!,
                  );
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Palette.neutral[30]!,
              ),
            ],
          ),
          const SizedBox(height: kExtraLargeSpacing),
        ],
      ),
    );
  }
}
