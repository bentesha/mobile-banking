
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/pages/select_service.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';
import 'package:mkombozi_mobile/widgets/service_logo.dart';

class ServiceSelector extends StatefulWidget {

  ServiceSelector({@required this.label, @required this.icon, @required this.service, @required this.onChanged});

  final String label;
  final Widget icon;
  final Service service;
  final ValueChanged<Service> onChanged;

  @override
  createState() => _ServiceSelectorState();

}

class _ServiceSelectorState extends State<ServiceSelector> {

  Service _service;

  initState() {
    _service = widget.service;
    super.initState();
  }

  build(context) => FormCell(
    onPressed: () { _handleOnCellPressed(context); },
    label: widget.label,
    icon: widget.icon,
    trailing: Icon(Icons.chevron_right),
    child: Row(
      children: [
        _getServiceImage(),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_service?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18
                  )
              ),
              Container(
                  child: Text(_service?.description ?? '',
                      // overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey.shade600)
                  )
              )
            ],
          ),
        )
      ],
    )
  );
  
  _handleOnCellPressed(BuildContext context) async {
    final service = await SelectCategoryPage.navigateTo(context);
    if (service == null) {
      return;
    }
    setState(() {
      _service = service;
    });
    if (widget.onChanged != null) {
      widget.onChanged(service);
    }
  }
  
  Widget _getServiceImage() {
    return _service != null
        ? ServiceLogo(
            service: _service,
            height: 48,
            width: 48,
    ) : Container();
  }
}