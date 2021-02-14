
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/agent.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/resolve_agent_response.dart';

class ResolveAgentRequest extends NetworkRequest<ResolveAgentResponse> {

  ResolveAgentRequest({@required this.account, @required this.agentNumber});

  final Account account;
  final String agentNumber;

  @override
  ResolveAgentResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = ResolveAgentResponse(code, message);
    result.description = response['description'];

    if (result.code == 200 && response['agent_name'] != null) {
      final agent = Agent();
      agent.name = response['agent_name'];
      agent.bankName = response['bank_name'];
      agent.branchName = response['bank_branch'];
      agent.account = response['agent_account'];
      result.agent = agent;
    }

    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'agent_id': agentNumber,
    'subscriber': account.subscriberId
  };

  @override
  String get serviceId => '9';



}