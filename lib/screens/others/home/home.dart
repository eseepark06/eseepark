  import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:eseepark/customs/custom_textfields.dart';
  import 'package:eseepark/screens/others/home/partials/establishments.dart';
  import 'package:eseepark/screens/others/home/partials/parking_sheet.dart';
import 'package:eseepark/screens/others/search/search.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_sticky_header/flutter_sticky_header.dart';
  import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
  import 'package:shimmer/shimmer.dart';

  import '../../../controllers/establishments/establishments_controller.dart';
  import '../../../globals.dart';
  import '../../../models/establishment_model.dart';

  class Home extends StatefulWidget {
    const Home({super.key});

    @override
    State<Home> createState() => _HomeState();
  }

  class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
    @override
    bool get wantKeepAlive => true;

    final EstablishmentController _controller = EstablishmentController();
    List<Establishment> nearbyEstablishments = [];
    bool isNearbyEstablishmentsLoaded = false;
    final scrollController = ScrollController();
    int selectedMenu = 0;
    int? selectedFilter;

    List<ParkingMenu> parkingMenus = [
      ParkingMenu(index: 0, name: 'All', svgAsset: 'all.svg'),
      ParkingMenu(index: 1, name: 'Mall', svgAsset: 'malls.svg'),
      ParkingMenu(index: 2, name: 'Outdoor', svgAsset: 'outdoor.svg'),
    ];

    List<FilterButton> filterButtons = [
      FilterButton(index: 0, name: 'Popular')
    ];

    @override
    void initState() {
      super.initState();


      onLoadPage();
    }

    Future<void> onLoadPage() async {
      nearbyEstablishments = (await _controller.getNearbyEstablishmentsWithLocation(radiusKm: 10, maxResults: 10)).cast<Establishment>();

      setState(() {
        isNearbyEstablishmentsLoaded = true;
      });
    }

    @override
    Widget build(BuildContext context) {
      super.build(context);
      double topPad = MediaQuery.of(context).padding.top;

      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: RefreshIndicator(
          onRefresh: () async {
            await onLoadPage();
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight * 0.11,
                            width: screenWidth,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Container(
                              height: screenHeight * 0.05,
                              width: screenWidth,
                              color: Colors.white
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                      top: screenHeight * 0.06,
                      bottom: screenHeight * 0.0,
                      child: Container(
                          width: screenWidth * 0.8,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => const Search(),
                                        duration: Duration(milliseconds: 300),
                                        transition: Transition.topLevel
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFD1D1D1),
                                          width: 0.5
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    height: screenHeight * 0.058,
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset('assets/svgs/home/search.svg',
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Flexible(
                                          child: Text('Where do you want to park?',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: screenSize * 0.011,
                                              color: const Color(0xFF808080),

                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Container(
                                height: screenHeight * 0.058,
                                width: screenHeight * 0.058,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFFD1D1D1),
                                      width: 0.5
                                  ),
                                ),
                                padding: EdgeInsets.all(screenSize * 0.007),
                                child: SvgPicture.asset('assets/svgs/home/qr-code.svg',
                                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                                  width: screenSize * 0.025,
                                ),
                              )
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ),
              SliverStickyHeader.builder(
                builder: (context, state) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                        minHeight: screenHeight * 0.1
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: state.isPinned
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: state.isPinned
                                    ? 2.5
                                    : screenHeight * 0.001))),
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: screenWidth,
                          height: state.isPinned ? screenHeight * 0.055 : 0,
                          margin: EdgeInsets.only(bottom: screenHeight * 0.012),
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                        if(state.isPinned)
                          AnimatedOpacity(
                            opacity: state.isPinned ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFD1D1D1),
                                              width: 0.5
                                          ),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        height: screenHeight * 0.058,
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset('assets/svgs/home/search.svg',
                                            ),
                                            SizedBox(width: screenWidth * 0.02),
                                            Flexible(
                                              child: Text('Where do you want to park?',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: screenSize * 0.011,
                                                  color: const Color(0xFF808080),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Container(
                                      height: screenHeight * 0.058,
                                      width: screenHeight * 0.058,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFFD1D1D1),
                                            width: 0.5
                                        ),
                                      ),
                                      padding: EdgeInsets.all(screenSize * 0.008),
                                      child: SvgPicture.asset('assets/svgs/home/qr-code.svg',
                                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        width: screenSize * 0.025,
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ),
                        if(state.isPinned)
                          SizedBox(height: screenHeight * 0.03),
                        Container(
                          decoration: const BoxDecoration(),
                          height: screenHeight * 0.1,
                          child: ListView.builder(
                            itemCount: parkingMenus.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final parking = parkingMenus[index];

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedMenu = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  constraints: BoxConstraints(
                                      minWidth: screenWidth * 0.17
                                  ),
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? screenWidth * 0.04 : screenSize * 0.01,
                                      right: index == (parkingMenus.length - 1) ? screenWidth * 0.04 : screenSize * 0.01
                                  ),
                                  child: Column(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child, Animation<double> animation) =>
                                            FadeTransition(opacity: animation, child: child),
                                        child: Container(
                                          key: ValueKey(selectedMenu == index ? 'selected_$index' : 'unselected_$index'),
                                          decoration: BoxDecoration(
                                            color: selectedMenu == index
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.secondary,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(screenSize * 0.009),
                                          child: SvgPicture.asset(
                                            'assets/svgs/home/${parking.svgAsset}',
                                            width: parking.svgCustomSize ?? screenSize * 0.02,
                                            colorFilter: ColorFilter.mode(
                                                selectedMenu == index ? Colors.white : const Color(0xFF808080),
                                                BlendMode.srcIn
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.008),
                                      Text(parking.name, style: TextStyle(
                                          color: selectedMenu == parking.index ? Theme.of(context).colorScheme.primary : const Color(0xFF808080),
                                          fontSize: screenSize * 0.01,
                                          fontWeight: selectedMenu == parking.index ? FontWeight.w600 : FontWeight.normal
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.054,
                          width: screenWidth,
                          margin: EdgeInsets.only(top: screenHeight * 0.016, bottom: screenHeight * 0.025),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: screenWidth * 0.05),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                  elevation: 0
                                ),
                                child: SvgPicture.asset('assets/svgs/home/filter.svg',
                                  width: screenSize * 0.02,
                                ),
                              ),
                              SizedBox(width: screenSize * 0.01),
                              for (FilterButton filterButton in filterButtons)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if(selectedFilter == filterButton.index) {
                                        selectedFilter = null;
                                      } else {
                                        selectedFilter = filterButton.index;
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedFilter != null ? selectedFilter == filterButton.index ? Theme.of(context).colorScheme.onPrimary : Colors.white : Colors.grey.shade400,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )
                                  ),
                                  child: Text(filterButton.name,
                                    style: TextStyle(
                                      fontSize: screenSize * 0.012,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                            ],
                          )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: isNearbyEstablishmentsLoaded ? nearbyEstablishments.isNotEmpty ?
                                  AnimatedSwitcher(
                                  switchInCurve: Curves.easeIn,
                                  switchOutCurve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 100),
                                  transitionBuilder: (Widget child, Animation<double> animation) =>
                                      FadeTransition(opacity: animation, child: child),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    key: ValueKey('establishments-list-nearby-${nearbyEstablishments.length ?? 0}'), // Key based on data length
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: nearbyEstablishments.where((e) => selectedMenu == 0 || e.establishmentType == parkingMenus[selectedMenu].name)
                                          .map((establishment) {
                                        final parkingRate = establishment.parkingRate;
                                        final parkingSlotsCount = establishment.parkingSlotsCount;

                                        return InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return ParkingSheet(establishmentId: establishment.establishmentId);
                                                });
                                          },
                                          child: Establishments(establishment: establishment, parkingMenus: parkingMenus, parkingRate: parkingRate, parkingSlotsCount: parkingSlotsCount),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ) :
                                  StreamBuilder(
                                    stream: _controller.establishmentStream,
                                    builder: (context, snapshot) {

                                      if (isNearbyEstablishmentsLoaded == false) {
                                        return Shimmer.fromColors(
                                          baseColor: const Color(0xFFEAEAEA),
                                          highlightColor: const Color(0xFFEAEAEA).withOpacity(0.4),
                                          enabled: true,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(
                                            width: screenWidth,
                                            height: screenHeight * 0.33,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.grey[300],
                                            ),
                                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                                            child: Center(
                                              child: Container(
                                                height: 20,
                                                width: 100,
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      return AnimatedSwitcher(
                                        switchInCurve: Curves.easeIn,
                                        switchOutCurve: Curves.easeOut,
                                        duration: const Duration(milliseconds: 100),
                                        transitionBuilder: (Widget child, Animation<double> animation) =>
                                            FadeTransition(opacity: animation, child: child),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          key: ValueKey('establishments-list-${snapshot.data?.length ?? 0}'), // Key based on data length
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: snapshot.data != null
                                                ? (snapshot.data ?? [])
                                                .where((e) => selectedMenu == 0 || e.establishmentType == parkingMenus[selectedMenu].name)
                                                .map((establishment) {
                                              final parkingRate = establishment.parkingRate;
                                              final parkingSlotsCount = establishment.parkingSlotsCount;

                                              return InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (context) {
                                                        return ParkingSheet(establishmentId: establishment.establishmentId);
                                                      });
                                                },
                                                child: Establishments(
                                                  establishment: establishment,
                                                  parkingMenus: parkingMenus,
                                                  parkingSlotsCount: parkingSlotsCount,
                                                  parkingRate: parkingRate,
                                                ),
                                              );
                                            }).toList()
                                                : [1, 2, 3].map((e) {
                                              return Shimmer.fromColors(
                                                baseColor: const Color(0xFFEAEAEA),
                                                highlightColor: const Color(0xFFEAEAEA).withOpacity(0.4),
                                                enabled: true,
                                                direction: ShimmerDirection.ltr,
                                                child: Container(
                                                  width: screenWidth,
                                                  height: screenHeight * 0.33,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.grey[300],
                                                  ),
                                                  margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                                                  child: Center(
                                                    child: Container(
                                                      height: 20,
                                                      width: 100,
                                                      color: Colors.grey[200],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }
                                ) : Shimmer.fromColors(
                                  baseColor: const Color(0xFFEAEAEA),
                                  highlightColor: const Color(0xFFEAEAEA).withOpacity(0.4),
                                  enabled: true,
                                  direction: ShimmerDirection.ltr,
                                  child: Container(
                                    width: screenWidth,
                                    height: screenHeight * 0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[300],
                                    ),
                                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 100,
                                        color: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        SizedBox(height: screenHeight * 2),

                      ],
                    ),
                  )
                ),
              ),
              SliverToBoxAdapter(
               child: Container(

               )
              )
            ],
          ),
        )
      );
    }
  }

class ParkingMenu {
  final int index;
  final String name;
  final String svgAsset;
  final double? svgCustomSize;

  ParkingMenu({required this.index, required this.name, required this.svgAsset, this.svgCustomSize});
}

class FilterButton {
  final int index;
  final String name;
  final String? value;
  final String? svgAsset;
  final double? svgCustomSize;

  FilterButton({required this.index, required this.name, this.value, this.svgAsset, this.svgCustomSize});
}


