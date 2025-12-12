import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'dart:async';
import '../../app/controllers/map_controller.dart' as CustomController;
import '../../../helpers/svg_helper.dart';
import '../../app/models/disaster.dart';
import '../../app/models/disaster_type.dart';
import '../../helpers/db_helper.dart';
import 'disaster_detail_widget.dart';
import 'disaster_dialog.dart';

class DisasterListView extends NyStatefulWidget {
  final CustomController.MapController controller;
  final VoidCallback onRefresh;
  final Function(LatLng)? onGoToLocation;
  // Thêm callback để chuyển tab
  final VoidCallback? onSwitchToMapView;


  DisasterListView({
    Key? key,
    required this.controller,
    required this.onRefresh,
    this.onGoToLocation,
    this.onSwitchToMapView,
  }) : super(key: key, child: () => _DisasterListViewState());
}

class _DisasterListViewState extends NyState<DisasterListView> {
  late CustomController.MapController controller;
  final dbHelper = DBHelper();

  int? _selectedTypeId;
  String _searchQuery = '';
  String _orderBy = 'updated_at';
  bool _ascending = false;

  List<Disaster> _disasters = [];
  List<DisasterType> _disasterTypes = [];
  bool _isLoading = false;

  TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  get init => () async {
        super.init();
        controller = CustomController.MapController();
        await _loadData();
      };

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load disaster types từ database
      final typesData = await dbHelper.getDisasterTypes();
      _disasterTypes = typesData.map((e) => DisasterType.fromMap(e)).toList();

      // Load disasters với filter
      await _loadDisasters();
    } catch (e) {
      print('❌ Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDisasters() async {
    try {

      List<Map<String, dynamic>> disastersData;

      if (_searchQuery.isNotEmpty) {
        disastersData = await dbHelper.searchDisastersFTS(
          searchQuery: _searchQuery,
          typeId: _selectedTypeId,
          orderBy: _orderBy,
          ascending: _ascending,
        );
      } else {
        disastersData = await dbHelper.getDisastersFilterd(
          typeId: _selectedTypeId,
          searchName: null,
          orderBy: _orderBy,
          ascending: _ascending,
        );
      }

      setState(() {
        _disasters = disastersData.map((data) => Disaster.fromMap(data)).toList();
      });

      controller.disasters = _disasters;
    } catch (e) {
      print('❌ Error loading disasters: $e');
      rethrow;
    }
  }

  void _filterByType(int? typeId) {
    print('🔄 [LIST] Filter by type: $typeId');
    setState(() {
      _selectedTypeId = typeId;
    });
    _loadDisasters();
  }
  /// Search với debounce và database query
  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = value;
      });
      _loadDisasters();
    });
  }

  void _changeSort(String orderBy) {
    setState(() {
      if (_orderBy == orderBy) {
        _ascending = !_ascending;
      } else {
        _orderBy = orderBy;
        _ascending = false;
      }
    });
    _loadDisasters();
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(() {
      _selectedTypeId = null;
      _searchQuery = '';
    });
    _loadDisasters();
  }

  Future<void> _deleteDisaster(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa thảm họa"),
        content: Text("Bạn có chắc chắn muốn xóa thảm họa này?\nTất cả ảnh sẽ bị xóa vĩnh viễn."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await dbHelper.deleteDisaster(id);
        showToastNotification(
          context,
          title: "Thành công",
          description: "Đã xóa thảm họa",
          style: ToastNotificationStyleType.success,
        );
        await _loadDisasters();
        widget.onRefresh();
      } catch (e) {
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Không thể xóa thảm họa",
          style: ToastNotificationStyleType.danger,
        );
      }
    }
  }

  @override
  Widget view(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildFilterChips(),
        if (_hasActiveFilters()) _buildActiveFiltersBar(),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _disasters.isEmpty
                  ? _buildEmptyState()
                  : _buildDisasterList(),
        ),
      ],
    );
  }

  /// Check if có filter đang active
  bool _hasActiveFilters() {
    return _selectedTypeId != null || _searchQuery.isNotEmpty;
  }

  /// Active filters bar
  Widget _buildActiveFiltersBar() {
    List<String> activeFilters = [];

    if (_selectedTypeId != null) {
      final typeName = _disasterTypes
          .firstWhere(
            (t) => t.id == _selectedTypeId,
        orElse: () => DisasterType(id: 0, name: 'Unknown', image: ''),
      )
          .name;
      activeFilters.add('Loại: $typeName');
    }

    if (_searchQuery.isNotEmpty) {
      activeFilters.add('Tìm kiếm: "$_searchQuery"');
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 16, color: Colors.blue.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              activeFilters.join(' • '),
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _clearAllFilters,
            icon: Icon(Icons.clear, size: 16),
            label: Text('Xóa bộ lọc'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo tên hoặc mô tả...",
                prefixIcon: Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _loadDisasters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.grey.shade100,
                isDense: true,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.blue.shade700),
            onSelected: _changeSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'updated_at',
                child: Row(
                  children: [
                    Icon(
                      _orderBy == 'updated_at'
                          ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.update,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text("Cập nhật"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'created_at',
                child: Row(
                  children: [
                    Icon(
                      _orderBy == 'created_at'
                          ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.access_time,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text("Tạo mới"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(
                      _orderBy == 'name'
                          ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.sort_by_alpha,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text("Tên A-Z"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // All filter
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text("Tất cả"),
              selected: _selectedTypeId == null,
              onSelected: (_) => _filterByType(null),
              selectedColor: Colors.blue.shade700,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedTypeId == null ? Colors.white : Colors.black,
                fontSize: 13,
              ),
            ),
          ),

          // Type filters
          ..._disasterTypes.map((type) {
            final isSelected = _selectedTypeId == type.id;
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.name),
                selected: _selectedTypeId == type.id,
                onSelected: (_) => _filterByType(type.id),
                selectedColor: Colors.blue.shade700,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color:
                      _selectedTypeId == type.id ? Colors.white : Colors.black,
                  fontSize: 13,
                ),
                // Show icon nếu có
                avatar: type.image.isNotEmpty
                    ? SvgHelper.buildSvgFromBase64(
                        base64String: type.image,
                        width: 18,
                        height: 18,
                      )
                    : null,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;

    if (_selectedTypeId != null && _searchQuery.isNotEmpty) {
      final typeName = _disasterTypes
          .firstWhere(
            (t) => t.id == _selectedTypeId,
            orElse: () => DisasterType(id: 0, name: 'Unknown', image: ''),
          )
          .name;
      title = "Không tìm thấy kết quả";
      subtitle = 'Không có loại "$typeName" với từ khóa "$_searchQuery"';
      icon = Icons.search_off;
    } else if (_searchQuery.isNotEmpty) {
      title = "Không tìm thấy kết quả";
      subtitle = 'Không có thảm họa nào với từ khóa "$_searchQuery"';
      icon = Icons.search_off;
    } else if (_selectedTypeId != null) {
      final typeName = _disasterTypes
          .firstWhere(
            (t) => t.id == _selectedTypeId,
            orElse: () => DisasterType(id: 0, name: 'Unknown', image: ''),
          )
          .name;
      title = "Không có thảm họa loại \"$typeName\"";
      subtitle = "Chưa có thảm họa nào thuộc loại này";
      icon = Icons.filter_alt_off;
    } else {
      title = "Chưa có dữ liệu";
      subtitle = "Chưa có thảm họa nào được ghi nhận";
      icon = Icons.warning_amber_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          if (_hasActiveFilters()) ...[
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _clearAllFilters,
              icon: Icon(Icons.clear_all),
              label: Text("Xóa tất cả bộ lọc"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white
              ),
            )
          ]
        ],
      ),
    );
  }

  /// Disaster list
  Widget _buildDisasterList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                "Tìm thấy ${_disasters.length} thảm họa",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500
                ),
              ),
              Spacer(),
              if (_orderBy == 'updated_at')
                Text(_ascending ? 'Cũ nhất' : 'Mới nhất',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600,),
                )
              else if (_orderBy == 'created_at')
                Text(_ascending ? 'Tạo cũ -> mới' : 'Tạo mới -> cũ',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600,),
                )
              else if (_orderBy == 'name')
                Text(
                  _ascending ? 'A->Z' : 'Z->A',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                )
            ],
          ),
        ),
        Expanded(
            child: RefreshIndicator(
                child: ListView.builder(
                    itemCount: _disasters.length,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final disaster = _disasters[index];
                      return _buildDisasterCard(disaster);
                    }),
                onRefresh: () async {
                  await _loadDisasters();
                  widget.onRefresh();
                }))
      ],
    );
  }

  Widget _buildDisasterCard(dynamic disaster) {
    final disasterType = _disasterTypes.firstWhere(
      (type) => type.id == disaster.typeId,
      orElse: () => DisasterType(id: 0, name: 'Unknown', image: ''),
    );
    final isSearchMatch = _searchQuery.isNotEmpty &&
        (disaster.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            disaster.description.toLowerCase().contains(_searchQuery.toLowerCase()));

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSearchMatch
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          DisasterDetailWidget.show(
            context: context,
            controller: controller,
            disaster: disaster,
          );
        },
        onLongPress: () {
          _showActionBottomSheet(disaster);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (disasterType.image.isNotEmpty)
                    SvgHelper.buildCircleAvatar(
                      base64String: disasterType.image,
                      radius: 20,
                      backgroundColor: Colors.orange.shade100,
                    )
                  else
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red.shade100,
                      child: Icon(Icons.warning, color: Colors.red, size: 20),
                    ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (disasterType.image.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: SvgHelper.buildSvgFromBase64(
                              base64String: disasterType.image,
                              width: 14,
                              height: 14,
                            ),
                          ),
                        Text(
                          disaster.typeName ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
              SizedBox(height: 12),
              Text(
                disaster.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (disaster.description.isNotEmpty) ...[
                SizedBox(height: 6),
                Text(
                  disaster.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700,),
                ),
              ],
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                  SizedBox(width: 4),
                  Text(
                    "${disaster.lat.toStringAsFixed(4)}, ${disaster.lon.toStringAsFixed(4)}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade600),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(disaster.updatedAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionBottomSheet(Disaster disaster) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.blue),
              title: Text('Xem chi tiết'),
              onTap: () {
                Navigator.pop(context);
                DisasterDetailWidget.show(
                  context: context,
                  controller: controller,
                  disaster: disaster,
                );
              },
            ),
            // Trong DisasterListView
            ListTile(
              leading: Icon(Icons.map, color: Colors.green),
              title: Text('Xem trên bản đồ'),
              onTap: () {
                print('🔍 [LIST] Xem trên bản đồ clicked');
                Navigator.pop(context);

                final location = LatLng(disaster.lat, disaster.lon);
                print('🔍 [LIST] Location: ${location.latitude}, ${location.longitude}');

                if (widget.onSwitchToMapView != null) {
                  widget.onSwitchToMapView!.call();
                  print('✅ [LIST] Switched to MapView');
                } else {
                  print('❌ [LIST] onSwitchToMapView is NULL!');
                }

                // GIẢI QUYẾT 100% vấn đề: đợi map hiển thị rồi mới zoom
                Future.delayed(Duration(milliseconds: 150), () {
                  if (widget.onGoToLocation != null) {
                    widget.onGoToLocation!.call(location);
                    print('✅ [LIST] onGoToLocation called after 150ms');
                  } else {
                    print('❌ [LIST] onGoToLocation is NULL!');
                  }
                });
              },
            ),

            ListTile(
              leading: Icon(Icons.edit, color: Colors.orange),
              title: Text('Chỉnh sửa'),
              onTap: () async {
                final full = await controller.loadDisasterDetails(disaster.id!);
                if (full == null) return;
                print("Before edit: disaster.images = ${disaster.images?.length}");
                Navigator.pop(context);
                DisasterDialogWidget.show(
                  context: context,
                  controller: controller,
                  isCreate: false,
                  disaster: full,
                  onSuccess: () async {
                    await _loadDisasters();
                    widget.onRefresh();
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteDisaster(disaster.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          return "Vừa xong";
        }
        return "${diff.inMinutes} phút trước";
      }
      return "${diff.inHours} giờ trước";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} ngày trước";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
