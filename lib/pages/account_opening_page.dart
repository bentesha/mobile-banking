
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/phone_number_input_formatter.dart';
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/nida_verification_request.dart';
import 'package:mkombozi_mobile/networking/nida_verification_response.dart';
import 'package:mkombozi_mobile/networking/resolve_branch_request.dart';
import 'package:mkombozi_mobile/networking/resolve_branch_response.dart';
import 'package:mkombozi_mobile/pages/login.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:mkombozi_mobile/widgets/pill_button.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';

class AccountOpeningPage extends StatefulWidget {

  static navigateTo(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AccountOpeningPage()
    ));
  }

  @override
  createState() => _AccountOpeningPageState();

}

class _AccountOpeningPageState extends State<AccountOpeningPage> {

  final bloc = _Bloc();
  final _controllerPrimary = TextEditingController();
  final _controllerPhoneNumber = TextEditingController(text: '+255');
  Branch _branch;
  final _boldYellowStyle = TextStyle(
                      fontSize: 20,
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold
                    );

  @override
  void initState() {
    bloc.init();
    super.initState();
  }

  Future<bool> _handleWillPop() async {
    final state = bloc.state;
    switch(state.popAction) {
      case PopAction.exit:
        Navigator.of(context).pop();
        break;
      case PopAction.restart:
        bloc.init();
        return false;
        break;
      case PopAction.none:
        // Do nothing
        return false;
      case PopAction.prompt:
        return _canPopPage();
        break;
    }
    return true;
  }

  Future<bool> _canPopPage() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel account opening?'),
        content: Text('Account opening process will be canceled if you continue.'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('CANCEL')
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('CONTINUE')
          )
        ],
      )
    );
  }

  String _count(maxLength, currentLength) {
    if (maxLength <= currentLength) {
      return '';
    }
    return (maxLength - currentLength).toString();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: PrimaryBackgroundGradient()
        ),
        child: DefaultTextStyle(
          style : TextStyle(color: Colors.white),
          child: Center(
            child: WillPopScope(
              onWillPop: _handleWillPop,
              child: _buildContent(context)
            )
          )
        )
      ),
    );
  }

  Widget _buildContent(context) {
    return StreamBuilder<_PageState>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return _buildState(snapshot.data);
        }
        return Container();
      }
    );
  }

  Widget _buildState(_PageState state) {
    if(state is _InitState) {
      return _buildInit(state);
    } else if(state is _SelectBranchState) {
      return _buildSelectBranch(state);
    } else if (state is _QAState) {
      return _buildQA(state);
    } else if (state is _CompleteState) {
      return _buildCompleted(state);
    } else if (state is _LoadingState) {
      return ProgressView(color: AppTheme.accentColor);
    }
    return _buildFailed(state as _FailedState);
  }

  Widget _buildInit(_InitState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome', style: _boldYellowStyle),
        SizedBox(height: 16),
        Text('Enter your NIDA number and mobile number to begin'),
        SizedBox(height: 8),
        _TextField(
          controller: _controllerPrimary,
          label: 'Enter your NIDA number',
          inputFormatters: [NumberInputFormatter(length: 20)],
          inputType: TextInputType.number,
          onChanged: (_) => setState((){}),
          counter: _count(20, _controllerPrimary.text.length),
        ),
        SizedBox(height: 8),
        _TextField(
          controller: _controllerPhoneNumber,
          label: 'Mobile phone number',
          inputFormatters: [PhoneNumberInputFormatter()],
          inputType: TextInputType.number,
          onChanged: (_) => setState((){}),
          counter: _count(13, _controllerPhoneNumber.text.length),
        ),
        SizedBox(height: 32),
        PillButton(
          onPressed: _controllerPrimary.text.length == 20
            && _controllerPhoneNumber.text.length == 13
          ? () {
            final nin = _controllerPrimary.text;
            final phoneNumber = _controllerPhoneNumber.text;
            bloc.beginQA(nin, phoneNumber);
            _controllerPrimary.clear();
          }
          : null,
          caption: 'NEXT',
          color: AppTheme.accentColor,
        )
      ]
    );
  }

  Widget _buildSelectBranch(_SelectBranchState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select branch', style: _boldYellowStyle),
        SizedBox(height: 8),
        Text('Select the brach at which your account will be opened'),
        SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: DropdownButton<Branch>(
            hint: Text('Choose branch',
              style: TextStyle(color: Colors.white),
            ),
            value: _branch,
            selectedItemBuilder: (context) => 
              state.branches.map((branch) => Center(
                child: Text(branch.name, style: TextStyle(color: AppTheme.accentColor))
              )
            ).toList(),
            items: state.branches.map((branch) => DropdownMenuItem(
              value: branch,
              child: Text(branch.name),
            )).toList(),
            iconEnabledColor: AppTheme.accentColor,
            dropdownColor: AppTheme.accentColor,
            underline: Container(
              color: AppTheme.accentColor,
              height: 2,
              width: double.infinity,
            ),
            onChanged: (value) => setState(() => _branch = value),
          )
        ),
        SizedBox(height: 32),
        PillButton(
          onPressed: _branch != null
          ? () {
            bloc.selectBranch(_branch);
            _controllerPrimary.clear();
          }
          : null,
          caption: 'NEXT',
          color: AppTheme.accentColor
        )
      ],
    );
  }

  Widget _buildQA(_QAState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.questionEn),
        SizedBox(height: 8),
        Text(state.questionSw),
        SizedBox(height: 32),
        _TextField(
          controller: _controllerPrimary,
          label: 'Your answer',
          onChanged: (_) => setState((){}),
        ),
        SizedBox(height: 32),
        PillButton(
          onPressed: _controllerPrimary.text.length > 3
          ? () {
            bloc.submitAnswer(state.questionCode, _controllerPrimary.text);
            _controllerPrimary.clear();
          }
          : null,
          caption: 'NEXT',
          color: AppTheme.accentColor
        )
      ],
    );
  }

  Widget _buildCompleted(_CompleteState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Congratulation!',
          style: _boldYellowStyle
        ),
        SizedBox(height: 32),
        Text('You have successfully opened an account!'),
        SizedBox(height: 16),
        Text('You will receive shortly a PIN number that you can login to your account!'),
        SizedBox(height: 16),
        Text('Tap SIGN IN to sign to your new account!'),
        SizedBox(height: 32),
        PillButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          },
          caption: 'SIGN IN',
          color: AppTheme.accentColor
        )
      ],
    );
  }

  Widget _buildFailed(_FailedState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Sorry! Account opening was not successful!',
          style: _boldYellowStyle
        ),
        SizedBox(height: 32),
        Text(state.message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )
        ),
        SizedBox(height: 8),
        Text(state.description),
        SizedBox(height: 32),
        PillButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          caption: 'CLOSE',
          color: AppTheme.accentColor,
        ),
      ],
    );
  }

  @override
  void dispose() {
    bloc.close();
    _controllerPrimary.dispose();
    super.dispose();
  }

}

class _TextField extends StatelessWidget {
  _TextField(
      {@required this.label,
      this.inputFormatters = const [],
      this.obscuredText = false,
      this.onChanged,
      this.controller,
      this.inputType,
      this.prefix,
      this.counter});

  final String label;
  final List<TextInputFormatter> inputFormatters;
  final bool obscuredText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Widget prefix;
  final TextInputType inputType;
  final String counter;

  @override
  build(context) {
    final textStyle = TextStyle(
        fontSize: 18,
        color: AppTheme.accentColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 3);

    return TextField(
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      onChanged: onChanged,
      controller: controller,
      style: textStyle,
      textAlign: TextAlign.center,
      obscureText: obscuredText,
      obscuringCharacter: '*',
      cursorColor: AppTheme.accentColor,
      decoration: InputDecoration(
        prefixStyle: textStyle,
        prefix: prefix,
        hintText: label,
        counter: counter == null
        ? null
        : Text(counter,
          style: TextStyle(color: AppTheme.accentColor)
        ),
        hintStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 16),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.accentColor, width: 1),
        ),
      ),
    );
  }
}

class _Bloc {

  final _controller = StreamController<_PageState>();
  String _nin;
  String _phoneNumber;
  Branch _branch;
  _PageState _state;

  Stream<_PageState> get stream => _controller.stream;
  _PageState get state => _state;

  /// Initialises bloc state
  void init() {
    _emit(_InitState());
  }

  /// Starts Question & Answer session with NIDA
  void beginQA(String nin, String phoneNumber) async {
    _setLoading();
    _nin = nin;
    _phoneNumber = phoneNumber.substring(1); // Skip + sign
    final request = ResolveBranchRequest();
    final response = await request.send();
    final state = _mapResponseToState(response);
    _emit(state);
  }

  void selectBranch(Branch branch) async {
    _branch = branch;
    _setLoading();
    final request = NidaVerificationRequest(
      first: true,
      nin: _nin,
      phoneNumber: _phoneNumber,
      branch: _branch
    );
    final response = await request.send();
    final state = _mapResponseToState(response);
    _emit(state);
  }

  /// Submits answer to a question
  void submitAnswer(String questionCode, String answer) async {
    _setLoading();
    final request = NidaVerificationRequest(
      nin: _nin,
      phoneNumber: _phoneNumber,
      questionCode: questionCode,
      answer: answer,
      branch: _branch
    );
    final response = await request.send();
    final state = _mapResponseToState(response);
    _emit(state);
  }

  void _emit(_PageState state) {
    _state = state;
    _controller.add(state);
  }

  _PageState _mapResponseToState(NetworkResponse response) {
    if (response is NidaVerificationResponse && response.code == 200) {
      return _QAState(
        questionCode: response.questionCode,
        questionSw: response.questionSw,
        questionEn: response.questionEn
      );
    } else if(response is NidaVerificationResponse && response.code == 210) {
      return _CompleteState();
    } else if(response is ResolveBranchResponse && response.code == 200) {
      return _SelectBranchState(response.branches);
    } else {
      return _FailedState(
        message: response.message,
        description: response.description
      );
    }
  } 

  void _setLoading() {
    _controller.add(_LoadingState());
  }

  close() {
    _controller.close();
  }
}

/// The action to take when user wants to pop a page
/// while the page is at a given state
enum PopAction {
  /// Prompt user to exit page
  prompt,
  /// Restart from the inial state
  restart,
  /// Exit without prompt
  exit,
  /// Do nothing
  none
}

abstract class _PageState {
  _PageState(this.popAction);
  final PopAction popAction;
}

class _InitState extends _PageState {
  _InitState() : super(PopAction.prompt);
}

class _SelectBranchState extends _PageState {

  _SelectBranchState(this.branches) : super(PopAction.restart);

  final List<Branch> branches;
}

@immutable
class _QAState extends _PageState {

  _QAState({
    @required this.questionCode,
    @required this.questionSw,
    @required this.questionEn
  }) : super(PopAction.prompt);
  
  final String questionEn;
  final String questionSw;
  final String questionCode;
}

class _LoadingState extends _PageState {
  _LoadingState() : super(PopAction.none);
}

class _FailedState extends _PageState {

  _FailedState({
    @required this.message,
    @required this.description
  }) : super(PopAction.restart);

  final String message;
  final String description;
}

class _CompleteState extends _PageState {

  _CompleteState() : super(PopAction.exit);

}