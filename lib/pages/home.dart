
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/pages/stop_cheque_request_page.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/pages/account_statement_page.dart';
import 'package:mkombozi_mobile/pages/agency_withdrawal_page.dart';
import 'package:mkombozi_mobile/pages/atm_card_request_page.dart';
import 'package:mkombozi_mobile/pages/bill_payment_page.dart';
import 'package:mkombozi_mobile/pages/atm_withdrawal_page.dart';
import 'package:mkombozi_mobile/pages/cheque_book_request_page.dart';
import 'package:mkombozi_mobile/pages/loan_application_page.dart';
import 'package:mkombozi_mobile/pages/luku_token_list.dart';
import 'package:mkombozi_mobile/pages/profile_page.dart';
import 'package:mkombozi_mobile/pages/salary_advance_page.dart';
import 'package:mkombozi_mobile/pages/select_wallet_or_bank.dart';
import 'package:mkombozi_mobile/pages/select_service.dart';
import 'package:mkombozi_mobile/pages/select_cash_out_method.dart';
import 'package:mkombozi_mobile/pages/send_money_page.dart';
import 'package:mkombozi_mobile/pages/standing_order_page.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/widgets/account_card.dart';
import 'package:mkombozi_mobile/widgets/drawer_menu.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:mkombozi_mobile/widgets/service_logo.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  static final String routeName = '/home';

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  Account currentAccount;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade900,
      statusBarIconBrightness: Brightness.light//or set color with: Color(0xFF0000FF)
    ));

    return Scaffold(
      drawer: DrawerMenu(onAction: _handleDrawerMenuAction),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(onChanged: (account) => currentAccount = account),
            ActionBar(),
            Flexible(
              child: ServiceList(),
            )
          ],
        )
      ),
    );
  }

  _handleDrawerMenuAction(ActionType action) {
    // Wait for the account info to load
    if (currentAccount == null) {
      return;
    }
    switch(action) {
      case ActionType.profile:
        ProfilePage.navigateTo(context, currentAccount);
        break;
      case ActionType.miniStatement:
        AccountStatementPage.navigateTo(context, StatementType.mini, currentAccount);
        break;
      case ActionType.fullStatement:
        AccountStatementPage.navigateTo(context, StatementType.full, currentAccount);
        break;
      case ActionType.lukuTokens:
        LukuTokenListPage.navigateTo(context, currentAccount);
        break;
      case ActionType.standingOrder:
        StandingOrderPage.navigateTo(context, currentAccount);
        break;
      case ActionType.salaryAdvance:
        SalaryAdvancePage.navigateTo(context, currentAccount);
        break;
      case ActionType.requestAtmCard:
        AtmCardRequestPage.navigateTo(context, currentAccount);
        break;
      case ActionType.requestChequeBook:
        ChequeBookRequestPage.navigateTo(context, currentAccount);
        break;
      case ActionType.loanApplication:
        LoanApplicationPage.navigateTo(context, currentAccount);
        break;
      case ActionType.stopCheque:
        StopChequeRequestPage.navigateTo(context, currentAccount);
        break;
      default:
    }
  }
}

class ServiceList extends StatelessWidget {

  _handleItemPressed(BuildContext context, Service service)  {
    final state = context.findAncestorStateOfType<_HomePageState>();
    BillPaymentPage.navigateTo(context, state.currentAccount, service);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountService>(
      builder: (context, accountService, _) => FutureBuilder<List<Service>>(
        initialData: [],
        future: accountService.getCoreServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressView();
          }
          return ListView.separated(
            // shrinkWrap: true,
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) => ServiceTile(
              icon: ServiceLogo(service: snapshot.data[index], height: 32, width: 32),
              name: snapshot.data[index].name,
              description: snapshot.data[index].description,
              onPressed: () { _handleItemPressed(context, snapshot.data[index]); },
            ),
          );
        },
      )
    );
  }
}

class ServiceTile extends StatelessWidget {

  ServiceTile({this.icon, this.name, this.description, this.onPressed });

  final Widget icon;
  final String name;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Container(
          height: double.infinity,
          child: icon
        ),
        title: Text(name,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w500
          )
        ),
        subtitle: Text(description,
          style: TextStyle(
            fontSize: 12,
          )
        ),
      )
    );
  }
}

class Header extends StatelessWidget {

  Header({this.onChanged});

  final ValueChanged<Account> onChanged;

  build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: PrimaryBackgroundGradient()
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: AppBar(
              leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              ),
              title: Text('MKOMBOZI Bank',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
                )
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Consumer<AccountService>(
              builder: (context, accountService, _) {
                return FutureBuilder<List<Account>>(
                  future: accountService.getAccounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    }
                    if (onChanged != null && snapshot.data.length > 0) {
                      onChanged(snapshot.data.first);
                    }
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 0.8,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, _) {
                          if (onChanged == null) {
                            return;
                          }
                          onChanged(snapshot.data[index]);
                        }
                      ),
                      items: snapshot.data.map((account) => AccountCard(account: account)).toList()
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

}

class ActionBar extends StatelessWidget {

  Account _getCurrentAccount(BuildContext context) {
    final state = context.findAncestorStateOfType<_HomePageState>();
    return state.currentAccount;
  }

  @override
  Widget build(BuildContext context) {
    void _handleActionButton(int index) async {
      if (index == 0) {
        final service = await SelectCategoryPage.navigateTo(context);
        if (service == null) {
          return;
        }
        BillPaymentPage.navigateTo(context, _getCurrentAccount(context), service);
      } else if (index == 1) {
        final walletOrBank = await SelectWalletOrBankPage.navigateTo(context);
        if (walletOrBank == null) {
          return;
        }
        SendMoneyPage.navigateTo(context, _getCurrentAccount(context), walletOrBank);
      } else if (index == 2) {
        final method = await SelectWithdrawalMethodPage.navigateTo(context);
        switch(method){
          case CashOutMethod.atm:
            AtmWithdrawalPage.navigateTo(context, _getCurrentAccount(context));
            break;
          case CashOutMethod.agent:
            AgencyWithdrawalPage.navigateTo(context, _getCurrentAccount(context));
            break;
          default:
            return;
        }
      }
    }

    return Ink(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xff086086),
      child: BottomNavigationBar(
        onTap: _handleActionButton,
        elevation: 0,
        selectedItemColor: Color(0xffa3cc55),
        unselectedItemColor: Color(0xffa3cc55),
        backgroundColor: Colors.transparent,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.account_balance_wallet_outlined),
            ),
            label: 'PAY BILL'
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.login),
            ),
            label: 'SEND MONEY'
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset('assets/cash-out.svg',
                height: 24,
                width: 24,
                color: Theme.of(context).accentColor
              ),
            ),
            label: 'CASH OUT'
          )
        ]
      ),
    );
  }
}