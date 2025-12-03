import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../helpers/svg_helper.dart';

class DisasterDialogWidget {
  static void show({
    required BuildContext context,
    required CustomController.MapController controller,
    required bool isCreate,
    Disaster? disaster,
    required VoidCallback onSuccess,
  }) {
    final nameController = TextEditingController(
      text: isCreate ? '' : disaster!.name,
    );
    final descController = TextEditingController(
      text: isCreate ? '' : disaster!.description,
    );
    int? selectedType = isCreate ? null : disaster!.typeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          StatefulBuilder(
            builder: (context, setModalState) {
              final selectedDisasterType = selectedType != null
                  ? controller.getDisasterType(selectedType!)
                  : null;

              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                ),
                child: Column(
                  children: [
                    _buildHeader(
                      context: ctx,
                      isCreate: isCreate,
                      controller: controller,
                    ),
                    Expanded(
                      child: _buildForm(
                        context: context,
                        controller: controller,
                        isCreate: isCreate,
                        disaster: disaster,
                        nameController: nameController,
                        descController: descController,
                        selectedType: selectedType,
                        selectedDisasterType: selectedDisasterType,
                        onTypeChanged: (val) {
                          setModalState(() => selectedType = val);
                        },
                      ),
                    ),
                    _buildActions(
                      context: ctx,
                      controller: controller,
                      isCreate: isCreate,
                      disaster: disaster,
                      nameController: nameController,
                      descController: descController,
                      selectedType: selectedType,
                      onSuccess: onSuccess,
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  static Widget _buildHeader({
    required BuildContext context,
    required bool isCreate,
    required CustomController.MapController controller,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isCreate ? "Thêm Thảm Họa Mới" : "Cập Nhật Thảm Họa",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              controller.clearSelection();
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildForm({
    required BuildContext context,
    required CustomController.MapController controller,
    required bool isCreate,
    required Disaster? disaster,
    required TextEditingController nameController,
    required TextEditingController descController,
    required int? selectedType,
    required selectedDisasterType,
    required Function(int?) onTypeChanged,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          Text(
              'Loại thảm họa *', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: selectedType,
            hint: Text("Chọn loại thảm họa"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: controller.disasterTypes.map((type) {
              return DropdownMenuItem<int>(
                value: type.id,
                child: Row(
                  children: [
                    SvgHelper.buildSvgFromBase64(
                      base64String: type.image,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 12),
                    Text(type.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: onTypeChanged,
          ),

          // Preview
          if (selectedDisasterType != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SvgHelper.buildSvgFromBase64(
                    base64String: selectedDisasterType.image,
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Đã chọn: ${selectedDisasterType.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16),

          // Name
          Text('Tên sự kiện *', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "VD: Lũ lụt miền Trung 2024",
            ),
          ),
          SizedBox(height: 16),

          // Description
          Text('Mô tả', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Mô tả chi tiết về sự kiện...",
            ),
          ),
          SizedBox(height: 16),

          // Location
          Text('Vị trí', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isCreate
                        ? "Lat: ${controller.selectedPoint?.latitude
                        .toStringAsFixed(6)}\n"
                        "Lon: ${controller.selectedPoint?.longitude
                        .toStringAsFixed(6)}"
                        : "Lat: ${disaster!.lat.toStringAsFixed(6)}\n"
                        "Lon: ${disaster.lon.toStringAsFixed(6)}",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildActions({
    required BuildContext context,
    required CustomController.MapController controller,
    required bool isCreate,
    required Disaster? disaster,
    required TextEditingController nameController,
    required TextEditingController descController,
    required int? selectedType,
    required VoidCallback onSuccess,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Delete button
          if (!isCreate) ...[
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text('Xóa', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(
                          title: Text('Xác nhận xóa'),
                          content: Text('Bạn có chắc muốn xóa thảm họa này?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                  'Xóa', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    bool ok = await controller.deleteDisaster(disaster!.id!);
                    if (ok) {
                      Navigator.pop(context);
                      onSuccess();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Đã xóa thành công"),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            SizedBox(width: 12),
          ],

          // Save button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                if (selectedType == null || nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Vui lòng nhập đủ thông tin"),
                    ),
                  );
                  return;
                }

                bool success;
                if (isCreate) {
                  success = await controller.createDisaster(
                    name: nameController.text,
                    description: descController.text,
                    typeId: selectedType!,
                  );
                } else {
                  success = await controller.updateDisaster(
                    id: disaster!.id!,
                    name: nameController.text,
                    description: descController.text,
                    typeId: selectedType!,
                  );
                }

                if (success) {
                  Navigator.pop(context);
                  onSuccess();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isCreate
                          ? "Thêm mới thành công"
                          : "Cập nhật thành công",),
                    ),
                  );
                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Có lỗi xảy ra"),
                    ),
                  );

                }
              },
              child: Text(
                isCreate ? "Thêm Mới" : "Lưu Thay Đổi",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}