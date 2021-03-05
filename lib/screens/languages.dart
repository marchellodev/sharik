import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sharik/components/logo.dart';
import 'package:sharik/components/page_router.dart';

import '../conf.dart';
import '../logic/language.dart';


class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SafeArea(
            child: SizedBox(
              height: 24,
            ),
          ),
          SharikLogo(),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Select the language\nyou are familiar\nwith',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Comfortaa',
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          for (var lang in languageList) ...[
            LanguageButton(lang, () {
              context.read<LanguageManager>().language = lang;
              SharikRouter.navigateTo(context, this, Screens.intro, RouteDirection.right);
            }),
            const SizedBox(height: 6)
          ],
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Language language;
  final Function() onClick;

  const LanguageButton(this.language, this.onClick);

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
            height: 78,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[400],
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onClick,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      // margin: const EdgeInsets.all(6),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          'assets/flags/${language.name}.svg',
                        ),
                      ),
                    ),
                    Center(
                        child: Text(language.nameLocal,
                            style: GoogleFonts.getFont(
                                language.localizations.fontAndika,
                                color: Colors.grey.shade100,
                                fontSize: 24))),
                  ],
                ),
              ),
            )),
      );
}
