import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/buttons.dart';
import '../components/grid_view.dart';
import '../components/logo.dart';
import '../components/page_router.dart';
import '../conf.dart';
import '../logic/language.dart';

// review: done

class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: SizedBox(
                height: 22,
              ),
            ),
            Hero(tag: 'icon', child: SharikLogo()),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Select the language\nyou are familiar with',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Comfortaa',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: constraints.maxWidth < 720 ? 1 : 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  height: 80,
                ),
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: languageList.length,
                itemBuilder: (BuildContext context, int index) =>
                    LanguageButton(languageList[index], () {
                  context.read<LanguageManager>().language =
                      languageList[index];
                  SharikRouter.navigateTo(
                      context, this, Screens.intro, RouteDirection.right);
                }),
              );
            }),
            const SizedBox(height: 24),
          ]),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Language language;
  final Function() onClick;

  const LanguageButton(this.language, this.onClick);

  @override
  Widget build(BuildContext context) => PrimaryButton(
        height: 80,
        onClick: onClick,
        text: language.nameLocal,
        secondaryIcon: SvgPicture.asset(
          'assets/flags/${language.name}.svg',
        ),
        font: language.localizations.fontAndika,
      );
}
