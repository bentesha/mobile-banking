
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/widgets/pin_code_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeDialog extends StatelessWidget {

  static Future<String> show(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PinCodeDialog()
    ));
    // return showDialog<String>(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (context) => AlertDialog(
    //     title:Text('Enter PIN'),
    //     content: PinCodeTextField(
    //       onChanged: null,
    //       appContext: context,
    //       length: 4,
    //       keyboardType: TextInputType.number,
    //       obscureText: true,
    //       obscuringCharacter: '*',
    //       onCompleted: (value) {
    //         Navigator.of(context).pop<String>(value);
    //       },
    //     ),
    //     actions: [],
    //   )
    // );
  }

  @override
  build(context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.grey.shade800),
    ),
    body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 72),
                  SvgPicture.asset('assets/pin_lock.svg', height: 100, width: 100),
                  SizedBox(height: 36),
                  Text('Authentication Required',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  SizedBox(height: 16),
                  Text('Enter PIN to continue'),
                  SizedBox(height: 32),
                  SizedBox(
                      width: 200,
                      child: PinCodeInput(
                        onChanged: (value) {},
                        onCompleted: (pin) {
                          Navigator.of(context).pop(pin);
                        },
                      )
                  )
                ],
              )
          )
        )
    )
  );

}