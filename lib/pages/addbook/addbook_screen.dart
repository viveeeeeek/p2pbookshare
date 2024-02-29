// 297 lines of code before logic/concern seperations
// 178 lines after seperation
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/global/constants/app_constants.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/pages/addbook/addbook_handler.dart';

import 'widgets/widgets.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController authorCtrl = TextEditingController();
  TextEditingController publicationCtrl = TextEditingController();
  String? chosenCondition;
  String? chosenCategory;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final addbookHandler = Provider.of<AddbookHandler>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  //! To keep seperation between card and sunmit button cus of stacked
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              controller: titleCtrl,
                              labelText: 'Title *',
                              isMultiline: false),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: authorCtrl,
                            labelText: 'Author *',
                            isMultiline: false,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                              controller: publicationCtrl,
                              labelText: 'Publication',
                              isMultiline: false),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  addbookHandler
                                      .showAddressPickerBottomSheet(context);
                                },
                                child: Container(
                                    height: 75,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer),
                                    child: addbookHandler.completeAddress == ''
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(MdiIcons.mapMarker),
                                              const Text(
                                                'Select location for book exchange',
                                              ),
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    addbookHandler
                                                        .completeAddress,
                                                  ),
                                                ),
                                                const Icon(Icons.edit),
                                              ],
                                            ),
                                          )),
                              )),
                            ],
                          ),
                          const SizedBox(height: 3),
                          // ! Custom dropdown card for bookGenre & bookCondition
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropDownCard(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15)),
                                  selectedCondition: chosenCategory,
                                  hintIcon: const Icon(Icons.category_rounded),
                                  hintText: 'Genre',
                                  conditions: AppConstants.bookGenres,
                                  onChanged: (condition) {
                                    setState(() {
                                      chosenCategory = condition;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: CustomDropDownCard(
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(15)),
                                  selectedCondition: chosenCondition,
                                  hintIcon:
                                      const Icon(Icons.question_mark_rounded),
                                  hintText: 'Condition',
                                  conditions: AppConstants.bookConditions,
                                  onChanged: (condition) {
                                    setState(() {
                                      chosenCondition = condition;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ! Book cover image picker
                          GestureDetector(
                              onTap: () async {
                                await addbookHandler.handlePickImage(context);
                              },
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                          .withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  height: 180,
                                  width: 150,
                                  child: addbookHandler.pickedImage == null
                                      ? Icon(
                                          MdiIcons.image,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.file(
                                            addbookHandler.pickedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ))
                        ],
                      )),
                ),
              ),
            ),
            // ! Submit button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SubmitButton(
                  onPressed: () async {
                    addbookHandler.handleUploadBook(
                        context: context,
                        titleCtrl: titleCtrl,
                        authorCtrl: authorCtrl,
                        publicationCtrl: publicationCtrl,
                        // descriptionCtrl,
                        chosenCondition: chosenCondition,
                        chosenCategory: chosenCategory,
                        completeAddress: addbookHandler.completeAddress,
                        selectedImage: addbookHandler.pickedImage);
                  },
                  child: addbookHandler.isUploading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    publicationCtrl.dispose();
    super.dispose();
  }
}
