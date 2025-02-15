import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class AccountController {
  
  Future<int?> emailNextButton(String email) async {
    try {

      print('doing');

      final checkStatus = await supabase
          .from('profiles')
          .select()
          .eq('email', email);

      print(checkStatus);

      if(checkStatus.isNotEmpty) {
        print('Existing: $checkStatus');
        return 1;
      } else {
        print('Null');

        return 0;
      }
      
    } catch(e) {
      print('Exception found: $e');
    }
    
    return null;
  } 
}