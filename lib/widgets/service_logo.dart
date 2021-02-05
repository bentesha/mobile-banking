
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/models/service.dart';

class ServiceLogo extends StatelessWidget {

  ServiceLogo({@required this.service, this.height, this.width});

  final Service service;
  final double height;
  final double width;

  build(context) {
    const map = {
      'tanzania': 'assets/government-tz.png',
      'ic_tap': 'assets/water-tap.svg',
      'ic_light_bulb': 'assets/bulb.svg',
      'ic_pay': 'assets/payment.svg'
    };

    if (map[service.logo] != null) {
      final asset = map[service.logo];
      return asset.contains('.png') ? Image.asset(asset, width: width, height: height, fit: BoxFit.contain)
          : Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(0),
          child: SvgPicture.asset(asset, color: Colors.blue.shade800)
      );
    }
    return CachedNetworkImage(imageUrl: service.logoUrl, height: height, width: width);
  }

}