import 'package:dotted_border/dotted_border.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import '../../../../../controllers/vehicles/vehicle_controller.dart';
import '../../../../../models/vehicle_model.dart'; // Import image package

class AddVehicle extends StatefulWidget {
  final List<Vehicle> userVehicles;

  const AddVehicle({
    super.key,
    required this.userVehicles
  });

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final TextEditingController vehicleType = TextEditingController();
  final TextEditingController vehicleCategory = TextEditingController();
  final TextEditingController vehicleLicensePlate = TextEditingController();
  final TextEditingController vehicleName = TextEditingController();

  File? selectedVehicleImage;

  final List<String> carCategories = [
    'Sedan', 'Hatchback', 'Crossover', 'SUV', 'MPV', 'Pickup', 'Van'
  ];

  final List<String> motorcycleCategories = [
    'Standard', 'Scooter', 'ATV', 'SUV', 'Cruiser', 'Sportbike', 'Tricycle'
  ];

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('Choose an option'),
          actions: [
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () async {
                Navigator.pop(context);
                XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  await _cropImage(File(pickedFile.path), context);
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  await _cropImage(File(pickedFile.path), context);
                }
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  Future<void> _cropImage(File imageFile, BuildContext context) async {
    if (!mounted) return; // Ensure the widget is still active

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.5, ratioY: 1),
      uiSettings: [
        if (mounted) // Check if widget is still active before using context
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(Get.context as BuildContext).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
        if (mounted)
          IOSUiSettings(
            title: 'Crop Image',
          ),
      ],
    );

    // Only update global variable if cropping was completed successfully
    if (croppedFile != null && mounted) {
      setState(() {
        selectedVehicleImage = File(croppedFile.path);
      });
      print("Cropped Image Path: ${selectedVehicleImage?.path}");
    }
  }

  Future<File?> compressImage(File file, {int targetSizeKB = 100}) async {
    final int targetSizeBytes = targetSizeKB * 1024;
    int quality = 80; // Start with high quality
    int minWidth = 1280; // Initial width

    File? compressedFile = file;

    do {
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.absolute.path}_compressed.jpg',
        quality: quality,
        minWidth: minWidth,
        minHeight: (minWidth * 0.75).toInt(), // Maintain aspect ratio
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        compressedFile = File(result.path);
      }

      quality -= 10; // Reduce quality gradually
      minWidth -= 200; // Decrease resolution step by step

    } while (compressedFile!.lengthSync() > targetSizeBytes && quality > 10 && minWidth > 600);

    return compressedFile;
  }

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
                    bottom: screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffcacaca),
                        width: .5
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Vehicle',
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
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
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          (MediaQuery.of(context).viewInsets.bottom > 0 ? screenHeight * 0.15 : 0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                          child: InkWell(
                            onTap: () => _pickImage(context),
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
                                padding: EdgeInsets.all(selectedVehicleImage == null ? screenWidth * 0.05 : 0),
                                child: selectedVehicleImage == null ? Column(
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
                                        fontWeight: FontWeight.w700,
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
                                ) :
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(selectedVehicleImage!, fit: BoxFit.fill)
                                ),
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
                              controller: vehicleType,
                              placeholder: 'Select your vehicle type',
                              cursorColor: Theme.of(context).colorScheme.primary,
                              isEditable: false,
                              onClickField: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) => CustomPicker(
                                    title: 'Select Vehicle Type',
                                    items: ['Car', 'Motorcycle'],
                                    withData: vehicleType,
                                  )
                              ).then((val) {
                                if(val != null && val is String) {
                                  setState(() {
                                    vehicleType.text = val;
                                    vehicleCategory.text = '';
                                  });
                                }
                              }),
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
                        SizedBox(height: screenHeight * 0.03),
                        // Vehicle Type
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: InkWell(
                            child: CustomTextFieldWithLabel(
                              title: 'Vehicle Category',
                              controller: vehicleCategory,
                              placeholder: 'Select your vehicle type',
                              cursorColor: Theme.of(context).colorScheme.primary,
                              isEditable: false,
                              onClickField: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => CustomPicker(
                                    title: 'Select Vehicle Category',
                                    items: vehicleType.text == 'Car'
                                        ? carCategories :
                                         vehicleType.text == 'Motorcycle' ?
                                          motorcycleCategories : [],
                                    withData: vehicleCategory,
                                  )
                              ).then((val) {
                                if(val != null && val is String) {
                                  setState(() {
                                    vehicleCategory.text = val;
                                  });
                                }
                              }),
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
                            controller: vehicleLicensePlate,
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
                              setState(() {
                                if(val.trim().isNotEmpty) {
                                  vehicleLicensePlate.text = val.toUpperCase();
                                }
                              });
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
                            controller: vehicleName,
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
              child: SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: (vehicleType.text.trim().isEmpty ||
                      vehicleCategory.text.trim().isEmpty ||
                      vehicleLicensePlate.text.trim().isEmpty ||
                      vehicleName.text.trim().isEmpty ||
                      (vehicleLicensePlate.text.trim().isNotEmpty && vehicleName.text.trim().isNotEmpty &&
                          widget.userVehicles.any((vehicle) =>
                          vehicle.licensePlate == vehicleLicensePlate.text.trim() ||
                              vehicle.name.toLowerCase() == vehicleName.text.trim().toLowerCase()))) ? null :
                      () async {
                    if (vehicleType.text.trim().isEmpty ||
                        vehicleCategory.text.trim().isEmpty ||
                        vehicleLicensePlate.text.trim().isEmpty ||
                        vehicleName.text.trim().isEmpty ||
                        (vehicleLicensePlate.text.trim().isNotEmpty && vehicleName.text.trim().isNotEmpty &&
                            widget.userVehicles.any((vehicle) =>
                            vehicle.licensePlate == vehicleLicensePlate.text.trim() ||
                                vehicle.name.toLowerCase() == vehicleName.text.trim().toLowerCase()))) {
                      return;
                    }

                    String formattedVehicleName = vehicleName.text.trim();
                    formattedVehicleName = formattedVehicleName[0].toUpperCase() + formattedVehicleName.substring(1);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );

                    final controller = VehicleController();

                    // ✅ **Compress the image before uploading**
                    File? compressedImage;
                    if (selectedVehicleImage != null) {
                      compressedImage = await compressImage(selectedVehicleImage!);
                    }

                    bool success = await controller.addVehicle(
                      vehicleType: vehicleType.text.trim(),
                      vehicleCategory: vehicleCategory.text.trim(),
                      vehicleLicensePlate: vehicleLicensePlate.text.trim(),
                      vehicleName: formattedVehicleName, // Capitalized name
                      vehicleImage: compressedImage ?? selectedVehicleImage, // Use compressed image if available
                    );

                    Navigator.pop(context);

                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add vehicle. Try again.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.016,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                  ),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}