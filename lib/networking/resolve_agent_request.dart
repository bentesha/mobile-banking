
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

    if (result.code == 200 && response['resolved_name'] != null) {
      final agent = Agent();
      agent.number = agentNumber;
      agent.name = response['resolved_name'];
      result.agent = agent;
    }

    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'reference_to_resolve': agentNumber,
    'channel_route': '4',
    'institution': NetworkRequest.INSTITUTION_ID
  };

  @override
  String get serviceId => '8';
}