import 'package:chat_test/api.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refugio Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Refugio Chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
      Echo echo = new Echo({
    'broadcaster': 'socket.io',
    'client': IO.io,
    'host': 'http://bec174fce65b.ngrok.io'
    },
    );
  List res = [];
  bool connected = false;
  TextEditingController msgController = TextEditingController();
  final GlobalKey<ScaffoldState> scaKey = new GlobalKey<ScaffoldState>();

    
  @override
  Widget build(BuildContext context) {  
  void connectToServer() {
    echo.channel('laravel_database_chat-t').listen('MessagePushed', (e) {
     print(e);
     res.add(e);
     setState(() {
       
     });
    }
    );
    setState(() {
      connected = true;
    });
  }
    return Scaffold(
      appBar: AppBar(
      key: scaKey,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               OutlineButton(
                child: Text("Sair"),
                onPressed: (){
                  echo.leave('laravel_database_chat-t');
                },
              ),
             ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: ListView.builder(
              itemCount: res.length + 1,
              itemBuilder: (context, index){
                if(index == 0){
                  return Padding(padding: EdgeInsets.all(5),
                  child: connected ? FlatButton(
                color: Colors.blue,
                child: Text("Você está conectado", style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onPressed: () {
                },
              ) : OutlinedButton(
                    child: Text('Conectar Socket IO', ),
                    onPressed: connectToServer,
                  ),);
                }
                index = index - 1;
                return ListTile(
                  title: Text("${res[index]['message']}"),
                );
              },
            ),),
            ListTile(
              title: TextFormField(
                controller: msgController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15,),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Insira algo',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Colors.black12
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Colors.black12
                    )
                  ),
                ),
              ),
              trailing: FlatButton(
                height: 42,
                color: Colors.blue,
                child: Text("Enviar", style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onPressed: () async{
                  if(msgController.text == ''){
                    showDialog(context: context, builder: (context){
                      return SimpleDialog(
                        contentPadding: EdgeInsets.all(20),
                        children: [
                          Text("Insira algo no campo fi de rapariga."),
                          Padding(padding: EdgeInsets.only(top:10),),
                          RaisedButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            child: Text('Okay, desculpa doutor.', style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            )
                        ],
                      );
                    },
                  );

                    return null;
                  }
                  var text = msgController.text;
                  msgController.text = '';
                  var res = await Api().sendMsg(text);
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom:10),)
          ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
