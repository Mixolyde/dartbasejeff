// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library all_tests;

import 'dartbase_console_client_test.dart' as dartbase_console_client_test;
import 'print_test.dart' as print_test;
import 'print_board_test.dart' as print_board_test;
import 'print_cards_test.dart' as print_cards_test;

void main() {
  dartbase_console_client_test.main();
  print_test.main();
  print_board_test.main();
  print_cards_test.main();

}
