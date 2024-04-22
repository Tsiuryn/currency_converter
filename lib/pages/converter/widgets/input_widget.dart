
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final String prefix;
  final bool readOnly;
  final VoidCallback? onTapClear;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const InputWidget({
    super.key,
    required this.prefix,
    required this.readOnly,
    this.onTapClear,
    this.controller,
    this.focusNode,
  });

  @override
  State<InputWidget> createState() => InputWidgetState();
}

class InputWidgetState extends State<InputWidget> {
  bool _showClearButton = false;


  void clearButton(bool showClearButton){
    setState(() {
      _showClearButton = showClearButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CupertinoTextField(
        prefix: Text('  ${widget.prefix}: '),
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        readOnly: widget.readOnly,
        suffix: _showClearButton ? GestureDetector(
          onTap: widget.onTapClear?.call,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.clear,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ) : null,
        inputFormatters: [
          _NumberInputFormatter(),
        ],
      ),
    );
  }
}

class _NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (!newValue.text.startsWith('.') && RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
