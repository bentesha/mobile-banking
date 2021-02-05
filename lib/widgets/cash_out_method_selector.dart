import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/pages/select_cash_out_method.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class CashOutMethodSelector extends StatefulWidget {
  CashOutMethodSelector(
      {@required this.label,
      @required this.icon,
      @required this.method,
      @required this.onChanged});

  final String label;
  final Widget icon;
  final CashOutMethod method;
  final ValueChanged<CashOutMethod> onChanged;

  @override
  createState() => _CashOutMethodSelectorState();
}

class _CashOutMethodSelectorState extends State<CashOutMethodSelector> {
  CashOutMethod _method;

  initState() {
    _method = widget.method;
    super.initState();
  }

  build(context) => FormCell(
      onPressed: () {
        _handleOnCellPressed(context);
      },
      label: widget.label,
      icon: widget.icon,
      trailing: Icon(Icons.chevron_right),
      child: Row(
        children: [
          _getCashOutMethodImage(),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_method == CashOutMethod.atm ? 'ATM' : 'Agent',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18)),
                Container(
                    child: Text(
                        'Cash out from ${_method == CashOutMethod.atm ? 'ATM' : 'Agent'}',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.grey.shade600)))
              ],
            ),
          )
        ],
      ));

  _handleOnCellPressed(BuildContext context) async {
    final method = await SelectWithdrawalMethodPage.navigateTo(context);
    if (method == null) {
      return;
    }
    setState(() {
      _method = method;
    });
    if (widget.onChanged != null) {
      widget.onChanged(method);
    }
  }

  Widget _getCashOutMethodImage() {
    return _method == CashOutMethod.atm
        ? SvgPicture.asset('assets/atm.svg',
            height: 40, width: 40, color: Colors.blue.shade800)
        : Icon(Icons.support_agent, size: 48, color: Colors.blue.shade800);
  }
}
