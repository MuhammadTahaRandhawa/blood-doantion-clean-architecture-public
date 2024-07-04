import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectRequestLocationOnMapPage extends StatefulWidget {
  const SelectRequestLocationOnMapPage({
    super.key,
    required this.location,
    required this.getLatLong,
  });

  final Location location;
  final Function(LatLng) getLatLong;
  @override
  State<SelectRequestLocationOnMapPage> createState() => _MapsViewState();
}

class _MapsViewState extends State<SelectRequestLocationOnMapPage> {
  late LatLng _latLang;
  @override
  void initState() {
    _latLang = LatLng(widget.location.latitude, widget.location.longitude);
    super.initState();
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectReqLoc_selectLoc),
        elevation: 2,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _latLang,
              zoom: 16.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('1'),
                position: _latLang,
              )
            },
            onTap: (latLang) {
              setState(() {
                _latLang = latLang;
              });
            },
          ),
          Positioned(
            bottom: 40,
            right: 100,
            left: 100,
            child: LargeGradientButton(
                width: width - 100,
                onPressed: () {
                  widget.getLatLong(_latLang);
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.selectReqLoc_done,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
