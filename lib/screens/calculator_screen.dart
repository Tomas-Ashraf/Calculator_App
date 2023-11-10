import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String result = '0';

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    userInput,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemBuilder: (BuildContext context, int index) {
                  return customButton(buttonList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customButton(String text) {
    return InkWell(
      splashColor: Colors.black12,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
            color: getCustomColor(text),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 0.5,
                  offset: const Offset(2, 2))
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: getTextColor(text),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  getCustomColor(String text) {
    if (text == 'AC') {
      return Colors.red;
    }
    if (text == '=') {
      return HexColor('663399');
    } else {
      return HexColor('333739');
    }
  }

  getTextColor(String text) {
    if (text == '(' ||
        text == ')' ||
        text == '/' ||
        text == '*' ||
        text == '+' ||
        text == '-' ||
        text == 'C') {
      return Colors.deepOrange;
    } else {
      return Colors.white;
    }
  }

  handleButtons(String text) {
    if (text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }
    if (text == 'C') {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }
    if (text == '=') {
      result = calculate();
      userInput = result;
      if (userInput.endsWith('.0')) {
        userInput = userInput.replaceAll('.0', '');
      }
      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
        return;
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evalution = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evalution.toString();
    } catch (e) {
      return 'ERROR';
    }
  }
}
