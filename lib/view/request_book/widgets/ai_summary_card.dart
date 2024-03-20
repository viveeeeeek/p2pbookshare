import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/provider/others/gemini_service.dart';
import 'package:p2pbookshare/provider/shared_prefs/ai_summary_prefs.dart';
import 'package:provider/provider.dart';

class AISummarycard extends StatefulWidget {
  final Book bookdata;
  final AISummaryPrefs aiSummarySPrefs;

  const AISummarycard({
    super.key,
    required this.bookdata,
    required this.aiSummarySPrefs,
  });

  @override
  State<AISummarycard> createState() => _AISummarycardState();
}

class _AISummarycardState extends State<AISummarycard>
    with SingleTickerProviderStateMixin {
  late final String _bookKey =
      '${widget.bookdata.bookTitle}-${widget.bookdata.bookAuthor}';

  @override
  void initState() {
    super.initState();
    widget.aiSummarySPrefs.fetchSummary(_bookKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _calculateSummaryHeight(String summary) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: summary,
        style: TextStyle(
          fontSize: 16.0, // Adjust the font size as needed
          color: context.onSecondaryContainer,
        ),
      ),
      maxLines: null,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    // Calculate the height of the text
    final textHeight = textPainter.size.height;
    return textHeight;
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer2<GeminiService, AISummaryPrefs>(
      builder: (context, geminiService, aiSummaryPrefs, child) {
        return Column(
          children: [
            if (aiSummaryPrefs.hasSummary == true)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Generated Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      aiSummaryPrefs.removeSummary(_bookKey);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: context.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: aiSummaryPrefs.hasSummary
                  ? _calculateSummaryHeight(aiSummaryPrefs.geminiResponse) + 40
                  : 50,
              width: aiSummaryPrefs.hasSummary ? screenSize.width : 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                // color: aiSummaryPrefs.hasSummary
                //     ? context.tertiaryContainer
                //     : context.secondaryContainer,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Material(
                  color: aiSummaryPrefs.hasSummary
                      ? context.tertiaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    onTap: aiSummaryPrefs.hasSummary
                        ? null // Disable the tap gesture when summary is available
                        : () async {
                            final response =
                                await geminiService.summarizeBookWithGeminiAI(
                              bookName: this.widget.bookdata.bookTitle,
                              authorName: this.widget.bookdata.bookAuthor,
                              bookKey: _bookKey,
                            );

                            await aiSummaryPrefs.storeSummary(
                                _bookKey, response);
                          },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          child: aiSummaryPrefs.hasSummary
                              ? SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        aiSummaryPrefs.geminiResponse,
                                        style: TextStyle(
                                          color: aiSummaryPrefs.hasSummary
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
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    geminiService.isGeneratingSummary
                                        ? SizedBox(
                                            height: 34,
                                            width: 34,
                                            child: CircularProgressIndicator(
                                              color:
                                                  context.onSecondaryContainer,
                                            ),
                                          )
                                        : Icon(
                                            MdiIcons.autoFix,
                                            color: aiSummaryPrefs.hasSummary
                                                ? context.onTertiaryContainer
                                                : context.onSecondaryContainer,
                                          ),
                                    Text(
                                      geminiService.isGeneratingSummary
                                          ? 'Generating now'
                                          : 'Generate book summary',
                                      style: TextStyle(
                                        color: aiSummaryPrefs.hasSummary
                                            ? context.onTertiaryContainer
                                            : context.onSecondaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
