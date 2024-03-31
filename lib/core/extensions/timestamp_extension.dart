import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimestampFormatter on Timestamp {
  String toDateOnly() {
    DateTime dateTime = this.toDate();
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  String toTimeOnly() {
    DateTime dateTime = this.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  String toDateTime() {
    DateTime dateTime = this.toDate();
    return DateFormat('EEEE, MMM d, yyyy - hh:mm a').format(dateTime);
  }

  /// Converts [Timestamp] into proper DateTime format.
  String toDayAndDate() {
    DateTime dateTime = this.toDate();
    String formattedDateTime = DateFormat('EEEE, MMM d, yyyy').format(dateTime);
    return formattedDateTime;
  }

  String toDayAndTime() {
    DateTime dateTime = this.toDate();
    String formattedDateTime = DateFormat('EEEE, hh:mm a').format(dateTime);
    return formattedDateTime;
  }
}
