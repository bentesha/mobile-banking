
import 'package:mkombozi_mobile/models/agent.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ResolveAgentResponse extends NetworkResponse {

  ResolveAgentResponse(int code, String message) : super(code, message);

  Agent agent;

}