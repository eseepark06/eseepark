import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/screens/others/home/partials/parking_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/establishments/establishments_controller.dart';
import '../../../globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final EstablishmentController _controller = EstablishmentController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            scrolledUnderElevation: 0,
            collapsedHeight: screenHeight * 0.15,
            shadowColor: Colors.transparent,
            title: Column(
              children: [
                Image.asset('assets/images/general/eseepark-transparent-logo-768.png',
                  width: screenWidth * 0.2,
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size(screenWidth, screenHeight * 0.0),
              child: Stack(
                children: [
                  Container(
                    child: Column( 
                      children: [
                        Container(
                          height: screenHeight * 0.03,
                          width: screenWidth,
                          color:  Theme.of(context).colorScheme.primary,
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
                    top: 0,
                    bottom: screenHeight * 0.01,
                    child: Container(
                      width: screenWidth * 0.8,
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
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
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
                                        fontSize: screenSize * 0.012,
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD1D1D1),
                                  width: 0.5
                              ),
                            ),
                            padding: EdgeInsets.all(screenSize * 0.004),
                            child: SvgPicture.asset('assets/svgs/home/qr-code.svg',
                              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                              width: screenSize * 0.025,
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              )
            ),
          ),
          SliverStickyHeader.builder(
            builder: (context, state) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                    minHeight: screenHeight * 0.12
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: state.isPinned
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: state.isPinned
                                ? screenHeight * 0.001
                                : screenHeight * 0.001))),
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: screenWidth,
                      height: state.isPinned ? screenHeight * 0.045 : screenHeight * 0.001,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                    if(state.isPinned)
                      AnimatedOpacity(
                        opacity: state.isPinned ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: const BoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                          margin: EdgeInsets.only(bottom: screenHeight * 0.014),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFD1D1D1),
                                      width: 0.5
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
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
                                            fontSize: screenSize * 0.012,
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
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle
                                ),
                                padding: EdgeInsets.all(screenSize * 0.004),
                                child: SvgPicture.asset('assets/svgs/home/qr-code.svg',
                                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  width: screenSize * 0.024,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.005),
                    Container(
                      decoration: const BoxDecoration(),
                      height: screenHeight * 0.12,
                      child: ListView.builder(
                        itemCount: parkingMenus.length,
                        scrollDirection: Axis.horizontal,
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
                                  minWidth: screenWidth * 0.2
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
                                        shape: BoxShape.circle,
                                        color: selectedMenu == index
                                            ? Theme.of(context).colorScheme.primary
                                            : Theme.of(context).colorScheme.secondary,
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
                                  SizedBox(height: screenHeight * 0.012),
                                  Text(parking.name, style: TextStyle(
                                      color: selectedMenu == parking.index ? Theme.of(context).colorScheme.primary : const Color(0xFF808080),
                                      fontSize: screenSize * 0.012,
                                      fontWeight: selectedMenu == parking.index ? FontWeight.bold : FontWeight.normal
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
            sliver: SliverToBoxAdapter(
              child: Container(
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
                              backgroundColor: Theme.of(context).colorScheme.primary,
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
                                backgroundColor: selectedFilter != null ? selectedFilter == filterButton.index ? Theme.of(context).colorScheme.primary : Colors.white : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2
                                  )
                                )
                              ),
                              child: Text(filterButton.name,
                                style: TextStyle(
                                  fontSize: screenSize * 0.012,
                                  color: selectedFilter != null ? selectedFilter == filterButton.index ? Colors.white : Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
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
                          StreamBuilder(
                              stream: _controller.establishmentStream,
                              builder: (context, snapshot) {
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
                                          child: Container(
                                            width: screenWidth,
                                            height: screenHeight * 0.33,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black.withOpacity(0.01),
                                                      spreadRadius: 2,
                                                      blurRadius: 3)
                                                ]),
                                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: screenHeight * 0.25,
                                                      decoration: BoxDecoration(
                                                          image: establishment.image!.isNotEmpty
                                                              ? DecorationImage(
                                                              image: NetworkImage(establishment.image!),
                                                              fit: BoxFit.cover)
                                                              : null,
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20))),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                  top: screenHeight * 0.01,
                                                  left: screenWidth * 0.03,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: screenWidth * 0.04,
                                                        vertical: screenHeight * 0.003),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: Theme.of(context).colorScheme.primary),
                                                    child: Text(
                                                      parkingMenus
                                                          .where((e) => e.name == establishment.establishmentType)
                                                          .toList()
                                                          .first
                                                          .name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: screenSize * 0.0095,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: screenWidth * 0.04,
                                                        vertical: screenHeight * 0.01),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(20),
                                                            bottomLeft: Radius.circular(20)),
                                                        color: (parkingSlotsCount ?? 0) > 0
                                                            ? Theme.of(context).colorScheme.primary
                                                            : const Color(0xFFD0D0D0)),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          parkingSlotsCount.toString(),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: screenSize * 0.012,
                                                              height: 1,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        Text(
                                                          'slots',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              height: 1,
                                                              fontSize: screenSize * 0.0095,
                                                              fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: screenHeight * 0.12,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Colors.white),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: screenWidth * 0.04,
                                                        vertical: screenHeight * 0.014),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    establishment.name,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize: screenSize * 0.014,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    '${1} kilometers away',
                                                                    style: TextStyle(
                                                                        fontSize: screenSize * 0.0095,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: const Color(0xFF808080)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(width: screenWidth * 0.02),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  size: screenSize * 0.014,
                                                                  color: Theme.of(context).colorScheme.primary,
                                                                ),
                                                                SizedBox(width: screenWidth * 0.01),
                                                                Text(
                                                                  4.5.toString(),
                                                                  style: TextStyle(
                                                                      fontSize: screenSize * 0.011,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                    '₱${double.parse((parkingRate?.flatRate ?? parkingRate?.baseRate).toString()).toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                        fontSize: screenSize * 0.011,
                                                                        fontFamily: 'HelveticaNeue',
                                                                        color: const Color(0xFF808080)),
                                                                  ),
                                                                  TextSpan(
                                                                    text: parkingRate?.flatRate == null
                                                                        ? ' • First ${parkingRate?.baseHours} hours'
                                                                        : ' • Fixed Parking Fee',
                                                                    style: TextStyle(
                                                                        fontSize: screenSize * 0.009,
                                                                        fontFamily: 'Poppins',
                                                                        color: const Color(0xFF808080)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                          ),
                        ],
                      )
                    )
                  ],
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
           child: Container()
          )
        ],
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

class Establishment {
  final String id;
  final String name;
  final String type;
  final int availableSlots;
  final String image;
  final double distance;
  final double price;
  final double? succeedingCharge;
  final double ratings;
  final bool acceptsValet;

  Establishment({
    required this.id,
    required this.name,
    required this.type,
    required this.availableSlots,
    required this.image,
    required this.distance,
    required this.price,
    this.succeedingCharge,
    required this.ratings,
    required this.acceptsValet
  });
}



