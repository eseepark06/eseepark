import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/screens/others/home/partials/parking_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  List<Establishment> establishments = [
    Establishment(
        id: '0',
        name: 'SM City Marikina',
        type: '1',
        acceptsValet: true,
        availableSlots: 138,
        distance: 2.0,
        image: 'assets/images/home/establishments/smmarikina.jpg',
        price: 50.00,
        ratings: 4.5
    ),
    Establishment(
        id: '1',
        name: 'TaskUs Anonas Parking',
        type: '2',
        acceptsValet: false,
        availableSlots: 50,
        distance: 8.2,
        image: 'assets/images/home/establishments/taskusanonas.jpg',
        price: 45.00,
        succeedingCharge: 20,
        ratings: 4.2
    ),
    Establishment(
        id: '2',
        name: 'Bonifacio Global City Open Space',
        type: '2',
        acceptsValet: false,
        availableSlots: 72,
        distance: 15.4,
        image: 'assets/images/home/establishments/bgc.jpg',
        price: 65.00,
        succeedingCharge: 40,
        ratings: 4.2
    ),
    Establishment(
        id: '3',
        name: 'Ayala Malls Feliz',
        type: '1',
        acceptsValet: true,
        availableSlots: 98,
        distance: 10.1,
        image: 'assets/images/home/establishments/ayalamallsfeliz.jpg',
        price: 40.00,
        ratings: 4.2
    )
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
                      child: ListView.builder(
                        itemCount: selectedMenu == 0 ? establishments.length : establishments.where((e) => int.parse(e.type) == selectedMenu).length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final establishment = selectedMenu == 0 ? establishments[index] : establishments.where((e) => int.parse(e.type) == selectedMenu).toList()[index];
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return ParkingSheet();
                                  }
                              );
                            },
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.01),
                                    spreadRadius: 2,
                                    blurRadius: 3
                                  )
                                ]
                              ),
                              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(establishment.image),
                                            fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.01,
                                    left: screenWidth * 0.03,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: screenHeight * 0.003
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                      child: Text(parkingMenus[int.parse(establishment.type)].name, style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize * 0.0095,
                                          fontWeight: FontWeight.w700
                                      )),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: screenHeight * 0.01
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)
                                          ),
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                      child: Column(
                                        children: [
                                          Text(establishment.availableSlots.toString(), style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize * 0.012,
                                              height: 1,
                                              fontWeight: FontWeight.w700
                                          )),
                                          Text('slots',
                                            style: TextStyle(
                                              color: Colors.white,
                                              height: 1,
                                              fontSize: screenSize * 0.0095,
                                              fontWeight: FontWeight.w400
                                            ),
                                          )
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
                                        color: Colors.white
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                        vertical: screenHeight * 0.014
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(establishment.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                        fontSize: screenSize * 0.014,
                                                        fontWeight: FontWeight.bold
                                                      )),
                                                      Text('${establishment.distance} kilometers away',
                                                        style: TextStyle(
                                                          fontSize: screenSize * 0.0095,
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0xFF808080)
                                                        )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: screenWidth * 0.02),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star, size: screenSize * 0.014, color: Theme.of(context).colorScheme.primary),
                                                  SizedBox(width: screenWidth * 0.01),
                                                  Text(establishment.ratings.toString(),
                                                    style: TextStyle(
                                                      fontSize: screenSize * 0.011,
                                                      fontWeight: FontWeight.w400
                                                    )
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(text: '₱${establishment.price}', style: TextStyle(
                                                        fontSize: screenSize * 0.011,
                                                        fontFamily: 'HelveticaNeue',
                                                        color: const Color(0xFF808080)
                                                    )),
                                                      TextSpan(
                                                        text: establishment.succeedingCharge != null ? ' • First 4 hours' : ' • Fixed Parking Fee', style: TextStyle(
                                                          fontSize: screenSize * 0.009,
                                                          fontFamily: 'Poppins',
                                                          color: const Color(0xFF808080)
                                                      )

                                                      )
                                                  ]
                                                )
                                              ),
                                              if(establishment.acceptsValet)
                                                Text('Accepts Valet Parking',
                                                  style: TextStyle(
                                                    fontSize: screenSize * 0.008,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(0xFF808080)
                                                  ),
                                                )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          );
                        }
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



