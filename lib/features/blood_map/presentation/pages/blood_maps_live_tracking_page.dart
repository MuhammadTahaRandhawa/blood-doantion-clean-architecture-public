import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';

class BloodMapLiveTrackingPage extends StatefulWidget {
  const BloodMapLiveTrackingPage(
      {super.key, required this.source, required this.destination});
  final MapMarker source;
  final MapMarker destination;
  @override
  State<BloodMapLiveTrackingPage> createState() =>
      BloodMapLiveTrackingPageState();
}

class BloodMapLiveTrackingPageState extends State<BloodMapLiveTrackingPage> {
  late final LatLng sourceLocation;
  late final LatLng destinationLocation;
  bool isZoomedIn = false;
  @override
  void initState() {
    sourceLocation = LatLng(
        widget.source.location.latitude, widget.source.location.longitude);
    destinationLocation = LatLng(widget.destination.location.latitude,
        widget.destination.location.longitude);
    getPolyPoints();
    getCurrentLocation();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'Your Google Maps API', // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  Position? currentLocation;
  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition()
        .then((value) => currentLocation = value);

    GoogleMapController googleMapController = await _controller.future;
    Geolocator.getPositionStream().listen(
      (newLoc) {
        // context.read<UserCubit>().updateUserLocation(Location(
        //     latitude: newLoc.latitude,
        //     longitude: newLoc.longitude,
        //     address: ''));
        currentLocation = newLoc;
        if (!isZoomedIn) {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 16,
                target: LatLng(
                  newLoc.latitude,
                  newLoc.longitude,
                ),
              ),
            ),
          );
        }
        calculateDistance(
            LatLng(newLoc.latitude, newLoc.longitude), destinationLocation);
        setState(() {});
      },
    );
  }

  void _onCameraMove(CameraPosition position) {
    if (position.zoom != 16) {
      // Assuming 16 is the default zoom level
      isZoomedIn = true;
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  // Function to get a formatted string for the distance
  String getDistanceString(double distance) {
    if (distance < 1000) {
      return "${distance.toStringAsFixed(0)} m";
    } else {
      return "${(distance / 1000).toStringAsFixed(1)} km";
    }
  }

  // Function to create a user profile display
  Widget userProfile(String? imageUrl, String name, String address) {
    return Row(
      children: [
        if (imageUrl != null)
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          )
        else
          CircleAvatar(
            child: Text(name.substring(0, 1)),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude,
                          currentLocation!.longitude),
                    ),
                    Marker(
                        markerId: const MarkerId("source"),
                        position: sourceLocation,
                        icon: widget.source.icon),
                    Marker(
                        markerId: const MarkerId("destination"),
                        position: destinationLocation,
                        icon: widget.destination.icon),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: const Color(0xFF7B61FF),
                      width: 6,
                    ),
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  onCameraMove: _onCameraMove,
                ),
          if (currentLocation != null)
            Positioned(
              bottom: 30, // Adjust the position as needed
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    userProfile(
                        null,
                        widget.source.userName,
                        widget.source.location
                            .address), // Replace with actual variables
                    Text(
                      "Distance to destination: ${getDistanceString(calculateDistance(LatLng(currentLocation!.latitude, currentLocation!.longitude), destinationLocation))}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
