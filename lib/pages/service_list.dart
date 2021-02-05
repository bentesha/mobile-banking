

import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:mkombozi_mobile/widgets/service_logo.dart';
import 'package:provider/provider.dart';

class ServiceListPage extends StatelessWidget {

  ServiceListPage(this.appCategoryId);

  final String appCategoryId;

  static Future<Service> navigateTo(BuildContext context, String appCategoryId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ServiceListPage(appCategoryId)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Select Service')
        ),
        body: SafeArea(
          child: Consumer<AccountService>(
            builder: (context, accountService, _) {
              return FutureBuilder<List<Service>>(
                initialData: [],
                future: accountService.getServiceByAppCategory(appCategoryId),
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

  Widget buildList(BuildContext context, List<Service> data) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final service = data[index];
        return InkWell(
          onTap: () { _handleItemSelected(context, service); },
          child: Container(
            constraints: BoxConstraints(
              minHeight: 80,
            ),
            child: Center(
              child: ListTile(
                title: Text(service.name ?? ''),
                subtitle: Text(service.description ?? ''),
                leading: ServiceLogo(
                    service: service,
                    height: 48,
                    width: 48,
                ),
              )
            )
          ),
        );
      },
    );
  }

  _handleItemSelected(BuildContext context, Service account) {
    Navigator.of(context).pop(account);
  }
}