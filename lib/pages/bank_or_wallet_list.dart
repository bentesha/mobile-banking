


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class BankOrWalletListPage extends StatelessWidget {

  BankOrWalletListPage(this.listType);

  final String listType;

  static Future<WalletOrBank> navigateTo(BuildContext context, String listType) {
    return Navigator.of(context).push<WalletOrBank>(MaterialPageRoute(
        builder: (context) => BankOrWalletListPage(listType)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Select ' + this.listType == 'bank' ? 'Bank' : 'Wallet')
        ),
        body: SafeArea(
            child: Consumer<AccountService>(
              builder: (context, accountService, _) {
                return FutureBuilder<List<WalletOrBank>>(
                  initialData: [],
                  future: accountService.getBanksOrWallets(listType),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ProgressView();
                    }
                    return buildList(context, snapshot.data);
                  },
                );
              },
            )
        )
    );
  }

  Widget buildList(BuildContext context, List<WalletOrBank> data) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final walletOrBank = data[index];
        return InkWell(
          onTap: () { _handleItemSelected(context, walletOrBank); },
          child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                  child: ListTile(
                    title: Text(walletOrBank.name ?? ''),
                    subtitle: Text('Send money to ${walletOrBank.name}' ?? ''),
                    leading: walletOrBank.logoUrl == null
                      ? SizedBox(height: 48, width: 48)
                      : CachedNetworkImage(imageUrl: walletOrBank.logoUrl, height: 48, width: 48, fit: BoxFit.contain),
                  )
              )
          ),
        );
      },
    );
  }

  _handleItemSelected(BuildContext context, WalletOrBank walletOrBank) {
    Navigator.of(context).pop<WalletOrBank>(walletOrBank);
  }
}