import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dummyText =
      "Lorem Ipsum 09428033332,09428033332 is isssssss simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's"
      " standard dummy text ever since the +959332212344,"
      " employee-care@domain.com​  when an unknown printer took a galley of 959332212344 type and scrambled it to make a type specimen book."
      "It has survived not only five centuries, but also the leap into electronic typesetting,http://stackoverflow.com/questions/51985111/how-to-linkify-text-in-flutter/69888589#69888589"
      " remaining essentially unchanged. It wabcs popularised in the 1960s with the release of Letraset "
      "sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker "
      "including versions of Lorem Ipsum";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HyperTextView(
              dummyText: dummyText,
              hyperTextStyle: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
              textStyle: const TextStyle(
                fontSize: 18,
              ),
              hookType: [
                HyperTextOb(
                  hyperType: HyperType.email,
                  onPress: () => print("Email Click"),
                ),
                HyperTextOb(
                  hyperType: HyperType.url,
                  onPress: () => print("clicking url"),
                ),
                HyperTextOb(
                  hyperType: HyperType.mobileNumber,
                  onPress: () => print("Mobile Number"),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class HyperTextView extends StatelessWidget {
  final String dummyText;
  final TextStyle? hyperTextStyle;
  final TextStyle? textStyle;
  final List<HyperTextOb> hookType;
  final bool? isSelectable;

  const HyperTextView({
    required this.dummyText,
    required this.hookType,
    this.hyperTextStyle,
    this.textStyle,
    this.isSelectable = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: HyperTextGenerator(
          text: dummyText,
          hyperOb: hookType,
          hyperTextStyle: hyperTextStyle,
        ).getResult(),
        style: textStyle,
      ),
    );
  }
}

class HyperTextGenerator {
  final String text;
  final List<HyperTextOb?> hyperOb;
  final TextStyle? hyperTextStyle;
  List<TextSpan> textSpan = [];

  HyperTextGenerator({
    required this.text,
    required this.hyperOb,
    this.hyperTextStyle,
  }) {
   // int counter = 0;

    getLink(String linkString) {
      textSpan.add(
        TextSpan(
          style: hyperTextStyle,
          text: linkString,
          recognizer: TapGestureRecognizer()
            ..onTap = () => hyperOb[0]!.onPress!(),
        ),
      );
      return linkString;
    }

    getNormalText(String normalText) {

      textSpan.add(
        TextSpan(
          text: normalText,
        ),
      );
      return normalText;
    }

    text.splitMapJoin(
      RegExp(hyperOb[0]!.regex!),
      onMatch: (m) => getLink("${m.group(0)}"),
      onNonMatch: (n) => getNormalText(n.substring(0)),
    );
  }

  List<TextSpan> getResult() {
    return textSpan;
  }

}

class HyperTextOb {
  final HyperType? hyperType;
  final Function? onPress;
  String? regex;

  HyperTextOb({this.hyperType, this.regex, this.onPress})
      : assert(
          hyperType != null || regex != null,
          'Custom regex must be provide if Type is null',
        ) {
    if (hyperType == HyperType.url) {
      regex =
          r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";
    } else if (hyperType == HyperType.mobileNumber) {
      regex = r'(\+?(09|95)[0-9]{5,10})?';
    } else {
      regex = r'[-a-z0-9]*@[a-z]*\.[a-z]*';
    }
  }
}

enum HyperType {
  url,
  mobileNumber,
  email,
}
