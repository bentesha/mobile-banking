import 'package:mkombozi_mobile/models/service.dart';

class AirtimeService extends Service {
  String utility;
  String logo;

  AirtimeService.fromMap(Map<String, dynamic> data, this.utility)
      : super.fromMap(data);

  get name => utility;
  get description => 'Buy airtime for $utility';
}
