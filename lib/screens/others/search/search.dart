import 'package:eseepark/controllers/establishments/establishments_controller.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/search_model.dart';
import 'package:eseepark/providers/root_provider.dart';
import 'package:eseepark/screens/others/search/partials/search_all.dart';
import 'package:eseepark/screens/others/search/partials/search_filter.dart';
import 'package:eseepark/screens/others/search/partials/show_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final EstablishmentController controller = EstablishmentController();
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic> searchFilter = {};

  List<Establishment> searchedData = [];
  bool isSearching = false;

  bool listData = false;

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
  }

  TextSpan _highlightText(String text, String searchText) {
    List<TextSpan> spans = [];

    String lowerText = text.toLowerCase();
    String lowerSearchText = searchText.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerSearchText);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + searchText.length),
        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      ));

      start = index + searchText.length;
      index = lowerText.indexOf(lowerSearchText, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));
    }

    return TextSpan(children: spans);
  }

  Future<void> loadSearch(String val) async {
    if (searchFilter.isNotEmpty) {
      searchedData = await controller.searchEstablishmentsWithFilters(
        searchText: val,
        maxResults: 10,
        vehicleTypes: (searchFilter['vehicle_type'] as List?)?.cast<String>() ?? ['Car', 'Motorcycle'],
        maxRadiusKm: searchFilter['max_radius_km'] as double? ?? 100,
        rateTypes: (searchFilter['rate_types'] as List?)?.map((e) => e.toString().toLowerCase()).toList() ?? ['flat_rate', 'tiered_hourly'],
      );
    } else {
      searchedData = await controller.searchEstablishments(
        searchText: val,
        maxResults: 10,
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    final rootProvider = Provider.of<RootProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: screenWidth * 0.1,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    placeholder: 'Search here',
                    controller: searchController,
                    onChanged: (val) async {
                      setState(() {
                        searchedData.clear();
                        listData = false;
                      });

                     if(val.trim().isNotEmpty) {
                       setState(() {
                         isSearching = true;
                       });

                       await loadSearch(val);


                       // await Future.delayed(Duration(seconds: 2));
                       setState(() {
                         isSearching = false;
                       });
                     }
                    },
                    call: (val) {
                      print(val);

                      if(val) {
                        setState(() {
                          listData = false;
                        });
                      }
                    },
                    onSubmit: (val) {
                      print(val);

                      if((val ?? '').trim().isNotEmpty) {
                        String searchText = val.toString();

                        rootProvider.getGeneralProvider.saveSearch(
                            SearchModel(searchText: searchText, createdAt: DateTime.now())
                        );

                        setState(() {
                          listData = true;
                        });

                        print('searched: $searchText');
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
                    placeholderStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      fontSize: screenWidth * 0.035
                    ),
                    mainTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: screenWidth * 0.035
                    ),
                    borderRadius: 30,
                    horizontalPadding: screenWidth * 0.11,
                    textInputAction: TextInputAction.search,
                    clearText: true,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                InkWell(
                  onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      enableDrag: true,
                      builder: (context) => SearchFilter(filter: searchFilter)
                  ).then((val) async {
                    if(val is Map<String, dynamic>) {
                      setState(() {
                        searchFilter = val;
                      });

                      FocusScope.of(Get.context as BuildContext).unfocus();



                      if(searchController.text.trim().isNotEmpty) {
                        setState(() {
                          isSearching = true;
                        });

                        await loadSearch(searchController.text.trim());

                      }
                      setState(() {
                        isSearching = false;
                      });
                    }
                  }),
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  child: Container(
                    width: screenWidth * 0.07,
                    child: Icon(Icons.filter_list_outlined, size: screenSize * 0.02),
                  ),
                )
              ],
            ),
            Positioned(
              left: screenWidth * 0.04,
              bottom: 0,
              top: 0,
              child: SvgPicture.asset('assets/svgs/home/search.svg',
                width: screenWidth * 0.05,
              ),
            )
          ],
        ),
      ),
      body: !listData ? Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.014),
            if(searchController.text.trim().isNotEmpty)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05
                      ),
                      child: Text('Search for "${searchController.text.trim()}"',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                        child: !isSearching ?
                        ListView.builder(
                          itemCount: searchedData.length + 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if(index == searchedData.length) {
                              return InkWell(
                                onTap: () async {
                                  if (FocusManager.instance.primaryFocus != null) {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                  }

                                  setState(() {
                                    isSearching = true;
                                  });

                                  await loadSearch(searchController.text.trim());

                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: screenWidth * 0.1,
                                        width: screenWidth * 0.1,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.secondary,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.all(screenWidth * 0.021),
                                        child: SvgPicture.asset('assets/svgs/home/search.svg',
                                          width: screenWidth * 0.04,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                      Expanded(
                                        child: Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(searchController.text.trim(), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                              Text('Search',
                                                style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                                    fontSize: screenWidth * 0.025
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final establishment = searchedData[index];

                            return InkWell(
                              onTap: () {
                                if (FocusManager.instance.primaryFocus != null) {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                }

                                Get.to(() => ShowInfo(
                                  establishmentId: establishment.establishmentId,
                                  distance: establishment.distance,
                                ),
                                  duration: Duration(milliseconds: 300),
                                  transition: Transition.downToUp,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.01),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: screenWidth * 0.1,
                                      width: screenWidth * 0.1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.all(screenWidth * 0.021),
                                      child: SvgPicture.asset(
                                        establishment.establishmentType == 'Mall'
                                            ? 'assets/svgs/home/malls.svg'
                                            : establishment.establishmentType == 'Outdoor'
                                            ? 'assets/svgs/home/outdoor.svg'
                                            : '',
                                        width: screenWidth * 0.04,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: _highlightText(establishment.name, searchController.text.trim()),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(establishment.establishmentType,
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                                fontSize: screenWidth * 0.025
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ) :
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.03),
                          child: CupertinoActivityIndicator(),
                        )
                    )
                  ],
                ),
              ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              child: rootProvider.getGeneralProvider.searched.isNotEmpty && searchController.text.trim().isEmpty ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05
                    ),
                    child: Text('Recent Searches',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenSize * 0.013
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: rootProvider.getGeneralProvider.searched.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final search = rootProvider.getGeneralProvider.searched[index];

                      return InkWell(
                        onTap: () async {
                          searchController.text = search.searchText;

                          FocusScope.of(context).unfocus();

                          setState(() {
                            isSearching = true;
                          });

                          searchedData = await controller.searchEstablishments(
                              searchText: search.searchText,
                              maxResults: 10
                          );

                          setState(() {
                            listData = true;
                            isSearching = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.013,
                              horizontal: screenWidth * 0.05
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history),
                                  SizedBox(width: screenWidth * 0.04),
                                  Text(search.searchText, maxLines: 1, overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    rootProvider.getGeneralProvider.deleteSearch(search);
                                    setState(() {

                                    });
                                  },
                                  child: Icon(Icons.close)
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ) : null,
            )
          ],
        ),
      ) : searchedData.isNotEmpty ? SearchResultWords(searchedWords: searchController.text.trim(), establishments: searchedData) : SizedBox.shrink(),
    );
  }
}
