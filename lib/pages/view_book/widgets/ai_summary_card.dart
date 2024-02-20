import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/providers/gemini_service.dart';
import 'package:provider/provider.dart';

class AISummarycard extends StatelessWidget {
  final Book bookdata;
  const AISummarycard({super.key, required this.bookdata});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final geminiAPIService = Provider.of<GeminiService>(context);
    final bookKey = '${this.bookdata.bookTitle}-${this.bookdata.bookAuthor}';

    // Check if the summary is available
    bool isSummaryAvailable = geminiAPIService.getBookSummary(bookKey) != null;

    double textHeight = 0.0;

    if (isSummaryAvailable) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: geminiAPIService.getBookSummary(bookKey)!,
          style: TextStyle(
            fontSize: 16.0, // Adjust the font size as needed
            color: context.onSecondaryContainer,
          ),
        ),
        maxLines: null,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: screenSize.width);

      // Calculate the height of the text
      textHeight = textPainter.size.height;
    }

    return Column(
      children: [
        // Card title with button to clear generated summary or generate new.
        if (isSummaryAvailable)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI generated summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  geminiAPIService.clearBookSummary(bookKey);
                },
                icon: Icon(
                  Icons.clear,
                  color: context.onSecondaryContainer,
                ),
              ),
            ],
          ),
        FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSummaryAvailable
                ? context.tertiaryContainer
                : context.secondaryContainer,
            padding: EdgeInsets
                .zero, // Set padding to zero to eliminate default padding

            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
          onPressed: () {
            geminiAPIService.generateGeminiText(
              bookName: this.bookdata.bookTitle,
              authorName: this.bookdata.bookAuthor,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCirc,
            height: isSummaryAvailable
                ? textHeight + 30
                : 50, // Adjust padding as needed
            width: isSummaryAvailable ? screenSize.width : 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: isSummaryAvailable
                ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: isSummaryAvailable ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              geminiAPIService.getBookSummary(bookKey)!,
                              style: TextStyle(
                                color: isSummaryAvailable
                                    ? context.onTertiaryContainer
                                    : context.onSecondaryContainer,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        geminiAPIService.isGeneratingSummary
                            ? const CustomProgressIndicator(
                                height: 34, width: 35)
                            : Icon(
                                MdiIcons.autoFix,
                                color: isSummaryAvailable
                                    ? context.onTertiaryContainer
                                    : context.onSecondaryContainer,
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              geminiAPIService.isGeneratingSummary
                                  ? 'Generating now'
                                  : 'AI Book Summary',
                              style: TextStyle(
                                color: isSummaryAvailable
                                    ? context.onTertiaryContainer
                                    : context.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
