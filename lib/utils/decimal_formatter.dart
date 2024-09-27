import 'package:flutter/services.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

final TextInputFormatter decimalFormatter = NumberTextInputFormatter(
  // integerDigits: 10,
  decimalDigits: 2,
  // maxValue: '1000000000.00',
  decimalSeparator: '.',
  groupDigits: 3,
  groupSeparator: ',',
  allowNegative: false,
  // overrideDecimalPoint: true,
  insertDecimalPoint: true,
  // insertDecimalDigits: true,
);