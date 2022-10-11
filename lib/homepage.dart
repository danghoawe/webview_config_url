import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_config_url/webpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController codeController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String? current = "";

  //fun st
  Future<void> storageCode(String code) async {
    await storage.write(key: "code", value: code);
  }

  Future<void> loadCode() async {
    await storage.read(key: "code").then((value) => setState(() {
          current = value;
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Load code form storage
    loadCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: current != null && current != ""
            ? WebPage(
                code: current!,
              )
            : Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: codeController,
                            decoration: InputDecoration(
                                hintText: "Nhập mã cần tra cứu"),
                            validator: ((value) {
                              if (value != null) {
                                return null;
                              }
                              return "Vui lòng nhập mã";
                            }),
                          ),
                          TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          WebPage(
                                        code: codeController.text,
                                      ),
                                    ),
                                  );
                                  storageCode(codeController.text);
                                }
                              },
                              child: const Text('Tra Cứu'))
                        ],
                      )),
                ),
              ));
  }
}
