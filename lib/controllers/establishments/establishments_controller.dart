import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:eseepark/models/parking_section_model.dart';
import '../../main.dart';
import '../../models/parking_slot_model.dart';

class EstablishmentController {
  // Stream for all establishments
  final Stream<List<Establishment>> establishmentStream;

  // Function to get a specific establishment
  Stream<Establishment?> getEstablishmentById(String establishmentId) {
    return supabase
        .from('establishments')
        .stream(primaryKey: ['establishment_id'])
        .eq('establishment_id', establishmentId)
        .limit(1)
        .asyncMap((data) async {
      if (data.isEmpty) return null;

      var est = data.first;

      final ratesResponse = await supabase
          .from('parking_rates')
          .select('*')
          .eq('establishment_id', est['establishment_id'])
          .order('created_at', ascending: true);

      ParkingRate? parkingRate;
      if (ratesResponse.isNotEmpty) {
        parkingRate = ParkingRate.fromMap(ratesResponse.first);
      }

      List<ParkingSection> parkingSections = [];
      final sectionsResponse = await supabase
          .from('parking_sections')
          .select('*')
          .eq('establishment_id', est['establishment_id'])
          .order('created_at', ascending: true);



      for (var sectionMap in sectionsResponse) {
        ParkingSection section = ParkingSection.fromMap(sectionMap);

        final slotsResponse = await supabase
            .from('parking_slots')
            .select('*')
            .eq('section_id', section.id)
            .order('created_at', ascending: true);

        if(slotsResponse.isNotEmpty) {
          final slots = List<ParkingSlot>.from(slotsResponse.map((x) => ParkingSlot.fromMap(x)));

          section = section.copyWith(parkingSlots: slots);

          parkingSections.add(section);
        }


      }


      return Establishment.fromMap({
        ...est,
        'parking_rate': parkingRate?.toMap() ?? {},
        'parking_sections': parkingSections.map((section) => section.toMap()).toList(),
      });
    });
  }

  EstablishmentController()
      : establishmentStream = supabase
      .from('establishments')
      .stream(primaryKey: ['establishment_id'])
      .eq('availability_status', 'operating')
      .order('created_at', ascending: true)
      .asyncMap((data) async {
    List<Establishment> establishments = [];

    print('Found: ${data.length} establishments');

    for (var est in data) {
      final ratesResponse = await supabase
          .from('parking_rates')
          .select('*')
          .eq('establishment_id', est['establishment_id'])
          .order('created_at', ascending: true);

      ParkingRate? parkingRate;
      if (ratesResponse.isNotEmpty) {
        parkingRate = ParkingRate.fromMap(ratesResponse.first);
      }

      establishments.add(Establishment.fromMap({
        ...est,
        'parking_rate': parkingRate?.toMap() ?? {},
      }));
    }

    return establishments;
  });
}
