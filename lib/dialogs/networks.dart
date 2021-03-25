import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/logic/ip.dart';
import 'package:sharik/utils/helper.dart';

class PickNetworkDialog extends StatelessWidget {
  final LocalIpService ipService;

  const PickNetworkDialog(this.ipService);

  @override
  Widget build(BuildContext context) {
// todo show selected one
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      title: Text(
        'Preferred network interface',
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        // height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          // shrinkWrap: true,
          children: [
            SizedBox(
              height: ipService.interfaces!.length*72,
              child: ListView.builder(
                  itemCount: ipService.interfaces!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, e) => ListTile(
                    // contentPadding: EdgeInsets.zero,
                    title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(ipService.interfaces![e].name)),
                    subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                            ipService.interfaces![e].addresses.first.address),
                        ),
                    onTap:(){
                      ipService.selectedInterface = ipService.interfaces![e].name;
                      // ipService.load();
                      Navigator.of(context).pop();
                    },
                  )),
            ),
          ],
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
