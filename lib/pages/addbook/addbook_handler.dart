import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/pages/address/address_selection_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';

import 'package:p2pbookshare/pages/addbook/widgets/book_added_bottom_sheet.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/providers/firebase/book_upload_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';

class AddbookHandler with ChangeNotifier {
  late final BookUploadService _fbBookOperations;
  late final UserDataProvider _userDataProvider;

  final imagePicker = ImagePicker();
  var imagePath = '';
  var fileName = '';
  File? _pickedImage;
  File? get pickedImage => _pickedImage;
  void setPickedImage(File? newImage) {
    _pickedImage = newImage;
    notifyListeners();
  }

  bool isUploading = false;
  var uploadedImgUrl = '';
  var dateTimeNow = DateTime.now();

  late LatLng selectedAddressLatLng;

  AddbookHandler(this._fbBookOperations, this._userDataProvider);

  /// Promps Address picker bottom sheet
  showAddressPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AddressPickerBottomSheet();
      },
    );
  }

  ///  Function to pick an image from the device
  Future<void> handlePickImage(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Select Image Source"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    /// Compressing the size of selected image
    if (source != null) {
      final pickedImgFile = await imagePicker.pickImage(source: source);

      if (pickedImgFile != null) {
        final tempDir = await getTemporaryDirectory();
        final outputPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedImgFile.path,
          outputPath,
          quality: 40,
          minWidth: 1024,
          minHeight: 1024,
        );

        if (compressedFile != null) {
          setPickedImage(File(compressedFile.path));
          imagePath = compressedFile.path;
          final formattedDate =
              '${dateTimeNow.year}${dateTimeNow.month}${dateTimeNow.day}${dateTimeNow.hour}${dateTimeNow.minute}${dateTimeNow.second}';
          fileName = '${formattedDate}_${pickedImgFile.name}';
          notifyListeners();
        }
      }
    }
  }

  var _completeAddress = '';
  get completeAddress => _completeAddress;

  /// Handle address selection here
  handleAddressSelection(
      {required BuildContext context,
      required String address,
      required LatLng addressLatLng}) {
    selectedAddressLatLng = addressLatLng;
    _completeAddress = address;
    notifyListeners();
    print(
        '✅✅✅ address latlng & address retreived $selectedAddressLatLng $completeAddress');
  }

  /// Handles image upload to firebase storage
  handleUploadImage() async {
    if (pickedImage != null) {
      final imgUrl =
          await _fbBookOperations.uploadCoverImage(pickedImage!, fileName);

      uploadedImgUrl = imgUrl!;
      notifyListeners();
    } else {
      // print('Selected image is null.');
      return null;
    }
  }

  /// Handles validation [addbook] inputt text fields
  handleValidateInputFields(
      BuildContext context,
      TextEditingController titleCtrl,
      TextEditingController authorCtrl,
      // TextEditingController publicationCtrl,
      // TextEditingController descriptionCtrl,
      String? chosenCondition,
      String? chosenCategory,
      File? selectedImage,
      String completeAddress) {
    if (titleCtrl.text.isNotEmpty &&
        authorCtrl.text.isNotEmpty &&
        // publicationCtrl.text.isNotEmpty &&
        completeAddress != '' &&
        chosenCondition != null &&
        chosenCategory != null &&
        selectedImage != null) {
      return true;
    } else {
      Utils.snackBar(
          context: context,
          message: 'Please fill all the required fields.',
          actionLabel: 'Dismiss',
          durationInSecond: 1,
          onPressed: () {});

      return false;
    }
  }

  /// Handles actual uploading of [book]
  handleUploadBook(
      {required BuildContext context,
      required TextEditingController titleCtrl,
      required TextEditingController authorCtrl,
      required TextEditingController publicationCtrl,
      // TextEditingController descriptionCtrl,
      String? chosenCondition,
      String? chosenCategory,
      File? selectedImage,
      required String completeAddress}) async {
    if (handleValidateInputFields(
            context,
            titleCtrl,
            authorCtrl,
            // publicationCtrl,
            // descriptionCtrl,
            chosenCondition,
            chosenCategory,
            selectedImage,
            completeAddress) ==
        true) {
      isUploading = true;
      notifyListeners();
      await handleUploadImage().whenComplete(() {
        isUploading = false;
        notifyListeners();
      });
    } else {
      Utils.snackBar(
          context: context,
          message: 'Please fill all the required fields.',
          actionLabel: 'Dismiss',
          durationInSecond: 2,
          onPressed: () {});
    }

    if (uploadedImgUrl.isNotEmpty) {
      // Create a Book object with the form data and other information.
      Book book = Book(
          bookTitle: titleCtrl.text,
          bookAuthor: authorCtrl.text,
          bookPublication: publicationCtrl.text,
          bookCondition: chosenCondition!,
          bookCategory: chosenCategory!,
          bookAvailability: true,
          bookCoverImageUrl: uploadedImgUrl,
          bookOwner: _userDataProvider.userModel!.userUid!,
          location: GeoPoint(
              selectedAddressLatLng.latitude, selectedAddressLatLng.longitude),
          completeAddress: _completeAddress);

      // Handle add book opeation here
      _fbBookOperations.addNewBookListing(book);

      //HACK asyncronous build context
      if (!context.mounted) return;
      bookAddedBottomSheet(context, uploadedImgUrl);
      // Clear the text controllers and other necessary cleanup
      titleCtrl.clear();
      authorCtrl.clear();
      publicationCtrl.clear();
//FIXME bookCategory& bookGenres are not resetting
      chosenCategory = '';
      chosenCondition = '';
      _completeAddress = '';
      notifyListeners();

      if (selectedImage != null) {
        selectedImage.delete(); // Delete the selected image
        setPickedImage(
            null); // Set selectedImage to null using the setter method

        notifyListeners();
      }
    }
  }
}
