import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:eseepark/models/parking_section_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
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
      .limit(10)
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

      int? parkingSlotsCount;

      final sectionsResponse = await supabase
          .from('parking_sections')
          .select('*')
          .eq('establishment_id', est['establishment_id'])
          .order('created_at', ascending: true);

      if (sectionsResponse.isNotEmpty) {
        for (var sectionMap in sectionsResponse) {
          // Query the count of parking slots for each section
          final countResponse = await supabase
              .from('parking_slots')
              .select()
              .eq('section_id', sectionMap['section_id'])
              .eq('status', 'available')
              .count(); // Use single() to get a single row response

          if (countResponse.count > 0) {
            parkingSlotsCount = countResponse.count; // Get the count from the response
          }
        }
      }
      establishments.add(Establishment.fromMap({
        ...est,
        'parking_rate': parkingRate?.toMap() ?? {},
        'parking_slots_count': parkingSlotsCount,
      }));
    }

    return establishments;
  });


  Future<List<Establishment>> getNearbyEstablishmentsWithLocation({
    required double radiusKm,
    required int maxResults,
  }) async {
    try {
      // Check location permissions and get current position
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return [];
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return [];
      }

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch nearby establishments
      final data = await supabase.rpc('get_nearby_establishments', params: {
        'user_lat': true ? 14.65688762458187 : position.latitude,
        'user_lng': true ? 121.10794013558173 : position.longitude,
        'radius_km': radiusKm,
        'max_results': maxResults,
      });

      // Debug print to inspect the raw data
      if (data == null) {
        print('Supabase RPC returned null');
        return [];
      }
      print('Raw data from API: $data');

      List<Establishment> establishments = [];

      for (var est in data) {
        if (est == null) {
          print('One of the establishments is null');
          continue;
        }
        print('Processing establishment: ${est['id']}');

        // Fetch parking rates
        final ratesResponse = await supabase
            .from('parking_rates')
            .select('*')
            .eq('establishment_id', est['id'])
            .order('created_at', ascending: true);

        ParkingRate? parkingRate;
        if (ratesResponse == null) {
          print('Rates response is null for establishment ID: ${est['id']}');
        } else if (ratesResponse.isNotEmpty) {
          parkingRate = ParkingRate.fromMap(ratesResponse.first);
        }

        // Fetch parking sections
        final sectionsResponse = await supabase
            .from('parking_sections')
            .select('*')
            .eq('establishment_id', est['id'])
            .order('created_at', ascending: true);

        int parkingSlotsCount = 0; // Default value
        if (sectionsResponse == null) {
          print('Sections response is null for establishment ID: ${est['id']}');
        } else if (sectionsResponse.isNotEmpty) {
          for (var sectionMap in sectionsResponse) {
            if (sectionMap == null) continue;

            // Query the count of parking slots for each section
            final countResponse = await supabase
                .from('parking_slots')
                .select()
                .eq('section_id', sectionMap['section_id'])
                .eq('status', 'available')
                .count();

            if (countResponse == null) {
              print('Parking slots count response is null for section ID: ${sectionMap['section_id']}');
            } else {
              parkingSlotsCount += countResponse.count ?? 0;
            }
          }
        }

        Map<String, dynamic> updatedMap = {
          ...est,
          'parking_rate': parkingRate?.toMap() ?? {},
          'parking_slots_count': parkingSlotsCount,
          'establishment_id': est['id'], // Add new key with old value
        }..remove('id'); // Remove the old key

        // Ensure that we are not adding null values
        establishments.add(Establishment.fromMap(updatedMap));
      }

      return establishments;
    } catch (e, stackTrace) {
      print('Error fetching nearby establishments: $e');
      print(stackTrace);
      return [];
    }
  }

  Future<List<Establishment>> searchEstablishmentsWithFilters({
    required String searchText,
    int maxResults = 10,
    double maxRadiusKm = 5.0,
    List<String> vehicleTypes = const ['Car', 'Motorcycle'],
    List<String>? rateTypes,
  })
  async  {
    print('Filtering by: searchText: $searchText, maxResults: $maxResults, maxRadiusKm: $maxRadiusKm, vehicleTypes: $vehicleTypes, rateTypes: $rateTypes');

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return [];
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return [];
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await supabase.rpc(
        'search_nearby_establishments_with_filters',
        params: {
          'user_lat': true ? 14.65688762458187 : position.latitude,
          'user_lng': true ? 121.10794013558173 : position.longitude,
          'search_text': searchText,
          'max_results': maxResults,
          'max_radius_km': maxRadiusKm,
          'vehicle_types': vehicleTypes,
          'rate_types': rateTypes,
        },
      );

      if (response == null || response is! List) {
        print('Supabase RPC returned null or invalid response');
        return [];
      }

      print(response);

      final List<Establishment> establishments = List<Map<String, dynamic>>.from(response).map((est) {
        return Establishment.fromMap({
          ...est,
          'parking_rate': {
            'rate_type': est['rate_type']?.toString() ?? '',  // Ensures String or empty string
            'flat_rate': est['flat_rate'] != null ? (est['flat_rate'] as num).toDouble() : 0.0,
            'base_rate': est['base_rate'] != null ? (est['base_rate'] as num).toDouble() : 0.0,
            'base_hours': est['base_hours'] as int?,
            'extra_hourly_rate': est['extra_hourly_rate'] != null ? (est['extra_hourly_rate'] as num).toDouble() : 0.0,
            'max_daily_rate': est['max_daily_rate'] != null ? (est['max_daily_rate'] as num).toDouble() : 0.0,
          }
        });
      }).toList();


      for (var est in establishments) {
        print('Estab Id: ${est.establishmentId}');
        print('Parking Rate: ${est.parkingRate?.flatRate}');
      }

      return establishments;
    } catch (e) {
      print('Error fetching establishments: $e');
      return [];
    }
  }





  Future<List<Establishment>> searchEstablishments({
    required String searchText,
    required int maxResults,
  })
  async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return [];
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return [];
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await supabase.rpc('search_nearby_establishments', params: {
        'user_lat': kDebugMode ? 14.65688762458187 : position.latitude,
        'user_lng': kDebugMode ? 121.10794013558173 : position.longitude,
        'search_text': searchText,
        'max_results': maxResults,
        'max_radius_km': 100
      });

      // Debug print to inspect the raw data
      if (data == null) {
        print('Supabase RPC returned null');
        return [];
      }

      print(data);


      List<Establishment> establishments = (data as List).map((item) => Establishment.fromMap(item)).toList();

      return establishments;

      // for (var est in data) {
      //   if (est == null) {
      //     print('One of the establishments is null');
      //     continue;
      //   }
      //   print('Processing establishment: ${est['id']}');
      //
      //   // Fetch parking rates
      //   final ratesResponse = await supabase
      //       .from('parking_rates')
      //       .select('*')
      //       .eq('establishment_id', est['id'])
      //       .order('created_at', ascending: true);
      //
      //   ParkingRate? parkingRate;
      //   if (ratesResponse == null) {
      //     print('Rates response is null for establishment ID: ${est['id']}');
      //   } else if (ratesResponse.isNotEmpty) {
      //     parkingRate = ParkingRate.fromMap(ratesResponse.first);
      //   }
      //
      //   // Fetch parking sections
      //   final sectionsResponse = await supabase
      //       .from('parking_sections')
      //       .select('*')
      //       .eq('establishment_id', est['id'])
      //       .order('created_at', ascending: true);
      //
      //   int parkingSlotsCount = 0; // Default value
      //   if (sectionsResponse == null) {
      //     print('Sections response is null for establishment ID: ${est['id']}');
      //   } else if (sectionsResponse.isNotEmpty) {
      //     for (var sectionMap in sectionsResponse) {
      //       if (sectionMap == null) continue;
      //
      //       // Query the count of parking slots for each section
      //       final countResponse = await supabase
      //           .from('parking_slots')
      //           .select()
      //           .eq('section_id', sectionMap['section_id'])
      //           .eq('status', 'available')
      //           .count();
      //
      //       if (countResponse == null) {
      //         print('Parking slots count response is null for section ID: ${sectionMap['section_id']}');
      //       } else {
      //         parkingSlotsCount += countResponse.count ?? 0;
      //       }
      //     }
      //   }

        // Map<String, dynamic> updatedMap = {
        //   ...est,
        //   'parking_rate': parkingRate?.toMap() ?? {},
        //   'parking_slots_count': parkingSlotsCount,
        //   'establishment_id': est['id'], // Add new key with old value
        // }..remove('id'); // Remove the old key
        //
        // // Ensure that we are not adding null values
        // establishments.add(Establishment.fromMap(updatedMap));
      // }

      // return establishments;
    } catch (e, stackTrace) {
      print('Error fetching nearby establishments: $e');
      print(stackTrace);
      return [];
    }
  }


}
