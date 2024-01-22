import 'package:calculator/history.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String equation = '';
  String result = '';
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        equation = '';
        result = '';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation.replaceAll('x', '*'));
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';

          saveHistory();
        } catch (e) {
          result = 'Error';
        }
      } else {
        equation += buttonText;
      }
    });
  }

  final historyBox = Hive.box<CalculationHistory>('history');

  void saveHistory() {
    final history = CalculationHistory(equation, result);
    historyBox.add(history);
    print(
        'History saved: Equation: ${history.equation}, Result: ${history.result}');
  }

  Widget calcButton(String btntxt, Color color) {
    return Container(
        child: ElevatedButton(
      onPressed: () {
        buttonPressed(btntxt);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff272B33),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        btntxt,
        style: TextStyle(color: color, fontSize: 30),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff22252D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: const Color(0xff22252D),
            height: MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              equation,
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              result,
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Color(0xff292D36),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('AC', Colors.green),
                        calcButton('(', Colors.green),
                        calcButton(')', Colors.green),
                        calcButton('/', Colors.pink),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('7', Colors.white),
                        calcButton('8', Colors.white),
                        calcButton('9', Colors.white),
                        calcButton('x', Colors.pink),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('4', Colors.white),
                        calcButton('5', Colors.white),
                        calcButton('6', Colors.white),
                        calcButton('-', Colors.pink),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('1', Colors.white),
                        calcButton('2', Colors.white),
                        calcButton('3', Colors.white),
                        calcButton('+', Colors.pink),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('0', Colors.white),
                        calcButton('%', Colors.white),
                        calcButton('.', Colors.white),
                        calcButton('=', Colors.pink),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
