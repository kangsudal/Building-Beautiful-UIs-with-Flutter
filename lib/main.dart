import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Add the following code to main.dart.

import 'package:flutter/cupertino.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() {
  runApp(FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  const FriendlychatApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposing = false;
  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              //new
              margin: new EdgeInsets.symmetric(horizontal: 4.0), //new
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      //new
                      child: new Text("Send"), //new
                      onPressed: _isComposing //new
                          ? () => _handleSubmitted(
                              _textEditingController.text) //new
                          : null,
                    )
                  : new IconButton(
                      //new
                      icon: new Icon(Icons.send), //new
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textEditingController.text)
                          : null), //new
            ), //new
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: AnimationController(
          vsync: this, duration: new Duration(milliseconds: 700)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("FriendlyChat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? new BoxDecoration(
                //new
                border: new Border(
                  //new
                  top: new BorderSide(color: Colors.grey[200]), //new
                ), //new
              )
            : null,
        child: Column(
          children: <Widget>[
            Flexible(
                child: new ListView.builder(
              padding: EdgeInsets.all(8),
              reverse: true,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            )),
            Divider(
              height: 1,
            ),
            Container(
              child: _buildTextComposer(),
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            ),
          ],
        ),
      ),
    );
  }
}

const String _name = "Your Name";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
