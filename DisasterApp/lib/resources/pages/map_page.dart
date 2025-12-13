import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/controllers/map_controller.dart' as CustomController;
import '../widgets/disaster_list_view_widget.dart';
import '../widgets/map_view_widget.dart';

class MapPage extends NyStatefulWidget {
  static RouteView path = ("/map", (_) => MapPage());
  MapPage({super.key}) : super(child: () => _MapPageState());
}

class _MapPageState extends NyPage<MapPage> with TickerProviderStateMixin {
  late CustomController.MapController controller;  // ✅ Custom Controller
  TabController? _tabController;
  LatLng? myLocation;
  LatLng? _goToLocation;

  @override
  get init => () async {
    controller = CustomController.MapController();
    _tabController = TabController(length: 2, vsync: this);
    await controller.construct(context);
    await _getLocation();
    await controller.initialize();
    setState(() {});
  };

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('⚠️ Location permissions denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('⚠️ Location permissions permanently denied');
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();
      myLocation = LatLng(pos.latitude, pos.longitude);
      print('📍 Location: ${pos.latitude}, ${pos.longitude}');
    } catch (e) {
      print('❌ Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _switchToMapWithLocation(LatLng location) {
    setState(() {
      _goToLocation = location;
    });
    // Chuyển sang tab Map (index 0)
    _tabController!.animateTo(0);
  }
  void _onLocationReached() {
    setState(() {
      _goToLocation = null;
    });
  }


  @override
  Widget view(BuildContext context) {
    if (_tabController == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Theo dõi thảm họa"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.map), text: "Bản đồ"),
            Tab(icon: Icon(Icons.list), text: "Danh sách"),
          ],
        ),
      ),
      body: controller.isLoading
          ?  _buildLoadingView()
          : TabBarView(
        controller: _tabController!,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // ✅ Fix: Sử dụng class constructor đúng cách
          MapView(
            controller: controller,
            myLocation: myLocation,
            onRefresh: () => setState(() {}),
            goToLocation: _goToLocation,
            onLocationReached: _onLocationReached,
          ),
          DisasterListView(
            controller: controller,
            onRefresh: () => setState(() {}),
            onGoToLocation: (location) {
              // Set location khi người dùng chọn "Xem trên bản đồ"
              setState(() {
                _goToLocation = location;
              });
            },
            onSwitchToMapView: () {
              // Chuyển sang tab map
              _tabController!.animateTo(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải dữ liệu...'),
        ],
      ),
    );
  }
}