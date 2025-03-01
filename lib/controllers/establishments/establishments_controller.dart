import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:eseepark/models/parking_section_model.dart';
import 'package:eseepark/models/profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../main.dart';
import '../../models/feedback_model.dart';
import '../../models/parking_slot_model.dart';
import 'package:rxdart/rxdart.dart';

class EstablishmentController {
  final Stream<List<Establishment>> establishmentStream;

  // Stream<Establishment?> getEstablishmentById(String establishmentId) {
  //   return supabase
  //       .from('establishments')
  //       .stream(primaryKey: ['establishment_id'])
  //       .eq('establishment_id', establishmentId)
  //       .limit(1)
  //       .asyncMap((data) async {
  //     if (data.isEmpty) return null;
  //
  //     var est = data.first;
  //
  //     final ratesResponse = await supabase
  //         .from('parking_rates')
  //         .select('*')
  //         .eq('establishment_id', est['establishment_id'])
  //         .order('created_at', ascending: true);
  //
  //     ParkingRate? parkingRate;
  //     if (ratesResponse.isNotEmpty) {
  //       parkingRate = ParkingRate.fromMap(ratesResponse.first);
  //     }
  //
  //     List<ParkingSection> parkingSections = [];
  //     final sectionsResponse = await supabase
  //         .from('parking_sections')
  //         .select('*')
  //         .eq('establishment_id', est['establishment_id'])
  //         .order('created_at', ascending: true);
  //
  //
  //     for (var sectionMap in sectionsResponse) {
  //       ParkingSection section = ParkingSection.fromMap(sectionMap);
  //
  //       final slotsResponse = await supabase
  //           .from('parking_slots')
  //           .select('*')
  //           .eq('section_id', section.id)
  //           .order('created_at', ascending: true);
  //
  //       if(slotsResponse.isNotEmpty) {
  //         final slots = List<ParkingSlot>.from(slotsResponse.map((x) => ParkingSlot.fromMap(x)));
  //
  //         section = section.copyWith(parkingSlots: slots);
  //
  //         parkingSections.add(section);
  //       }
  //     }
  //
  //     // Query the average rating for the establishment
  //     final ratingResponse = await supabase
  //         .from('feedback_reviews')
  //         .select('*')
  //         .eq('establishment_id', est['establishment_id']);
  //
  //     double avgRating = 0.0;
  //     if (ratingResponse.isNotEmpty) {
  //       double total = ratingResponse
  //           .map<double>((review) => (review['rating'] as num).toDouble())
  //           .reduce((a, b) => a + b);
  //
  //       avgRating = total / ratingResponse.length;
  //       avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1)); // Ensure max 5 and round to 1 decimal place
  //     }
  //
  //     return Establishment.fromMap({
  //       ...est,
  //       'parking_rate': parkingRate?.toMap() ?? {},
  //       'parking_sections': parkingSections.map((section) => section.toMap()).toList(),
  //       'feedbacks': ratingResponse.map((feedback) => FeedbackModel.fromMap(feedback).toMap()).toList(),
  //       'feedbacks_total_rating': avgRating
  //     });
  //   });
  // }

  Stream<Establishment?> getEstablishmentById(String establishmentId) {
    return Rx.combineLatest4( // ✅ Added return here
      supabase.from('establishments').stream(primaryKey: ['establishment_id']).eq('establishment_id', establishmentId),
      supabase.from('parking_sections').stream(primaryKey: ['section_id']).eq('establishment_id', establishmentId),
      supabase.from('parking_slots').stream(primaryKey: ['slot_id']),
      supabase.from('feedback_reviews').stream(primaryKey: ['review_id']).eq('establishment_id', establishmentId),
          (estData, secData, slotData, feedbackData) => (estData, secData, slotData, feedbackData),
    ).asyncMap((data) async {
      final estData = data.$1;
      final secData = data.$2;
      final slotData = data.$3;
      final feedbackData = data.$4;

      if (estData.isEmpty) return null;

      var est = estData.first;

      // Fetch parking rates separately
      final ratesResponse = await supabase
          .from('parking_rates')
          .select('*')
          .eq('establishment_id', est['establishment_id'])
          .order('created_at', ascending: true);

      ParkingRate? parkingRate;
      if (ratesResponse.isNotEmpty) {
        parkingRate = ParkingRate.fromMap(ratesResponse.first);
      }

      // Convert sections
      List<ParkingSection> parkingSections = secData.map((sectionMap) {
        return ParkingSection.fromMap(sectionMap);
      }).toList();

      // Attach slots to sections
      for (var i = 0; i < parkingSections.length; i++) {
        final sectionSlots = slotData
            .where((slot) => slot['section_id'] == parkingSections[i].id)
            .map((slot) => ParkingSlot.fromMap(slot))
            .toList();

        parkingSections[i] = parkingSections[i].copyWith(parkingSlots: sectionSlots);
      }

      // Calculate average rating
      double avgRating = 0.0;
      if (feedbackData.isNotEmpty) {
        double total = feedbackData
            .map<double>((review) => (review['rating'] as num).toDouble())
            .reduce((a, b) => a + b);

        avgRating = total / feedbackData.length;
        avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1));
      }

      return Establishment.fromMap({
        ...est,
        'parking_rate': parkingRate?.toMap() ?? {},
        'parking_sections': parkingSections.map((section) => section.toMap()).toList(),
        'feedbacks': feedbackData.map((feedback) => FeedbackModel.fromMap(feedback).toMap()).toList(),
        'feedbacks_total_rating': avgRating
      });
    });
  }


  // Stream<List<Establishment>> getEstablishmentByIds(List<String> establishmentIds) {
  //   return supabase
  //       .from('establishments')
  //       .stream(primaryKey: ['establishment_id'])
  //       .inFilter('establishment_id', establishmentIds)
  //       .asyncMap((data) async {
  //     if (data.isEmpty) return [];
  //
  //     List<Establishment> establishments = [];
  //
  //     for (var est in data) {
  //       final ratesResponse = await supabase
  //           .from('parking_rates')
  //           .select('*')
  //           .eq('establishment_id', est['establishment_id'])
  //           .order('created_at', ascending: true);
  //
  //       ParkingRate? parkingRate;
  //       if (ratesResponse.isNotEmpty) {
  //         parkingRate = ParkingRate.fromMap(ratesResponse.first);
  //       }
  //
  //       List<ParkingSection> parkingSections = [];
  //       final sectionsResponse = await supabase
  //           .from('parking_sections')
  //           .select('*')
  //           .eq('establishment_id', est['establishment_id'])
  //           .order('created_at', ascending: true);
  //
  //       for (var sectionMap in sectionsResponse) {
  //         ParkingSection section = ParkingSection.fromMap(sectionMap);
  //
  //         final slotsResponse = await supabase
  //             .from('parking_slots')
  //             .select('*')
  //             .eq('section_id', section.id)
  //             .order('created_at', ascending: true);
  //
  //         if (slotsResponse.isNotEmpty) {
  //           final slots = List<ParkingSlot>.from(
  //               slotsResponse.map((x) => ParkingSlot.fromMap(x)));
  //           section = section.copyWith(parkingSlots: slots);
  //         }
  //         parkingSections.add(section);
  //       }
  //
  //       final ratingResponse = await supabase
  //           .from('feedback_reviews')
  //           .select('rating')
  //           .eq('establishment_id', est['establishment_id']);
  //
  //       double avgRating = 0.0;
  //       if (ratingResponse.isNotEmpty) {
  //         double total = ratingResponse
  //             .map<double>((review) => (review['rating'] as num).toDouble())
  //             .reduce((a, b) => a + b);
  //
  //         avgRating = total / ratingResponse.length;
  //         avgRating = avgRating > 5
  //             ? 5
  //             : double.parse(avgRating.toStringAsFixed(1)); // Ensure max 5 and round to 1 decimal place
  //       }
  //
  //       establishments.add(Establishment.fromMap({
  //         ...est,
  //         'parking_rate': parkingRate?.toMap() ?? {},
  //         'parking_sections': parkingSections.map((s) => s.toMap()).toList(),
  //         'feedbacks_total_rating': avgRating,
  //       }));
  //     }
  //
  //     return establishments;
  //   });
  // }

  Stream<List<Establishment>> getEstablishmentByIds(List<String> establishmentIds) {
    return Rx.combineLatest4(
      supabase.from('establishments').stream(primaryKey: ['establishment_id']).inFilter('establishment_id', establishmentIds),
      supabase.from('parking_sections').stream(primaryKey: ['section_id']).inFilter('establishment_id', establishmentIds),
      supabase.from('parking_slots').stream(primaryKey: ['slot_id']),
      supabase.from('feedback_reviews').stream(primaryKey: ['review_id']).inFilter('establishment_id', establishmentIds),
          (estData, secData, slotData, feedbackData) => (estData, secData, slotData, feedbackData),
    ).asyncMap((data) async {
      final estData = data.$1;
      final secData = data.$2;
      final slotData = data.$3;
      final feedbackData = data.$4;

      if (estData.isEmpty) return [];

      List<Establishment> establishments = [];

      // Fetch parking rates once for all establishments
      final ratesResponse = await supabase
          .from('parking_rates')
          .select('*')
          .inFilter('establishment_id', establishmentIds)
          .order('created_at', ascending: true);

      for (var est in estData) {
        // Get parking rate for this establishment
        ParkingRate? parkingRate = ratesResponse
            .where((rate) => rate['establishment_id'] == est['establishment_id'])
            .map((rate) => ParkingRate.fromMap(rate))
            .firstOrNull;

        // Get sections for this establishment
        List<ParkingSection> parkingSections = secData
            .where((section) => section['establishment_id'] == est['establishment_id'])
            .map((sectionMap) => ParkingSection.fromMap(sectionMap))
            .toList();

        // Attach slots to sections
        for (var i = 0; i < parkingSections.length; i++) {
          final sectionSlots = slotData
              .where((slot) => slot['section_id'] == parkingSections[i].id)
              .map((slot) => ParkingSlot.fromMap(slot))
              .toList();

          parkingSections[i] = parkingSections[i].copyWith(parkingSlots: sectionSlots);
        }

        // Calculate average rating
        double avgRating = 0.0;
        final estFeedbacks = feedbackData.where((review) => review['establishment_id'] == est['establishment_id']);
        if (estFeedbacks.isNotEmpty) {
          double total = estFeedbacks
              .map<double>((review) => (review['rating'] as num).toDouble())
              .reduce((a, b) => a + b);

          avgRating = total / estFeedbacks.length;
          avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1));
        }

        establishments.add(Establishment.fromMap({
          ...est,
          'parking_rate': parkingRate?.toMap() ?? {},
          'parking_sections': parkingSections.map((s) => s.toMap()).toList(),
          'feedbacks_total_rating': avgRating,
        }));
      }

      return establishments;
    });
  }


  Future<ProfileModel> getProfile(String userId) async {
    final profileResponse = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .limit(1);

    return ProfileModel.fromMap(profileResponse.first);
  }


  EstablishmentController()
      : establishmentStream = Rx.combineLatest4(
    supabase
        .from('establishments')
        .stream(primaryKey: ['establishment_id'])
        .eq('availability_status', 'operating')
        .order('created_at', ascending: true)
        .limit(10),
    supabase
        .from('parking_rates')
        .stream(primaryKey: ['rate_id']),
    supabase
        .from('parking_sections')
        .stream(primaryKey: ['section_id']),
    supabase
        .from('feedback_reviews')
        .stream(primaryKey: ['review_id']),
        (estData, ratesData, sectionsData, feedbackData) => (estData, ratesData, sectionsData, feedbackData),
  ).asyncMap((data) async {
    final estData = data.$1;
    final ratesData = data.$2;
    final sectionsData = data.$3;
    final feedbackData = data.$4;

    if (estData.isEmpty) return [];

    // Fetch parking slot counts in one query instead of looping
    final slotCountsResponse = await supabase
        .from('parking_slots')
        .select('section_id, COUNT(*)')
        .eq('status', 'available');

    final slotCounts = Map.fromEntries(
      slotCountsResponse.map((slot) => MapEntry(slot['section_id'], slot['count'] as int)),
    );

    List<Establishment> establishments = estData.map((est) {
      // Get parking rate for this establishment
      ParkingRate? parkingRate = ratesData
          .where((rate) => rate['establishment_id'] == est['establishment_id'])
          .map((rate) => ParkingRate.fromMap(rate))
          .firstOrNull;

      // Get sections for this establishment
      List<ParkingSection> parkingSections = sectionsData
          .where((section) => section['establishment_id'] == est['establishment_id'])
          .map((section) {
        int availableSlots = slotCounts[section['section_id']] ?? 0;
        return ParkingSection.fromMap(section);
      })
          .toList();

      // Calculate average rating
      double avgRating = 0.0;
      final estFeedbacks = feedbackData.where((review) => review['establishment_id'] == est['establishment_id']);
      if (estFeedbacks.isNotEmpty) {
        double total = estFeedbacks
            .map<double>((review) => (review['rating'] as num).toDouble())
            .reduce((a, b) => a + b);

        avgRating = total / estFeedbacks.length;
        avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1));
      }

      return Establishment.fromMap({
        ...est,
        'parking_rate': parkingRate?.toMap() ?? {},
        'parking_slots_count': parkingSections.fold(0.0, (sum, s) => sum + (s.parkingSlots?.where((slot) => slot.slotStatus == 'available').length ?? 0)),
        'feedbacks_total_rating': avgRating,
      });
    }).toList();

    return establishments;
  });

  Future<List<Establishment>> getNearbyEstablishmentsWithLocation({
    required double radiusKm,
    required int maxResults,
  }) async {
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

      final data = await supabase.rpc('get_nearby_establishments', params: {
        'user_lat': true ? 14.65688762458187 : position.latitude,
        'user_lng': true ? 121.10794013558173 : position.longitude,
        'radius_km': radiusKm,
        'max_results': maxResults,
      });

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

        print('counting ratings for establishment: ${est['id']}');
        // Query the average rating for the establishment
        final ratingResponse = await supabase
            .from('feedback_reviews')
            .select('rating')
            .eq('establishment_id', est['id']);

        print('rating response: $ratingResponse');
        double avgRating = 0.0;

        // Ensure ratingResponse is not null and contains valid ratings
        if (ratingResponse != null && ratingResponse.isNotEmpty) {
          List<double> ratings = ratingResponse
              .where((review) => review['rating'] != null) // Filter out null ratings
              .map<double>((review) => (review['rating'] as num).toDouble())
              .toList();

          if (ratings.isNotEmpty) {
            double total = ratings.reduce((a, b) => a + b);
            avgRating = total / ratings.length;
            avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1)); // Ensure max 5 and round to 1 decimal place
          }
        }

        print('Avg Rating Computed: $avgRating');


        Map<String, dynamic> updatedMap = {
          ...est,
          'parking_rate': parkingRate?.toMap() ?? {},
          'parking_slots_count': parkingSlotsCount,
          'feedbacks_total_rating': avgRating,
          'establishment_id': est['id'],
        }..remove('id');

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
  }) async {

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

      List<Establishment> establishments = [];

      for (var est in response) {
        if (est == null) continue;

        int parkingSlotsCount = 0;

        final sectionsResponse = await supabase
            .from('parking_sections')
            .select('*')
            .eq('establishment_id', est['establishment_id'])
            .order('created_at', ascending: true);

        if (sectionsResponse != null && sectionsResponse.isNotEmpty) {
          for (var sectionMap in sectionsResponse) {
            if (sectionMap == null) continue;

            final countResponse = await supabase
                .from('parking_slots')
                .select()
                .eq('section_id', sectionMap['section_id'])
                .eq('status', 'available')
                .count();

            if (countResponse != null) {
              parkingSlotsCount += countResponse.count ?? 0;
            }
          }
        }

        // Query the average rating for the establishment
        final ratingResponse = await supabase
            .from('feedback_reviews')
            .select('rating')
            .eq('establishment_id', est['establishment_id']);

        double avgRating = 0.0;
        if (ratingResponse.isNotEmpty) {
          double total = ratingResponse
              .map<double>((review) => (review['rating'] as num).toDouble())
              .reduce((a, b) => a + b);

          avgRating = total / ratingResponse.length;
          avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1)); // Ensure max 5 and round to 1 decimal place
        }

        establishments.add(Establishment.fromMap({
          ...est,
          'parking_rate': {
            'rate_type': est['rate_type']?.toString() ?? '',
            'flat_rate': est['flat_rate'] != null ? (est['flat_rate'] as num).toDouble() : 0.0,
            'base_rate': est['base_rate'] != null ? (est['base_rate'] as num).toDouble() : 0.0,
            'base_hours': est['base_hours'] as int?,
            'extra_hourly_rate': est['extra_hourly_rate'] != null ? (est['extra_hourly_rate'] as num).toDouble() : 0.0,
            'max_daily_rate': est['max_daily_rate'] != null ? (est['max_daily_rate'] as num).toDouble() : 0.0,
          },
          'parking_slots_count': parkingSlotsCount,
          'feedbacks_total_rating': avgRating,
        }));
      }

      for (var est in establishments) {
        print('Estab Id: ${est.establishmentId}');
        print('Parking Rate: ${est.parkingRate?.flatRate}');
        print('Available Parking Slots: ${est.parkingSlotsCount}');
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

      List<Establishment> establishments = [];

      for (var est in data) {
        if (est == null) {
          print('One of the establishments is null');
          continue;
        }
        print('Processing establishment: ${est['establishment_id']}');

        // Fetch parking rates
        final ratesResponse = await supabase
            .from('parking_rates')
            .select('*')
            .eq('establishment_id', est['establishment_id'])
            .order('created_at', ascending: true);

        ParkingRate? parkingRate;
        if (ratesResponse == null) {
          print('Rates response is null for establishment ID: ${est['establishment_id']}');
        } else if (ratesResponse.isNotEmpty) {
          parkingRate = ParkingRate.fromMap(ratesResponse.first);
        }

        // Fetch parking sections
        final sectionsResponse = await supabase
            .from('parking_sections')
            .select('*')
            .eq('establishment_id', est['establishment_id'])
            .order('created_at', ascending: true);

        int parkingSlotsCount = 0; // Default value
        if (sectionsResponse == null) {
          print('Sections response is null for establishment ID: ${est['establishment_id']}');
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

        // Query the average rating for the establishment
        final ratingResponse = await supabase
            .from('feedback_reviews')
            .select('rating')
            .eq('establishment_id', est['establishment_id']);

        double avgRating = 0.0;
        if (ratingResponse.isNotEmpty) {
          double total = ratingResponse
              .map<double>((review) => (review['rating'] as num).toDouble())
              .reduce((a, b) => a + b);

          avgRating = total / ratingResponse.length;
          avgRating = avgRating > 5 ? 5 : double.parse(avgRating.toStringAsFixed(1)); // Ensure max 5 and round to 1 decimal place
        }

        Map<String, dynamic> updatedMap = {
          ...est,
          'parking_rate': parkingRate?.toMap() ?? {},
          'parking_slots_count': parkingSlotsCount,
          'feedbacks_total_rating': avgRating
        }; // Remove the old key

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


}
