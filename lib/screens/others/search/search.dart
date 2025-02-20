import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged: (val) {
                  setState(() {

                  });
                },
                call: (val) {
                  setState(() {

                  });
                },
                onSubmit: (val) {
                  print(val);
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
          children: [
            SizedBox(height: screenHeight * 0.02),
            if(searchController.text.trim().isNotEmpty)
             Text('Search for "${searchController.text.trim()}"')
          ],
        ),
      ),
    );
  }
}
