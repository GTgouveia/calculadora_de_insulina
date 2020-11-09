import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _controladorGlicose = TextEditingController();
  final TextEditingController _controladorCarb = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  bool preenchendo, calculando;
  String doseTotal = "";
  @override
  void initState() {
    super.initState();
    preenchendo = false;
    calculando = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: calculando
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  preenchendo
                      ? Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    preenchendo = false;
                                    _formkey.currentState.reset();
                                    _controladorGlicose.clear();
                                    _controladorCarb.clear();
                                    doseTotal = "";
                                  });
                                },
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    setState(() {
                                      calculando = true;
                                    });
                                    num dose = await calcularDose(
                                      double.parse(_controladorGlicose.text),
                                      double.parse(_controladorCarb.text),
                                    );
                                    setState(() {
                                      calculando = false;
                                      doseTotal = dose.toStringAsPrecision(2);
                                    });
                                  }
                                },
                                child: Text(
                                  "Calcular",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: doseTotal == ""
                        ? Text(
                            preenchendo
                                ? "Não esqueça de informar a quantidade de carboidratos consumidos no momento!"
                                : "Seja bem vindo à calculadora de dose de insulina!",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                  "Dose total!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$doseTotal U",
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "images/insulina.png",
                                scale: 5,
                              ),
                              Image.asset(
                                "images/carboidrato.png",
                                scale: 5,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  controller: _controladorGlicose,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      preenchendo = true;
                                    });
                                  },
                                  onFieldSubmitted: (String value) {
                                    setState(() {
                                      _controladorGlicose.text.isEmpty &&
                                              _controladorCarb.text.isEmpty
                                          ? preenchendo = false
                                          : preenchendo = true;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Informe a quantidade de glicose!";
                                    } else if (int.parse(value) < 20 ||
                                        int.parse(value) > 600) {
                                      return "Valor incorreto!";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Ex: 20 mg/dl",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  controller: _controladorCarb,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      preenchendo = true;
                                    });
                                  },
                                  onFieldSubmitted: (String value) {
                                    setState(() {
                                      _controladorGlicose.text.isEmpty &&
                                              _controladorCarb.text.isEmpty
                                          ? preenchendo = false
                                          : preenchendo = true;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Informe a quantidade de carboidrato!";
                                    } else if (int.parse(value) > 200) {
                                      return "Valor incorreto!";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Ex: 200 g",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Future<num> calcularDose(double glicose, double carb) async {
  num dose = 0;
  dose = (glicose - carb) / 30;
  return dose;
}
