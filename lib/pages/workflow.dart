
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/service_selector.dart';

class Workflow extends StatefulWidget {

  Workflow(): super();

  @override
  State<StatefulWidget> createState() {
    return _WorkflowState();
  }

}

class _WorkflowState extends State<Workflow> {

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.close)
        ),
        elevation: 0,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
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
              FlatButton(
                onPressed: () {
                  setState(() {
                    if (index > 0) {
                      index--;
                    }
                  });
                },
                child: Text('CANCEL')
              ),
              SizedBox(width: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    index++;
                  });
                },
                child: Row(
                  children: [
                    Text('CONTINUE'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_right_alt_sharp)
                  ],
                ),
              )
            ],
          ),
        )
      ),
      body: SafeArea(
        child:
          Stepper(
            type: StepperType.horizontal,
            currentStep: index,
            controlsBuilder: (BuildContext context, {onStepCancel, onStepContinue}) {
              return Container();
            },
            onStepContinue: () {
              setState(() {
                index++;
              });
            },
            onStepCancel: () {
              setState(() {
                if (index == 0) {
                  return Navigator.pop(context);
                }
                setState(() {
                  index--;
                });
              });
            },
            onStepTapped: (index) {
              if (index == this.index) {
                return;
              }
              setState(() {
                this.index = index;
              });
            },
            steps: [
              Step(
                title: Text('Enter Details'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceSelector(),
                    FormCellDivider(height: 32),
                    FormCell(
                      label: 'Send from account',
                      description: 'Tap to change account',
                      icon: Icon(Icons.credit_card),
                      child: Text('**** **** **89 92',
                        style: TextStyle(
                          fontSize: 18
                        )
                      ),
                      trailing: Icon(Icons.credit_card_sharp),
                    ),
                    FormCellDivider(),
                    FormCellInput(
                      label: 'Control Number',
                      hintText: 'Enter control number',
                      icon: Icon(Icons.money)
                    ),
                    FormCellDivider(),
                    FormCellInput(
                        label: 'Amount to pay',
                        hintText: 'Enter amount to send. e.g 20,000',
                        inputType: TextInputType.number,
                        textAlign: TextAlign.right,
                        icon: Icon(Icons.attach_money),
                    ),
                    FormCellDivider(),
                    FormCellInput(
                        label: 'Reference',
                        hintText: 'Reference',
                        icon: Icon(Icons.notes),
                    )
                  ],
                ),
                state: StepState.indexed,
                isActive: index == 0
              ),
              Step(
                title: Text('Confirm'),
                content: Center(
                  child: Text('Second Step')
                ),
                state: StepState.disabled,
                isActive: index == 1
              ),
            ]
          )
      )
    );
  }

}