import 'package:p2pbookshare/services/model/book_request.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';

class ViewBookHandler {
  // Future<void> extractColors() async {
  //   final imageProvider = NetworkImage('YOUR_IMAGE_URL');
  //   final dynamicColors = DynamicColor.fromImage(imageProvider);
  //   // Get the dominant color
  //   final dominantColor = await dynamicColors.dominantColor;
  //   // Get a palette of colors
  //   final palette = await dynamicColors.paletteColors;
  // }

  late final BookRequestService _bookRequestServices;
  ViewBookHandler(this._bookRequestServices);

  handleBorrowRequest(BookRequestModel bookRequestData) {
    _bookRequestServices.sendBookBorrowRequest(bookRequestData);
  }
}
