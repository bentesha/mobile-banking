
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/app.dart';
import 'package:mkombozi_mobile/dialogs/confirm_dialog.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/device.dart';
import 'package:mkombozi_mobile/pages/change_pin_page.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {

  ProfilePage(this.account);

  final Account account;

  static void navigateTo(BuildContext context, Account account) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProfilePage(account)
    ));
  }

  _changePin(BuildContext context) {
    // Show PIN change page
    ChangePinPage.navigateTo(context, account);
  }

  _logout(BuildContext context) async {
    final logout = await ConfirmDialog.show(
      context,
      'Log out?',
      'You will be logged out if you continue',
      okText: 'CONTINUE'
    );

    if (logout ?? false) {
      final loginService = Provider.of<LoginService>(context, listen: false);
      await loginService.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(MyApp.START_PAGE, (route) => false);
    }
  }

  build(context) => Scaffold(
    appBar: AppBar(
      title: Text('My Profile', style: TextStyle(color: Colors.grey.shade800)),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.grey.shade600),
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          Divider(height: 1),
          Consumer<LoginService>(
            builder: (context, loginService, _) {
              return FutureBuilder<List<Device>>(
                future: loginService.getDevices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ProgressView();
                  }
                  return _Details(
                    devices: snapshot.data,
                    onChangePin: () { _changePin(context); },
                    onLogout: () { _logout(context); },
                  );
                },
              );
            },
          )
        ],
      )
    )
  );

}

class _Header extends StatelessWidget {

  @override
  build(context) => Padding(
      padding: EdgeInsets.all(16),
      child: Consumer<LoginService>(
        builder: (context, loginService, _) {
          final user = loginService.currentUser;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 20,
                child: Text(user.name[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white
                  )
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )
                  ),
                  SizedBox(height: 4),
                  Text('+${user.mobile}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                    )
                  )
                ],
              )
            ],
          );
        }
      )
  );
}

class _Details extends StatelessWidget {

  _Details({@required this.devices, this.onChangePin, this.onLogout});

  final List<Device> devices;
  final VoidCallback onChangePin;
  final VoidCallback onLogout;


  @override
  build(context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ActionItem(
        label: 'My Devices',
        icon: Icon(Icons.devices)
      ),
      Container(
        padding: EdgeInsets.only(left: 72, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Devices associated with your account',
              style: TextStyle(fontSize: 12)
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              itemCount: devices.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final device = devices[index];
                return _DeviceEntry(device: device);
              },
            )
          ]
        )
      ),
      Divider(height: 1),
      _ActionItem(
        onPressed: onChangePin,
        label: 'Change PIN',
        icon: Icon(Icons.lock_outline)
      ),
      _ActionItem(
        onPressed: onLogout,
        label: 'Logout',
        icon: Icon(Icons.logout)
      )
    ],
  );

}

class _ActionItem extends StatelessWidget {

  _ActionItem({@required this.label, @required this.icon, this.onPressed});

  final String label;
  final Widget icon;
  final onPressed;

  @override
  build(context) => InkWell(
    onTap: onPressed,
    child: ListTile(
        leading: icon,
        title: Text(label)
    ),
  );
}

class _DeviceEntry extends StatelessWidget {

  _DeviceEntry({@required this.device});

  final Device device;

  @override
  build(context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(device.model),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(device.imei,
            style: Theme.of(context).textTheme.caption
          ),
          Text(device.registeredDate,
            style: Theme.of(context).textTheme.caption
          )
        ],
      )
    ],
  );
}