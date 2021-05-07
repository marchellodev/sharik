import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/logic/services/ip_service.dart';
import 'package:sharik/utils/helper.dart';

class PickNetworkDialog extends StatelessWidget {
  final LocalIpService ipService;

  const PickNetworkDialog(this.ipService);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      title: Text(
        'Preferred network interface',
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      // todo probably redundant
      content: Theme(
        data: ThemeData(
            brightness: Brightness.dark,
            accentColor: context.t.textTheme.bodyText1!.color),
        child: Column(
          children: [
            for (final el in ipService.interfaces!)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  selected: ipService.getIp() == el.addresses.first.address,
                  selectedTileColor: context.t.dividerColor.withOpacity(0.08),
                  // todo text styling
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // todo style colors
                  title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child: Text(el.name)),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      el.addresses.first.address,
                    ),
                  ),
                  onTap: () {
                    ipService.selectedInterface = el.name;
                    Navigator.of(context).pop();
                  },
                ),
              )
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
