import 'package:flutter/services.dart';

class IndNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    try{
      final newTextLength = newValue.text.length;
      final newText = StringBuffer();
      var selectionIndex = newValue.selection.end;
      var usedSubstringIndex = 0;
      if (newTextLength >= 6) {
        if(newTextLength<=11){
          newText.write(newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
          if (newValue.selection.end >= 5) selectionIndex ++;
        }
        else{
          newText.write(newValue.text.substring(2, usedSubstringIndex = 7) + ' ');
          if (newValue.selection.end >= 7) selectionIndex ++;
        }
      }
      if (newTextLength >= 11) {
        if(newTextLength<=11) {
          newText.write(newValue.text.substring(5, usedSubstringIndex = 10));
          if (newValue.selection.end >= 10) {
            selectionIndex++;
          }
        }
        else{
          newText.write(newValue.text.substring(7, usedSubstringIndex = 12));
          if (newValue.selection.end >= 12) {
            selectionIndex++;
          }
        }
      }
      // Dump the rest.
      if (newTextLength >= usedSubstringIndex) {
        newText.write(newValue.text.substring(usedSubstringIndex));
      }
      if(newText.length<=11)
        return TextEditingValue(
          text: newText.toString(),
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
      else
        return TextEditingValue(
          text: newText.toString().substring(0,11),
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
    }
    catch(E)
    {
      print(E);
      return TextEditingValue(text: "");
    }
  }
}