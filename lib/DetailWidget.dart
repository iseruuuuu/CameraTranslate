import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlkit/mlkit.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO 取得できたテキストをコピーする
//TODO 自然な翻訳になるサイトを探す。 ->DeepLのサイトはいいかも
//TODO https://www.deepl.com/ja/translator
//TODO 横にボタンをつけて翻訳画面に飛ぶ
//TODO コピーしたら、翻訳に飛ばす


//TODO 読み込んだデータをテキスト化した。
//TODO それをprint()で表現できた。(translationText)
//TODO なんとかしてlaurnchURl()に渡す
//TODO urlの一部に渡す。

//TODO　bool型で判断する？？？
//TODO　最初はfalseでlistが表示されたらtrueにしてtrueでボタンを押すと


//TODO データをコピーする。
//TODO リンクを飛ばす

class DetailWidget extends StatefulWidget {
  DetailWidget(this._file);
  final File _file;


  @override
  _DetailWidgetState createState() => new _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  FirebaseVisionTextDetector _detector = FirebaseVisionTextDetector.instance;
  List<VisionText> _currentTextLabels = <VisionText>[];

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 1000), () {
      this._analyzeLabels();

    });
  }

  _analyzeLabels() async {
    try {
      var currentTextLabels = await _detector.detectFromPath(widget._file.path);
      setState(() {
        _currentTextLabels = currentTextLabels;
      });
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("文字読み取り"),
        actions: [
          FlatButton(onPressed: () {
            _launchURL();
          },
            child: Text('翻訳する',style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          _buildTextList(_currentTextLabels),
        ],
      ),
    );
  }

  Widget _buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
        flex: 1,
        child: Center(
          child: Text('No text detected',
              style: Theme.of(context).textTheme.subhead),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: Container(

        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: texts.length,
          itemBuilder: (context, i) {
            return _buildTextRow(texts[i].text);
          },
        ),
      ),
    );
  }

  Widget _buildTextRow(text) {
    //TODO コピペはできたが、一部、１つのcellしかできない。＝＞一つにして複数にしたい
    final data11 = ClipboardData(text: '$text');
    Clipboard.setData(data11);
    return ListTile(
      title: SelectableText(
        "$text",
      ),
      dense: true,
    );
  }
}

_launchURL() async {
  const url = 'https://www.deepl.com/ja/translator#en/ja/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}