

import 'package:mkombozi_mobile/networking/network_request.dart';

class Service {

  String id;
  String mti;
  String name;
  String description;
  String logo;
  String controlNumber;
  String categoryId;
  String appCategoryId;
  String stateId;
  String coreId;
  String rowValue;
  String limitCategoryId;

  Service.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    mti = data['mti'];
    name = data['name'];
    description = data['description'];
    logo = data['logo'];
    controlNumber = data['control_number_id'];
    categoryId = data['category_id'];
    stateId = data['state_id'];
    coreId = data['core_id'];
    rowValue = data['rowValue'];
    limitCategoryId = data['limit_category_id'];
  }

  Service.fromNetwork(Map<String, dynamic> data) {
    id = data['id'];
    name = data['txt_name'];
    mti = data['int_MTI'];
    logo = data['txt_logo'];
    controlNumber = data['opt_mx_has_control_number_id'];
    categoryId = data['opt_mx_service_category_id'];
    description = data['tar_description'];
    stateId = data['opt_mx_state_id'];
    coreId = data['opt_mx_core_id'];
    appCategoryId = data['opt_mx_app_category_id'];
    rowValue = data['txt_row_value'];
    limitCategoryId = data['opt_mx_limit_category_id'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'mti': mti,
    'name': name,
    'description': description,
    'logo': logo,
    'control_number_id': controlNumber,
    'category_id': categoryId,
    'app_category_id': appCategoryId,
    'state_id': stateId,
    'core_id': coreId,
    'row_value': rowValue,
    'limit_category_id': limitCategoryId
  };

  String get logoUrl {
    return NetworkRequest.SERVICE_IMAGE_BASE_URL + (logo ?? '');
  }
}