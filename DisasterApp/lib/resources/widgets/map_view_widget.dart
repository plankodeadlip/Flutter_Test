import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_map/flutter_map.dart' as FlutterMapController;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../helpers/svg_helper.dart';
import 'disaster_detail_widget.dart';
import 'disaster_dialog.dart';

class MapView extends StatefulWidget {
  final CustomController.MapController controller;
  final LatLng? myLocation;
  final VoidCallback onRefresh;
  final LatLng? goToLocation;
  final VoidCallback? onLocationReached;

  const MapView({
    Key? key,
    required this.controller,
    required this.myLocation,
    required this.onRefresh,
    this.goToLocation,
    this.onLocationReached,
  }) : super(key: key);

  @override
  createState() => _MapViewState();
}

class _MapViewState extends NyState<MapView> {
  late FlutterMapController.MapController _mapController;
  late CustomController.MapController controller;
  LatLng? _highlightedLocation;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    controller = CustomController.MapController();
    _mapController = FlutterMapController.MapController();
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Khi MapPage gửi vị trí mới xuống
    if (widget.goToLocation != null &&
        widget.goToLocation != oldWidget.goToLocation) {
      print("📍 Nhận vị trí mới: ${widget.goToLocation}");

      // Zoom đến vị trí
      _goTo(widget.goToLocation!);

      // Báo MapPage rằng đã xong
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.onLocationReached != null) {
          widget.onLocationReached!(); // KHÔNG bị lỗi build nữa
        }
      });
    }
  }

  void _goTo(LatLng target) {
    _mapController.move(target, 15.0);
  }

  Future<void> _goToMyLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      final location = LatLng(pos.latitude, pos.longitude);
      _mapController.move(location, 15);
      setState(() {});
    } catch (e) {
      print('❌ Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể lấy vị trí hiện tại'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToLocation(LatLng location, {double zoom = 16}) {
    if (!_isMapReady) {
      print("⏳ Map chưa sẵn sàng, đợi…");
      Future.delayed(Duration(milliseconds: 200), () {
        _goToLocation(location, zoom: zoom);
      });
      return;
    }

    print("📍 Nhảy đến: ${location.latitude}, ${location.longitude}");
    _mapController.move(location, zoom);

    setState(() => _highlightedLocation = location);

    widget.onLocationReached?.call();

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => _highlightedLocation = null);
    });
  }

  @override
  Widget view(BuildContext context) {
    return Stack(
      children: [
        FlutterMapController.FlutterMap(
            mapController: _mapController,
            options: FlutterMapController.MapOptions(
              initialCenter: widget.myLocation ?? LatLng(21.0285, 105.8542),
              initialZoom: 13,
              onLongPress: (tapPosition, point) {
                widget.controller.selectLocation(point);
                _showCreateDialog(context, point);
              },
              onMapReady: () {
                if (!_isMapReady) {
                  setState(() => _isMapReady = true);

                  if (widget.goToLocation != null) {
                    Future.delayed(Duration(milliseconds: 200), () {
                      _goToLocation(widget.goToLocation!, zoom: 16.5);
                    });
                  }
                }
              },
            ),
            children: [
              FlutterMapController.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.nylon.android',
              ),
              if (_highlightedLocation != null)
                FlutterMapController.CircleLayer(
                  circles: [
                    FlutterMapController.CircleMarker(
                      point: _highlightedLocation!,
                      radius: 100,
                      useRadiusInMeter: true,
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 3,
                    ),
                  ],
                ),
              FlutterMapController.MarkerLayer(
                markers: [
                  if (widget.myLocation != null)
                    FlutterMapController.Marker(
                        width: 50,
                        height: 50,
                        point: widget.myLocation!,
                        child: Icon(
                          CupertinoIcons.location_solid,
                          color: Colors.blue,
                          size: 40,
                        )),
                  ...widget.controller.disasters.map((disaster) {
                    final disasterType =
                        widget.controller.getDisasterType(disaster.typeId);
                    final disasterLocation = LatLng(disaster.lat, disaster.lon);
                    final isHighlighted = _highlightedLocation != null &&
                        _highlightedLocation!.latitude == disaster.lat &&
                        _highlightedLocation!.longitude == disaster.lon;
                    return FlutterMapController.Marker(
                        point: disasterLocation,
                        width: isHighlighted ? 120 : 100,
                        height: isHighlighted ? 120 : 100,
                        child: GestureDetector(
                          onTap: () => _showDetailDialog(context, disaster),
                          onLongPress: () =>
                              _showActionBottomSheet(context, disaster),
                          child: AnimatedScale(
                            scale: isHighlighted ? 1.2 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: isHighlighted ? 56 : 48,
                                  height: isHighlighted ? 56 : 48,
                                  decoration: BoxDecoration(
                                    color: isHighlighted
                                        ? Colors.blue.shade100
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: isHighlighted
                                        ? Border.all(
                                            color: Colors.blue, width: 3)
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isHighlighted
                                            ? Colors.blue.withValues(alpha: 0.5)
                                            : Colors.black26,
                                        blurRadius: isHighlighted ? 8 : 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: () {
                                    try {
                                      if (disasterType != null &&
                                          disasterType.image.isNotEmpty) {
                                        return Padding(
                                          padding: EdgeInsets.all(8),
                                          child: SvgHelper.buildSvgFromBase64(
                                            base64String: disasterType.image,
                                            width: isHighlighted ? 36 : 32,
                                            height: isHighlighted ? 36 : 32,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print("⚠️ SVG render error: $e");
                                    }

                                    // fallback nếu SVG lỗi
                                    return Icon(
                                      Icons.warning,
                                      size: isHighlighted ? 36 : 32,
                                      color: Colors.orange,
                                    );
                                  }(),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isHighlighted ? 10 : 8,
                                    vertical: isHighlighted ? 5 : 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isHighlighted
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    disaster.name,
                                    style: TextStyle(
                                      fontSize: isHighlighted ? 12 : 11,
                                      fontWeight: isHighlighted
                                          ? FontWeight.bold
                                          : FontWeight.bold,
                                      color: isHighlighted
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }).toList(),
                ],
              )
            ]),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'myLocation',
                backgroundColor: Colors.white,
                child: Icon(Icons.my_location, color: Colors.blue),
                onPressed: _goToMyLocation,
              ),
              SizedBox(height: 12),
              // Zoom controls (optional)
              FloatingActionButton.small(
                heroTag: 'zoomIn',
                backgroundColor: Colors.white,
                child: Icon(Icons.add, color: Colors.grey.shade700),
                onPressed: () {
                  final zoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, zoom + 1);
                },
              ),
              SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoomOut',
                backgroundColor: Colors.white,
                child: Icon(Icons.remove, color: Colors.grey.shade700),
                onPressed: () {
                  final zoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, zoom - 1);
                },
              ),
            ],
          ),
        ),
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
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nhấn giữ trên bản đồ để thêm thảm họa mới',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.controller.hasSelectedPoint)
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Đã chọn: ${widget.controller.selectedPoint?.latitude.toStringAsFixed(5)}, '
                        '${widget.controller.selectedPoint?.longitude.toStringAsFixed(5)}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.controller.clearSelection();
                        setState(() {});
                      },
                      icon: Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, LatLng point) {
    DisasterDialogWidget.show(
      context: context,
      controller: widget.controller,
      isCreate: true,
      disaster: null,
      onSuccess: () {
        widget.onRefresh();
        setState(() {});
      },
    );
  }

  void _showDetailDialog(BuildContext context, disaster) {
    DisasterDetailWidget.show(
      context: context,
      controller: widget.controller,
      disaster: disaster,
    );
  }

  void _showActionBottomSheet(BuildContext context, disaster) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disaster.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          disaster.typeName ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.blue),
              title: Text('Xem chi tiết'),
              onTap: () {
                Navigator.pop(ctx);
                _showDetailDialog(context, disaster);
              },
            ),
            ListTile(
              leading: Icon(Icons.center_focus_strong, color: Colors.purple),
              title: Text('Căn giữa vị trí'),
              onTap: () {
                Navigator.pop(ctx);
                _goToLocation(LatLng(disaster.lat, disaster.lon));
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.orange),
              title: Text('Chỉnh sửa'),
              onTap: () async {
                final full = await controller.loadDisasterDetails(disaster.id!);

                if (full == null) return;
                Navigator.pop(ctx);
                DisasterDialogWidget.show(
                  context: context,
                  controller: controller,
                  isCreate: false,
                  disaster: full,
                  onSuccess: () {
                    widget.onRefresh();
                    setState(() {});
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: Text("Xóa thảm họa"),
                    content: Text(
                        "Bạn có chắc chắn muốn xóa \"${disaster.name}\"?\nTất cả ảnh sẽ bị xóa vĩnh viễn."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, false),
                        child: Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, true),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Text("Xóa"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final success =
                      await widget.controller.deleteDisaster(disaster.id!);
                  if (success) {
                    widget.onRefresh();
                    setState(() {});
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã xóa thảm họa")),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
