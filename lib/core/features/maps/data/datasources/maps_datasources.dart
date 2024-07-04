import 'package:flutter/material.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

abstract interface class MapsDataSource {
  Image fetchMapsStaticImage(LatitudeLongitude latitudeLongitude);
}

class MapsDataSourceImpl implements MapsDataSource {
  @override
  Image fetchMapsStaticImage(LatitudeLongitude latitudeLongitude) {
    final lat = latitudeLongitude.latitude;
    final long = latitudeLongitude.longitude;
    try {
      var imageSource =
          'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x400&&markers=color:red%7Clabel:S%7C$lat,$long&key=Your Google Maps API';
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            // Image is fully loaded
            return child;
          } else {
            // Show a loading indicator (you can customize this widget)
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
          }
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
