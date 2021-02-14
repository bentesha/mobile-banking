
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/token_request.dart';
import 'package:mkombozi_mobile/networking/token_response.dart';
import 'package:mkombozi_mobile/pages/select_account.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/error_view.dart';
import 'package:mkombozi_mobile/widgets/luku_token_tile.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class LukuTokenListPage extends StatefulWidget {
  
  LukuTokenListPage(this.account);
  
  static void navigateTo(BuildContext context, Account account) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LukuTokenListPage(account)
    ));
  }
  
  final Account account;
  
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }

}

class _PageState extends State<LukuTokenListPage> {

  Account _account;

  @override
  void initState() {
    _account = widget.account;
    super.initState();
  }

  _selectAccount() async {
    final account = await SelectAccountPage.navigateTo(context, _account);
    if (account == null) {
      return;
    }
    setState(() {
      _account = _account;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Luku Tokens')
      ),
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 2,
              child: InkWell(
                  onTap: _selectAccount,
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text(Formatter.maskAccountNumber(_account.accountNumber)),
                    trailing: Icon(Icons.chevron_right),
                  )
              )
            ),
            Flexible(
              child: _buildTokenList()
            )
          ],
        )
      )
    );
  }

  Widget _buildTokenList() {
    final loginService = Provider.of<LoginService>(context, listen: false);
    final user = loginService.currentUser;
    final request = TokenRequest(account: _account, user: user);
    return FutureBuilder<TokenResponse>(
      future: request.send(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProgressView();
        }

        final response = snapshot.data;
        if (response.code != 200) {
          return ErrorView(response.message, response.description);
        }

        return ListView.separated(
          itemCount: response.tokens.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) => LukuTokenTile(response.tokens[index]),
        );
      }
    );
  }

}