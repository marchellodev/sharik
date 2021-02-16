import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/helper.dart';

// todo check fonts for consistence
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // todo check for consistency
      padding: const EdgeInsets.all(24),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current version', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
              const Text('3.0', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('The latest version', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
              const Text('3.1', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurple[400],
                  child: InkWell(
                    splashColor: Colors.deepPurple[100].withOpacity(0.32),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {},
                    child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Text('Update', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16, color: Colors.white))),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Material(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.deepPurple[400].withOpacity(0.32),
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text(
                        'Changelog',
                        style: TextStyle(fontSize: 16, color: Colors.deepPurple[700], fontFamily: 'JetBrainsMono'),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 34),
          Text(
              'Sharik is completely free and its code is published on GitHub.\nEveryone is welcomed to contribute :)', textAlign: TextAlign.center,
              style: GoogleFonts.getFont(context.l.fontComfortaa, fontSize: 16)),
          const SizedBox(height: 12),

          Row(
            children: [
              SvgPicture.asset('assets/icons/social/telegram.svg'),
              SvgPicture.asset('assets/icons/social/github.svg'),
            ],
          )

        ],
      ),
    );
  }
}
