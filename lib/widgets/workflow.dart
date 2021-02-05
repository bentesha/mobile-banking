
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/confirm_dialog.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';

abstract class Workflow<TState> extends StatefulWidget {

  final String title;
  final String actionLabel;
  final String confirmLabel;

  Workflow({Key key, @required this.title, @required this.actionLabel, @required this.confirmLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WorkflowState<TState>();
  }

  bool isDirty(TState data);

  @protected
  List<WorkflowItem> build(BuildContext context, TState data);

  @protected
  TState createWorkflowState();

}

class WorkflowState<TState> extends State<Workflow<TState>> {

  int index = 0;
  TState data;
  List<WorkflowItem> items = [];

  @override
  initState() {
    data = widget.createWorkflowState();
    super.initState();
  }

  static WorkflowState<TState> of<TState>(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<WorkflowState>();
  }

  void updateState(TState state) {
    setState(() {
      data = state;
    });
  }

  Future<bool> _handleWillPop() async {
    if (index > 0) {
      setState(() {
        index--;
      });
      return false;
    }

    if (widget.isDirty(data)) {
      return ConfirmDialog.show(context, 'Discard', 'Are you sure you want to discard changes?');
    }

    return true;
  }

  _handleActionButton() async {
    if (index >= items.length) {
      return;
    }
    final item = items[index];
    if (!await item.moveNext(context)) {
      return;
    }
    if (index + 1 < items.length) {
      setState(() {
        index++;
      });
    } else {
      item.complete(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.close)
        // ),
        elevation: 0,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.grey.shade700),
        centerTitle: true,
      ),
      bottomNavigationBar: Material(
        // elevation: 8,
        // type: MaterialType.card,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 2
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _handleActionButton,
                child: Row(
                  children: [
                    Text((index == 0 ? widget.actionLabel : widget.confirmLabel) ?? ''),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_right_alt_sharp)
                  ],
                ),
              )
            ].where((w) => w != null).toList(),
          ),
        )
      ),
      body: SafeArea(
        child:
          WillPopScope(
            onWillPop: _handleWillPop,
            child: Builder(
              builder: (context) {
                items = widget.build(context, data);
                return Stepper(
                    type: StepperType.horizontal,
                    currentStep: index,
                    controlsBuilder: (BuildContext context, {onStepCancel, onStepContinue}) {
                      return Container();
                    },
                    onStepTapped: (index) async {
                      if (index == this.index) {
                        return;
                      }
                      final item = items[this.index];
                      if (!await item.moveNext(context)) {
                        return;
                      }
                      setState(() {
                        this.index = index;
                      });
                    },
                    steps: items.map((item) => Step(
                        title: Text(item.title),
                        content: item,
                        state: StepState.indexed,
                        isActive: item == items[index]
                    )).toList()
                );
              },
            ),
          )
      )
    );
  }

}