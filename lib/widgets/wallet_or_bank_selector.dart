

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/pages/select_wallet_or_bank.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class WalletOrBankSelector extends StatefulWidget {

  WalletOrBankSelector({@required this.label, @required this.icon, @required this.walletOrBank, @required this.onChanged});

  final String label;
  final Widget icon;
  final WalletOrBank walletOrBank;
  final ValueChanged<WalletOrBank> onChanged;

  @override
  createState() => _WalletOrBankSelectorState();

}

class _WalletOrBankSelectorState extends State<WalletOrBankSelector> {

  WalletOrBank _walletOrBank;

  initState() {
    _walletOrBank = widget.walletOrBank;
    super.initState();
  }

  build(context) => FormCell(
      onPressed: () { _handleOnCellPressed(context); },
      label: widget.label,
      icon: widget.icon,
      trailing: Icon(Icons.chevron_right),
      child: Row(
        children: [
          _getWalletOrBankImage(),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_walletOrBank?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18
                    )
                ),
                Container(
                    child: Text('Send money to ${_walletOrBank?.name ?? ''}',
                        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey.shade600)
                    )
                )
              ],
            ),
          )
        ],
      )
  );

  _handleOnCellPressed(BuildContext context) async {
    final walletOrBank = await SelectWalletOrBankPage.navigateTo(context);
    if (walletOrBank == null) {
      return;
    }
    setState(() {
      _walletOrBank = walletOrBank;
    });
    if (widget.onChanged != null) {
      widget.onChanged(walletOrBank);
    }
  }

  Widget _getWalletOrBankImage() {
    return _walletOrBank?.logoUrl != null
        ? CachedNetworkImage(
            imageUrl: _walletOrBank.logoUrl,
            height: 48,
            width: 48,
            fit: BoxFit.contain
          ) : SizedBox(width: 48, height: 48);
  }
}