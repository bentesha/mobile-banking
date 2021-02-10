

import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/networking/payment_request.dart';

class SendMoneyRequest extends PaymentRequest {

  WalletOrBank walletOrBank;

  @override
  Map<String, dynamic> get params {
    final params = super.params;
    if (walletOrBank.isWallet) {
      params['recipient_mobile'] = referenceNumber;
      params['wallet'] = walletOrBank.bin;
    } else {
      params['destination_bank'] = walletOrBank.bin;
      params['destination_account'] = referenceNumber;
    }
    return params;
  }

  @override
  String get serviceId => walletOrBank.isWallet ? '104' : '103';
}