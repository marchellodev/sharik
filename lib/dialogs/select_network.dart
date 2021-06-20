import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../logic/services/ip_service.dart';
import '../utils/helper.dart';

// todo styling

// review: done

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
        context.l.sharingSelectNetworkInterface,
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      // todo probably redundant
      //   splashColor = context.t.dividerColor.withOpacity(0.08);
      //   hoverColor = context.t.dividerColor.withOpacity(0.04);
      content: Theme(
        data: context.t.copyWith(
          splashColor: context.t.dividerColor.withOpacity(0.08),
          highlightColor: Colors.transparent,
        ),
        child: Column(
          children: [
            for (final el in ipService.interfaces!)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: ListTile(
                  hoverColor: context.t.dividerColor.withOpacity(0.04),
                  // hoverColor: Colors.red,
                  selected: ipService.getIp() == el.addresses.first.address,
                  selectedTileColor: context.t.dividerColor.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // todo style colors
                  title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        el.name,
                        style: GoogleFonts.getFont('Andika',
                            color: context.t.textTheme.bodyText1!.color),
                      )),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      el.addresses.first.address,
                      style: GoogleFonts.getFont('Andika',
                          color: context.t.textTheme.caption!.color),
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
