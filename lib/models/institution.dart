
class Institution {

  String id;
  String name;
  String bin;
  String logo;
  String primaryColor;
  String secondaryColor;
  String splashImage;
  String appLogo;
  String appTheme;
  String schemeId;

  Institution.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    bin = data['bin'];
    logo = data['logo'];
    primaryColor = data['primary_color'];
    secondaryColor = data['secondary_color'];
    splashImage = data['splash_image'];
    appLogo = data['app_logo'];
    appTheme = data['app_theme'];
    schemeId = data['scheme_id'];
  }

  Institution.fromNetwork(Map<String, dynamic> data) {
    name = data['txt_name'];
    bin = data['txt_BIN'];
    logo = data['txt_logo'];
    primaryColor = data['txt_primary_color'];
    secondaryColor = data['txt_secondary_color'];
    splashImage = data['txt_splash'];
    appLogo = data['txt_app_logo'];
    appTheme = data['opt_mx_app_theme'];
    schemeId = data['opt_mx_scheme_id'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'logo': logo,
    'primary_color': primaryColor,
    'secondary_color': secondaryColor,
    'splash_image': splashImage,
    'app_logo': appLogo,
    'scheme_id': schemeId
  };
}