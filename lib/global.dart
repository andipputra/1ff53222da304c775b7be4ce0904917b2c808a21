import 'package:intl/intl.dart';

class Global {
  String numFormat(num? number) {
    return NumberFormat("###,###,###", "id_ID").format(number ?? 0);
  }
}
