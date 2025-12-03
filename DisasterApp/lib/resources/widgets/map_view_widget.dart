import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_map/flutter_map.dart' as FlutterMapController;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import 'disaster_dialog.dart';

class MapView extends StatefulWidget {
  final CustomController.MapController controller;
  final LatLng? myLocation;
  final VoidCallback onRefresh;

  const MapView({
    Key? key,
    required this.controller,
    required this.myLocation,
    required this.onRefresh,
  }) : super(key: key);

  @override
  createState() => _MapViewState();
}

class _MapViewState extends NyState<MapView> {
  late FlutterMapController.MapController _mapController;

  @override
  get init => () async {
    _mapController = FlutterMapController.MapController();
  };

  Future<void> _goToMyLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      final location = LatLng(pos.latitude, pos.longitude);
      _mapController.move(location, 15);
      setState(() {});
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  @override
  Widget view(BuildContext context) {
    return Stack(
      children: [
        FlutterMapController.FlutterMap(
          mapController: _mapController,
            options: FlutterMapController.MapOptions(
              initialCenter: widget.myLocation ?? LatLng(21.0285, 105.8542),
              initialZoom:  13,
              onTap: (tapPosition, point) {
                widget.controller.selectedPoint = point;
                _showDialog(context, isCreate: true);
              }
            ),
            children: [
              FlutterMapController.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              FlutterMapController.MarkerLayer(
                markers: [
                  if (widget.myLocation != null)
                    FlutterMapController.Marker(
                      width: 50,
                      height: 50,
                      point: widget.myLocation!,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      )
                    ),
                  ...widget.controller.disasters.map((disaster) {
                    return FlutterMapController.Marker(
                      point: LatLng(disaster.lat, disaster.lon),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () => _showDialog(
                          context,
                          isCreate: false,
                          disaster: disaster,
                        ),
                        child: Column(
                          mainAxisSize:MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: Colors.red,size: 40,),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                disaster.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      )
                    );
                  }).toList(),
                ],
              )
            ]
        ),
        Positioned(
          bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
                child: Icon(Icons.my_location, color: Colors.blue),
                onPressed: _goToMyLocation,
            ),
        ),

        if (widget.controller.hasSelectedPoint)
          Positioned(
            top: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                    padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                            'Đã chọn: ${widget.controller.selectedPoint?.latitude.toStringAsFixed(5)}, '
                                '${widget.controller.selectedPoint?.latitude.toStringAsFixed(5)}',
                            style: TextStyle(fontSize: 12),
                          ),
                      ),
                      IconButton(
                          onPressed: (){
                            widget.controller.clearSelection();
                            setState(() {});
                          },
                          icon: Icon(Icons.close, size: 20,)
                      ),
                    ],
                  ),
                ),
              ),
          ),

      ],
    );
  }
  void _showDialog(
      BuildContext context, {
        required bool isCreate,
        disaster,
  }) {
    DisasterDialogWidget.show(
      context: context,
      controller: widget.controller,
      isCreate: isCreate,
      disaster: disaster,
      onSuccess: () {
        widget.onRefresh();
        setState(() {});
      },
    );
  }
}
