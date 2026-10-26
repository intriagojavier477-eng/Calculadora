import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _history = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperand = true;

  // Manejo de la lógica de los botones
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _history = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isNewOperand = true;
      } else if (buttonText == '⌫') {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = '0';
          _isNewOperand = true;
        }
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _history = '$_output $_operand ';
        _isNewOperand = true;
      } else if (buttonText == '%') {
        double current = double.tryParse(_output) ?? 0;
        _output = (current / 100).toString();
        _formatOutput();
      } else if (buttonText == '±') {
        if (_output.startsWith('-')) {
          _output = _output.substring(1);
        } else if (_output != '0') {
          _output = '-$_output';
        }
      } else if (buttonText == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        _history += '$_output =';

        switch (_operand) {
          case '+':
            _output = (_num1 + _num2).toString();
            break;
          case '-':
            _output = (_num1 - _num2).toString();
            break;
          case '×':
            _output = (_num1 * _num2).toString();
            break;
          case '÷':
            if (_num2 == 0) {
              _output = 'Error';
            } else {
              _output = (_num1 / _num2).toString();
            }
            break;
        }
        _formatOutput();
        _operand = '';
        _isNewOperand = true;
      } else {
        // Números y punto decimal
        if (_isNewOperand || _output == '0' || _output == 'Error') {
          _output = buttonText == '.' ? '0.' : buttonText;
          _isNewOperand = false;
        } else {
          if (buttonText == '.' && _output.contains('.')) return;
          _output += buttonText;
        }
      }
    });
  }

  // Elimina ceros decimales innecesarios (ej. "5.0" pasa a "5")
  void _formatOutput() {
    if (_output != 'Error') {
      if (_output.endsWith('.0')) {
        _output = _output.substring(0, _output.length - 2);
      }
    }
  }

  // Widget para construir cada botón de forma limpia y reutilizable
  Widget _buildButton(String text, Color backgroundColor, Color textColor,
      {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Pantalla / Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _history,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _output,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            // Panel de Botones
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton(
                            'C', const Color(0xFF2C2C2E), Colors.redAccent),
                        _buildButton(
                            '±', const Color(0xFF2C2C2E), Colors.tealAccent),
                        _buildButton(
                            '%', const Color(0xFF2C2C2E), Colors.tealAccent),
                        _buildButton(
                            '÷', const Color(0xFF2C2C2E), Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton(
                            '7', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '8', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '9', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '×', const Color(0xFF2C2C2E), Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton(
                            '4', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '5', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '6', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '-', const Color(0xFF2C2C2E), Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton(
                            '1', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '2', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '3', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '+', const Color(0xFF2C2C2E), Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton(
                            '⌫', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '0', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton(
                            '.', const Color(0xFF1E1E1E), Colors.white),
                        _buildButton('=', Colors.orange, Colors.white),
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
