
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/confirm_dialog.dart';
import 'package:mkombozi_mobile/widgets/action_button.dart';
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

  static WorkflowState<TState> of<TState>(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<WorkflowState<TState>>();
  }

}

class WorkflowState<TState> extends State<Workflow<TState>> {

  int index = 0;
  TState data;
  List<WorkflowItem> items = [];
  bool loading = false;

  @override
  initState() {
    data = widget.createWorkflowState();
    super.initState();
  }

  void updateState() {
    setState(() {
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
      setState(() {
        loading = true;
      });
      final result = item.complete(context);
      result.whenComplete(() {
        setState(() {
          loading = false;
        });
      });
      if (await result) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.grey.shade700),
        centerTitle: true,
      ),
      bottomNavigationBar: SizedBox(
        height: 58,
        child: ActionButton(
          caption: (index == 0 ? widget.actionLabel : widget.confirmLabel) ?? '',
          loading: loading,
          onPressed: loading ? null : _handleActionButton,
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
                        content: loading && items.indexOf(item) == items.length - 1 ? _LoadingStep() : item,
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

class _LoadingStep extends WorkflowItem {
  @override
  Widget build(context) => Column(
    children: [
      Text('Please Wait',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )
      ),
      SizedBox(height: 16),
      // Text('Sending money to Tigo Pesa 0713 898493'),
      SizedBox(height: 32),
      CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      )
    ],
  );

  String get title => 'Confirm';
}