import 'package:dio/dio.dart';

class Api{
  Dio dio = Dio();
  String apiUrl = 'https://onecliff.pagekite.me/api';

  sendMsg(msg)async{

  var res = await dio.post('$apiUrl/chat/send', data: {
      "message" : msg
    },
    );
    if(res.statusCode == 200){
      return 'Messagem Enviada';
    }
    return 'Erro no envio';
  }
  
}