import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class AccountController {

  Future<int?> emailNextButton(String email) async {
    try {
      print('Checking email: $email');

      final checkStatus = await supabase
          .from('profiles')
          .select()
          .eq('email', email.trim().toLowerCase())
          .maybeSingle();

      print('Query result: $checkStatus');

      if (checkStatus != null) {
        print('Existing: $checkStatus');
        return 1;
      } else {
        print('Not Found');
        return 0;
      }

    } catch (e) {
      print('Exception found: $e');
      return -1;
    }
  }
}
