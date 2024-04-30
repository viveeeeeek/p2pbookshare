// Flutter imports:
import 'package:flutter/material.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer, // Set the icon color
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          child: Icon(
            Icons.favorite_outline,
            size: 24, // Adjust the icon size as needed
            color: Theme.of(context).colorScheme.primary, // Set the icon color
          )),
    );
  }
}

// class FavouriteButton extends StatelessWidget {
//   const FavouriteButton({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 45,
//       width: 45,
//       child: IconButton.filledTonal(
//         onPressed: () {
//           // Add functionality here
//         },
//         // style: OutlinedButton.styleFrom(
//         //   padding: EdgeInsets.zero, // Remove default padding
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(
//         //         25.0), // Adjust the value for rounded corners
//         //   ),
//         //   side: BorderSide(
//         //     color:
//         //         Theme.of(context).colorScheme.primary, // Set the border color
//         //   ),
//         // ),
//         icon: Icon(
//           Icons.favorite_outline,
//           size: 24, // Adjust the icon size as needed
//           color: Theme.of(context).colorScheme.primary, // Set the icon color
//         ),
//       ),
//     );
//   }
// }
