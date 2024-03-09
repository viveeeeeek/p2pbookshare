import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String street, city, state;
  final void Function() onTap;

  const AddressCard({
    super.key,
    required this.street,
    required this.city,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.0), // Set the borderRadius here
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0), // Match the shape of the Card
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Street: $street'),
                Text('City: $city'),
                Text('State: $state'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
