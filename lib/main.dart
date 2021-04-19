import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DetailWidget.dart';

//TODO 画面をアイフォン仕様にする？？　（できたらでいい。）


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("カメラ翻訳"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _startCamera(),
            FlatButton(onPressed:() {
              openTwitter();
            },
                child: Text("製作者に連絡する",style: TextStyle(color: Colors.black),)
            ),
          ],
        ),
      ),
    );
  }

  void openTwitter () async{
    final url = 'twitter://user?id=700937438802239488';
    await launch(url);
  }

  Widget _startCamera() {
    return Container(

      margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical:200 ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              width: 200,
              height: 100,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton(
                  elevation: 16,
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    _onPickImageSelected();
                  },
                  child: Text("カメラを起動する",style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPickImageSelected() async {
    var imageSource = ImageSource.camera;
    try {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('ファイルを取得できませんでした');
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailWidget(file)));
    } catch (e) {
    }
  }
}