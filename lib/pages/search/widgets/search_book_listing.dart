import 'package:flutter/material.dart';

Widget searchBookListingResult() {
  return Padding(
    padding:
        const EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding on all sides
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // Set the maximum width for each cell
        mainAxisExtent: 250,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.normal,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Image.network(
                    "https://comicvine.gamespot.com/a/uploads/scale_small/6/67663/7696708-23.jpg",
                    fit: BoxFit.cover,
                    width: 200,
                    height: 250,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  //! This Added height to gradient overlap the gap
                  height: 250,
                  width: 200,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Title $index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Author $index',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Author $index',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
