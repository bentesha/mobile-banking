
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/networking/nida_verification_request.dart';
import 'package:mkombozi_mobile/networking/nida_verification_response.dart';
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
  final _textController = TextEditingController();
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
        Text('Enter your NIDA number'),
        SizedBox(height: 16),
        _TextField(
          controller: _textController,
          label: 'Enter your NIDA number',
          inputFormatters: [NumberInputFormatter(length: 20)],
          inputType: TextInputType.number,
          onChanged: (_) => setState((){}),
        ),
        SizedBox(height: 32),
        PillButton(
          onPressed: _textController.text.length == 20
          ? () {
            final nin = _textController.text;
            bloc.beginQA(nin);
            _textController.clear();
          }
          : null,
          caption: 'NEXT',
          color: AppTheme.accentColor,
        )
      ]
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
          controller: _textController,
          label: 'Your answer',
          onChanged: (_) => setState((){}),
        ),
        SizedBox(height: 32),
        PillButton(
          onPressed: _textController.text.length > 3
          ? () {
            bloc.submitAnswer(state.questionCode, _textController.text);
            _textController.clear();
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
    _textController.dispose();
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
      this.prefix});

  final String label;
  final List<TextInputFormatter> inputFormatters;
  final bool obscuredText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Widget prefix;
  final TextInputType inputType;

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
  _PageState _state;

  Stream<_PageState> get stream => _controller.stream;
  _PageState get state => _state;

  /// Initialises bloc state
  void init() {
    _emit(_InitState());
  }

  /// Starts Question & Answer session with NIDA
  void beginQA(String nin) async {
    _setLoading();
    _nin = nin;
    final request = NidaVerificationRequest(nin: nin, first: true);
    final response = await request.send();
    final state = _mapResponseToState(response);
    _emit(state);
  }

  /// Submits answer to a question
  void submitAnswer(String questionCode, String answer) async {
    _setLoading();
    final request = NidaVerificationRequest(
      nin: _nin,
      questionCode: questionCode,
      answer: answer
    );
    final response = await request.send();
    final state = _mapResponseToState(response);
    _emit(state);
  }

  void _emit(_PageState state) {
    _state = state;
    _controller.add(state);
  }

  _PageState _mapResponseToState(NidaVerificationResponse response) {
    if (response.code == 200) {
      return _QAState(
        questionCode: response.questionCode,
        questionSw: response.questionSw,
        questionEn: response.questionEn
      );
    } else if(response.code == 210) {
      return _CompleteState();
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