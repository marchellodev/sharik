import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/logic/ip_service.dart';
import 'package:sharik/logic/theme.dart';
import 'package:sharik/utils/helper.dart';

// todo get that dynamically from github
// todo fix the infinite scroll
String changelog = '''

# Changelog

## [3.0] - 2021-05-xx

### Added
- Swipe from left to right to exit the sharing or about screen
- The about screen
- The dialog for selection network interface
- Dark theme
- Button that shows the link QR code
- todo new languages
- Support for different screen sizes & dynamic resizing


### Changed
- New design of the app
- Big performance optimizations
- Improved the size of Sharik

### Fixed
- Completely new method of getting the local ip & network connectivity status
- A lot of other fixes


## [2.5] - 2020-08-15

### Changed
- UI tweaks
- Performance improvements

### Fixed
- Crash when trying to get local ip with no network connectivity




## [2.4] - 2020-08-15

### Added
- Hindi language
- Gujarati language

### Changed
- A few minor tweaks


## [2.3] - 2020-06-30

### Fixed
- Changed the logic of fetching local ip


## [2.2] - 2020-04-26

### Added
- Receiver

### Fixed
- A few bugs


## [2.1] - 2020-04-22

### Added
- Polish language
- Ability to clean file history
- Check for updates button

### Changed
- Improved UI
- Improved performance

## [2.0] - 2020-03-09

### Added
- Ability to share android apps
- Desktop support

### Changed
- Improved UI


## [1.0.0+1] - 2020-02-18

### Fixed
- Changed link to the instagram page


[unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.8...v0.1.0
[0.0.8]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/olivierlacan/keep-a-changelog/releases/tag/v0.0.1
''';

class ChangelogDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// todo show selected one
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      title: Text(
        'Changelog',
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        // child: Column(
        //   // shrinkWrap: true,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: const [
        //     Text(
        //       'v1.1',
        //       style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
        //     ),
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //
        //     Text(
        //       'v1.1',
        //       style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
        //     ),
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ),
        //     Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ),
        //     Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ), Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ), Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ),
        //
        //
        //
        //     SizedBox(
        //       height: 10,
        //     ),
        //
        //     Text(
        //       'v1.1',
        //       style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
        //     ),
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Text(' • whats new',
        //         style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        //     SizedBox(
        //       height: 2,
        //     ),
        //     SizedBox(
        //       height: 10,
        //     )
        //   ],
        // ),
        child: MarkdownBody(
          data: changelog.replaceFirst('# Changelog', ''),
          styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
              ),
              h3: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
              h2: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              a: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  color: context.t.textTheme.bodyText1!.color)),
        ),
      ),
      actions: [
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
