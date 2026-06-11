import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'constants/constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '0';
  String _result = '';

  static const List<List<String>> _rows = [
    ['AC', 'CE', '%', '/'],
    ['7', '8', '9', '*'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['00', '0', '.', '='],
  ];

  void _onPress(String label) {
    setState(() {
      if (label == 'AC') {
        _input = '0';
        _result = '';
      } else if (label == 'CE') {
        _input = _input.length > 1
            ? _input.substring(0, _input.length - 1)
            : '0';
      } else if (label == '=') {
        _evaluate();
      } else {
        _input = (_input == '0' && label != '.') ? label : _input + label;
      }
    });
  }

  // tries to evaluate _input; falls back to 'Error' if expression is invalid
  void _evaluate() {
    try {
      final exp = Parser().parse(_input);
      final eval = exp.evaluate(EvaluationType.REAL, ContextModel()) as double;
      _result = eval.toString();
    } catch (_) {
      _result = 'Error';
      _input = '0';
    }
  }

  Color _buttonColor(String label) {
    if (['AC', 'CE'].contains(label)) return AppColors.functionButton;
    if (_isOperator(label)) return AppColors.operatorButton;
    return AppColors.digitButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // display
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _displayText(
                    _input,
                    AppColors.displayText,
                    48,
                    FontWeight.bold,
                  ),
                  _displayText(
                    _result,
                    AppColors.secondaryDisplayText,
                    32,
                    FontWeight.normal,
                  ),
                ],
              ),
            ),

            // keyboard
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _rows.map(_buildRow).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayText(
    String text,
    Color color,
    double size,
    FontWeight weight,
  ) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: size, fontWeight: weight),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels.map(_buildButton).toList(),
    );
  }

  Widget _buildButton(String label) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: _buttonColor(label),
        fixedSize: const Size(75, 75),
      ),
      onPressed: () => _onPress(label),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

bool _isOperator(String label) =>
    ['%', '/', '*', '-', '+', '='].contains(label);
