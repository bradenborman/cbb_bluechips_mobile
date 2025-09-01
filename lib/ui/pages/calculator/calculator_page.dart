// lib/ui/pages/calculator/calculator_page.dart
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  static const route = '/calculator';
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _accumulator;
  String? _pendingOp; // '+', '-', '×', '÷'
  bool _resetOnNextDigit = false;

  void _tapDigit(String d) {
    setState(() {
      if (_resetOnNextDigit || _display == '0') {
        _display = d == '.' ? '0.' : d;
        _resetOnNextDigit = false;
      } else {
        if (d == '.' && _display.contains('.')) return;
        _display += d;
      }
    });
  }

  void _tapClear() {
    setState(() {
      _display = '0';
      _accumulator = null;
      _pendingOp = null;
      _resetOnNextDigit = false;
    });
  }

  void _tapSign() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  void _tapPercent() {
    setState(() {
      final v = double.tryParse(_display) ?? 0.0;
      _display = _trim((v / 100.0).toString());
    });
  }

  void _tapOp(String op) {
    setState(() {
      final current = double.tryParse(_display) ?? 0.0;

      if (_accumulator == null) {
        _accumulator = current;
      } else if (_pendingOp != null && !_resetOnNextDigit) {
        _accumulator = _apply(_accumulator!, current, _pendingOp!);
        _display = _trim(_accumulator!.toString());
      }

      _pendingOp = op;
      _resetOnNextDigit = true;
    });
  }

  void _tapEquals() {
    setState(() {
      if (_pendingOp == null || _accumulator == null) return;
      final current = double.tryParse(_display) ?? 0.0;
      final result = _apply(_accumulator!, current, _pendingOp!);
      _display = _trim(result.toString());
      _accumulator = null;
      _pendingOp = null;
      _resetOnNextDigit = true;
    });
  }

  double _apply(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) return double.nan;
        return a / b;
      default:
        return b;
    }
  }

  String _trim(String raw) {
    if (raw == 'NaN' || raw == 'Infinity' || raw == '-Infinity') return 'Error';
    if (raw.contains('e') || raw.contains('E')) return raw; // scientific okay
    if (raw.endsWith('.0')) return raw.substring(0, raw.length - 2);
    // Limit to 12 visible chars to avoid overflow; truncate gracefully
    if (raw.length > 14) {
      // If there is a decimal, try to keep as many as fit
      final idx = raw.indexOf('.');
      if (idx > 0) {
        final whole = raw.substring(0, idx);
        final dec = raw.substring(idx + 1);
        final remaining = 14 - whole.length - 1;
        if (remaining <= 0) return whole; // already too long
        final cut = remaining.clamp(0, dec.length);
        return '$whole.${dec.substring(0, cut)}';
      }
      return raw.substring(0, 14);
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              // Display
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _display,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Keypad
              _Keypad(
                onDigit: _tapDigit,
                onClear: _tapClear,
                onSign: _tapSign,
                onPercent: _tapPercent,
                onOp: _tapOp,
                onEquals: _tapEquals,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onClear;
  final VoidCallback onSign;
  final VoidCallback onPercent;
  final void Function(String) onOp;
  final VoidCallback onEquals;

  const _Keypad({
    required this.onDigit,
    required this.onClear,
    required this.onSign,
    required this.onPercent,
    required this.onOp,
    required this.onEquals,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget k(
      String label, {
      Color? bg,
      Color? fg,
      double flex = 1,
      VoidCallback? onTap,
      EdgeInsets padding = const EdgeInsets.symmetric(vertical: 18),
    }) {
      return Expanded(
        flex: (flex * 100).toInt(), // integer flex
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Material(
            color: bg ?? cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Padding(
                padding: padding,
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: fg ?? cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final opBg = cs.primary;
    final opFg = cs.onPrimary;
    final accentBg = cs.secondaryContainer;
    final accentFg = cs.onSecondaryContainer;

    return Column(
      children: [
        Row(
          children: [
            k('AC', bg: accentBg, fg: accentFg, onTap: onClear),
            k('±', bg: accentBg, fg: accentFg, onTap: onSign),
            k('%', bg: accentBg, fg: accentFg, onTap: onPercent),
            k('÷', bg: opBg, fg: opFg, onTap: () => onOp('÷')),
          ],
        ),
        Row(
          children: [
            k('7', onTap: () => onDigit('7')),
            k('8', onTap: () => onDigit('8')),
            k('9', onTap: () => onDigit('9')),
            k('×', bg: opBg, fg: opFg, onTap: () => onOp('×')),
          ],
        ),
        Row(
          children: [
            k('4', onTap: () => onDigit('4')),
            k('5', onTap: () => onDigit('5')),
            k('6', onTap: () => onDigit('6')),
            k('-', bg: opBg, fg: opFg, onTap: () => onOp('-')),
          ],
        ),
        Row(
          children: [
            k('1', onTap: () => onDigit('1')),
            k('2', onTap: () => onDigit('2')),
            k('3', onTap: () => onDigit('3')),
            k('+', bg: opBg, fg: opFg, onTap: () => onOp('+')),
          ],
        ),
        Row(
          children: [
            // Wide zero key
            Expanded(
              flex: 200,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Material(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onDigit('0'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            k('.', onTap: () => onDigit('.')),
            k('=', bg: opBg, fg: opFg, onTap: onEquals),
          ],
        ),
      ],
    );
  }
}
