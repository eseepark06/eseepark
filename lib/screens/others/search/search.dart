import 'package:eseepark/controllers/establishments/establishments_controller.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/search_model.dart';
import 'package:eseepark/providers/root_provider.dart';
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

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
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
        title: Row(
          children: [
            Expanded(
              child: CustomTextField(
                placeholder: 'Search for establishments',
                controller: searchController,
                onChanged: (val) async {
                  setState(() {

                  });
                 if(val.trim().isNotEmpty) {
                   final data = await controller.searchEstablishments(searchText: val, maxResults: 10);

                   print(data.length);
                 }
                },
                call: (val) {
                  setState(() {

                  });
                },
                onSubmit: (val) {
                  print(val);

                  if((val ?? '').trim().isNotEmpty) {
                    String searchText = val.toString();

                    rootProvider.getGeneralProvider.saveSearch(
                        SearchModel(searchText: searchText, createdAt: DateTime.now())
                    );
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
                placeholderStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  fontSize: screenWidth * 0.035
                ),
                borderRadius: 30,
                horizontalPadding: screenWidth * 0.012,
                verticalPadding: screenHeight * 0.01,
                textInputAction: TextInputAction.search,
                clearText: true,
                prefixIcon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: screenWidth * 0.06,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Container(
              width: screenWidth * 0.07,
              child: Icon(Icons.filter_list_outlined, size: screenSize * 0.02),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.014),
            if(searchController.text.trim().isNotEmpty)
             Text('Search for "${searchController.text.trim()}"',
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                 fontWeight: FontWeight.w600,
               ),
             ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              child: rootProvider.getGeneralProvider.searched.isNotEmpty && searchController.text.trim().isEmpty ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Searches',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenSize * 0.013
                    ),
                  ),
                  ListView.builder(
                    itemCount: rootProvider.getGeneralProvider.searched.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final search = rootProvider.getGeneralProvider.searched[index];

                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.013
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
                      );
                    },
                  )
                ],
              ) : null,
            )
          ],
        ),
      ),
    );
  }
}
