import 'package:dotted_border/dotted_border.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: screenHeight * 0.9,
        width: screenWidth,
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Vehicle',
                        style: TextStyle(
                          fontSize: screenWidth * 0.075,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffcacaca)),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(screenSize * 0.01),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(30),
                            dashPattern: [5, 5],
                            color: Color(0xffcacaca),
                            strokeWidth: 2,
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width: screenWidth * 0.7,
                              height: screenWidth * 0.45,
                              decoration: BoxDecoration(
                                color: Color(0xffEAEAEA),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.car_repair,
                                    color: Color(0xffBABABA),
                                    size: screenWidth * 0.15,
                                  ),
                                  Text(
                                    'Attach Vehicle Photo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffBABABA),
                                    ),
                                  ),
                                  Text(
                                    'Must be JPG/PNG image file type (Optional)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffBABABA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Vehicle Type
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: InkWell(
                            child: CustomTextFieldWithLabel(
                              title: 'Vehicle Type',
                              placeholder: 'Select your vehicle type',
                              cursorColor: Theme.of(context).colorScheme.primary,
                              isEditable: false,
                              onClickField: () {
                                print('teststs');
                              },
                              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                              titleStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: screenSize * 0.012,
                              ),
                              placeholderStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                fontSize: screenSize * 0.012,
                              ),
                              mainTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.012,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              horizontalPadding: screenWidth * 0.05,
                              verticalPadding: screenHeight * 0.0165,
                              borderRadius: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Vehicle License Plate
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: CustomTextFieldWithLabel(
                            title: 'Vehicle License Plate',
                            placeholder: 'Enter your license plate',
                            cursorColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                            titleStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: screenSize * 0.012,
                            ),
                            placeholderStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                              fontSize: screenSize * 0.012,
                            ),
                            mainTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize * 0.012,
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                            horizontalPadding: screenWidth * 0.05,
                            verticalPadding: screenHeight * 0.0165,
                            borderRadius: 30,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Name Your Vehicle
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: CustomTextFieldWithLabel(
                            title: 'Name Your Vehicle',
                            placeholder: "Enter your vehicle's name",
                            cursorColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                            titleStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: screenSize * 0.012,
                            ),
                            placeholderStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                              fontSize: screenSize * 0.012,
                            ),
                            mainTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize * 0.012,
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                            horizontalPadding: screenWidth * 0.05,
                            verticalPadding: screenHeight * 0.0165,
                            borderRadius: 30,
                            bottomMessage: 'The name of the car will be displayed on Establishments and Receipts.',
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Vehicle Type
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: InkWell(
                            child: CustomTextFieldWithLabel(
                              title: 'Vehicle Type',
                              placeholder: 'Select your vehicle type',
                              cursorColor: Theme.of(context).colorScheme.primary,
                              isEditable: false,
                              onClickField: () {
                                print('teststs');
                              },
                              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                              titleStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: screenSize * 0.012,
                              ),
                              placeholderStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                fontSize: screenSize * 0.012,
                              ),
                              mainTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.012,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              horizontalPadding: screenWidth * 0.05,
                              verticalPadding: screenHeight * 0.0165,
                              borderRadius: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.034,
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.018,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}