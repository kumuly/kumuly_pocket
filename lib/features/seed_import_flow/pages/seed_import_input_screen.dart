import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class SeedImportInputScreen extends ConsumerWidget {
  const SeedImportInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Seed import',
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing2,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kSpacing5,
                  mainAxisSpacing: kSpacing4,
                  childAspectRatio: 144 / 40,
                ),
                itemBuilder: (context, index) => Container(
                  height: 40,
                  width: 144,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSpacing1),
                    color: Palette.neutral[20],
                  ),
                  child: Center(
                    child: Text(
                      'Word ${index + 1}',
                      style: textTheme.body4(
                        Palette.neutral[80],
                        FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
