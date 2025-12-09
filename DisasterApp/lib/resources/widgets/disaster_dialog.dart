import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../helpers/svg_helper.dart';
import 'dart:io';
import '../../app/models/disaster_image.dart';

// Class chứa các hàm build UI chi tiết
class _DisasterDialogUIHelper {
  // Màu sắc chính được dùng
  static const Color primaryColor = Color(0xFF1976D2); // Blue 700
  static const Color accentColor = Color(0xFF388E3C); // Green 700

  static Widget _buildHeader({
    required BuildContext context,
    required bool isCreate,
    required CustomController.MapController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isCreate ? "Thêm Thảm Họa Mới" : "Cập Nhật Thảm Họa",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
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
    required dynamic selectedDisasterType, // Dynamic vì kiểu không rõ
    required List<String> newImagePaths,
    required List<DisasterImage> existingImages,
    required Set<int> imageIdsToRemove,
    required Function(int?) onTypeChanged,
    required VoidCallback onSelectImages,
    required VoidCallback onCaptureImage,
    required Function(int) onRemoveNewImage,
    required Function(int) onRemoveExistingImage,
    required Function(int) onRestoreExistingImage,
  }) {
    final visibleExistingImages = existingImages
        .where((img) => !imageIdsToRemove.contains(img.id))
        .toList();
    final totalImages = visibleExistingImages.length + newImagePaths.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Loại thảm họa
          _buildFormLabel('Loại thảm họa *', isRequired: true),
          _buildTypeDropdown(
            controller: controller,
            selectedType: selectedType,
            onTypeChanged: onTypeChanged,
          ),

          // Preview Loại
          if (selectedDisasterType != null) ...[
            const SizedBox(height: 12),
            _buildTypePreview(selectedDisasterType),
          ],

          const SizedBox(height: 16),

          // Tên sự kiện
          _buildFormLabel('Tên sự kiện *', isRequired: true),
          TextFormField(
            controller: nameController,
            decoration: _getInputDecoration(
              hintText: "VD: Lũ lụt miền Trung 2024",
              prefixIcon: Icons.title,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tên sự kiện không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mô tả
          _buildFormLabel('Mô tả'),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: _getInputDecoration(
              hintText: "Mô tả chi tiết về sự kiện...",
              prefixIcon: Icons.description,
            ),
          ),
          const SizedBox(height: 16),

          // Vị trí
          _buildFormLabel('Vị trí', color: primaryColor),
          _buildLocationInfo(isCreate, disaster, controller),

          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 12),

          // ============================================
          // PHẦN QUẢN LÝ ẢNH
          // ============================================

          _buildImageSectionHeader(totalImages),
          const SizedBox(height: 12),
          _buildImageSelectionButtons(onSelectImages, onCaptureImage),
          const SizedBox(height: 16),

          // Grid hiển thị ảnh
          _buildImageGrids(
            visibleExistingImages,
            newImagePaths,
            imageIdsToRemove,
            onRemoveExistingImage,
            onRemoveNewImage,
            onRestoreExistingImage,
            existingImages,
          ),
          const SizedBox(height: 16),

          // Placeholder khi không có ảnh
          if (totalImages == 0 && imageIdsToRemove.isEmpty)
            _buildImagePlaceholder(),
        ],
      ),
    );
  }

  static Widget _buildFormLabel(String label, {bool isRequired = false, Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
          children: isRequired
              ? [
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ]
              : null,
        ),
      ),
    );
  }

  static InputDecoration _getInputDecoration({required String hintText, IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey.shade600) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      fillColor: Colors.grey.shade50,
      filled: true,
    );
  }

  static Widget _buildTypeDropdown({
    required CustomController.MapController controller,
    required int? selectedType,
    required Function(int?) onTypeChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: selectedType,
      hint: const Text("Chọn loại thảm họa"),
      decoration: _getInputDecoration(hintText: "Chọn loại thảm họa", prefixIcon: Icons.warning_amber),
      iconEnabledColor: primaryColor,
      style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
      dropdownColor: Colors.white,
      selectedItemBuilder: (context) {
        return controller.disasterTypes.map((type) {
          return Row(
            children: [
              SvgHelper.buildSvgFromBase64(base64String: type.image, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(
                type.name,
                style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          );
        }).toList();
      },
      items: controller.disasterTypes.map((type) {
        return DropdownMenuItem<int>(
          value: type.id,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: selectedType == type.id ? Colors.blue.shade50 : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                SvgHelper.buildSvgFromBase64(base64String: type.image, width: 24, height: 24),
                const SizedBox(width: 12),
                Text(
                  type.name,
                  style: TextStyle(
                    color: selectedType == type.id ? primaryColor : Colors.black87,
                    fontSize: 15,
                    fontWeight: selectedType == type.id ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: onTypeChanged,
    );
  }

  static Widget _buildTypePreview(dynamic selectedDisasterType) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          SvgHelper.buildSvgFromBase64(
            base64String: selectedDisasterType.image,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Text(
            'Đã chọn: ${selectedDisasterType.name}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLocationInfo(bool isCreate, Disaster? disaster, CustomController.MapController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.redAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCreate
                  ? "Lat: ${controller.selectedPoint?.latitude.toStringAsFixed(6)}\n"
                  "Lon: ${controller.selectedPoint?.longitude.toStringAsFixed(6)}"
                  : "Lat: ${disaster!.lat.toStringAsFixed(6)}\n"
                  "Lon: ${disaster.lon.toStringAsFixed(6)}",
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildImageSectionHeader(int totalImages) {
    return Row(
      children: [
        const Icon(Icons.photo_library, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        const Text(
          'Ảnh đính kèm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        if (totalImages > 0)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Chip(
              label: Text(
                '$totalImages ảnh',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: primaryColor,
              padding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }

  static Widget _buildImageSelectionButtons(VoidCallback onSelectImages, VoidCallback onCaptureImage) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onSelectImages,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: primaryColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.photo_library, color: primaryColor),
                    SizedBox(width: 8),
                    Text('Thư viện', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onCaptureImage,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: accentColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, color: accentColor),
                    SizedBox(width: 8),
                    Text('Chụp ảnh', style: TextStyle(color: accentColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildImageThumbnail({
    required String imagePath,
    required VoidCallback onRemove,
    bool isNew = false,
    bool isDeleted = false,
    VoidCallback? onRestore,
  }) {
    Color borderColor = Colors.grey.shade300;
    String statusText = 'HIỆN CÓ';
    Color statusColor = Colors.grey;

    if (isNew) {
      borderColor = accentColor;
      statusText = 'MỚI';
      statusColor = accentColor;
    }
    if (isDeleted) {
      borderColor = Colors.red.shade300;
      statusText = 'XÓA';
      statusColor = Colors.red;
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isDeleted
                ? Container(
              color: Colors.red.shade50,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever, color: Colors.red.shade400, size: 30),
                  Text('Sẽ Xóa', style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                ],
              ),
            )
                : Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey.shade400),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 6,
          left: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: isDeleted ? onRestore : onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDeleted ? accentColor : Colors.red,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: Icon(
                isDeleted ? Icons.restore : Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildImageGrids(
      List<DisasterImage> visibleExistingImages,
      List<String> newImagePaths,
      Set<int> imageIdsToRemove,
      Function(int) onRemoveExistingImage,
      Function(int) onRemoveNewImage,
      Function(int) onRestoreExistingImage,
      List<DisasterImage> allExistingImages,
      ) {
    List<Widget> imageWidgets = [];

    // 1. Ảnh hiện có (không bị xóa)
    for (var i = 0; i < visibleExistingImages.length; i++) {
      final image = visibleExistingImages[i];
      imageWidgets.add(_buildImageThumbnail(
        imagePath: image.imagePath,
        onRemove: () => onRemoveExistingImage(image.id!),
      ));
    }

    // 2. Ảnh mới
    for (var i = 0; i < newImagePaths.length; i++) {
      imageWidgets.add(_buildImageThumbnail(
        imagePath: newImagePaths[i],
        onRemove: () => onRemoveNewImage(i),
        isNew: true,
      ));
    }

    // 3. Ảnh sẽ bị xóa (Hiển thị mờ hoặc khác biệt)
    final imagesToDelete = allExistingImages.where((img) => imageIdsToRemove.contains(img.id)).toList();
    for (var image in imagesToDelete) {
      imageWidgets.add(_buildImageThumbnail(
        imagePath: image.imagePath,
        onRemove: () {}, // Không cần onRemove
        isDeleted: true,
        onRestore: () => onRestoreExistingImage(image.id!),
      ));
    }

    if (imageWidgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách ảnh:',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imageWidgets.length,
          itemBuilder: (ctx, index) => imageWidgets[index],
        ),
      ],
    );
  }

  static Widget _buildImagePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'Chưa có ảnh nào được thêm',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Sử dụng các nút bên trên để thêm ảnh',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
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
    required List<String> newImagePaths,
    required List<int> imageIdsToRemove,
    required VoidCallback onSuccess,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isCreate) ...[
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('Xóa', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.red)),
                      content: const Text('Bạn có chắc muốn **xóa vĩnh viễn** thảm họa này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Xóa', style: TextStyle(color: Colors.white)),
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
                        const SnackBar(content: Text("Đã xóa thành công", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                if (selectedType == null || nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠️ Vui lòng nhập đủ thông tin bắt buộc (Loại, Tên)", style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => const Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
                  ),
                );

                bool success;
                try {
                  if (isCreate) {
                    success = await controller.createDisaster(
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                      typeId: selectedType,
                      imagePaths: newImagePaths,
                    );
                  } else {
                    success = await controller.updateDisaster(
                      id: disaster!.id!,
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                      typeId: selectedType,
                      newImagePaths: newImagePaths,
                      imageIdsToRemove: imageIdsToRemove,
                    );
                  }

                  // Hide loading
                  Navigator.pop(context);

                  if (success) {
                    Navigator.pop(context); // Đóng dialog chính
                    onSuccess();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isCreate ? "✅ Thêm mới thành công" : "✅ Cập nhật thành công",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: accentColor,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("❌ Có lỗi xảy ra trong quá trình lưu dữ liệu.", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Hide loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("❌ Lỗi hệ thống: ${e.toString()}", style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                isCreate ? "THÊM MỚI" : "LƯU THAY ĐỔI",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

    List<String> _newImagePaths = [];
    List<DisasterImage> _existingImages = [];
    Set<int> _imageIdsToRemove = {};

    if (!isCreate && disaster != null && disaster.images != null) {
      _existingImages = List.from(disaster.images!);
    }

    // Sử dụng DraggableScrollableSheet cho UI hiện đại và linh hoạt
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75, // Bắt đầu từ 75%
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) =>
            StatefulBuilder(
              builder: (context, setModalState) {
                final selectedDisasterType = selectedType != null
                    ? controller.getDisasterType(selectedType!)
                    : null;

                void _selectImage() async {
                  try {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images = await picker.pickMultiImage(imageQuality: 75);

                    if (images.isNotEmpty) {
                      setModalState(() {
                        _newImagePaths.addAll(images.map((img) => img.path));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Đã chọn ${images.length} ảnh", style: const TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 2),
                          backgroundColor: _DisasterDialogUIHelper.accentColor,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi khi chọn ảnh: $e", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                    );
                  }
                }

                void _captureImage() async {
                  try {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                      preferredCameraDevice: CameraDevice.rear,
                    );

                    if (image != null) {
                      setModalState(() {
                        _newImagePaths.add(image.path);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Đã chụp ảnh", style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 2),
                          backgroundColor: _DisasterDialogUIHelper.accentColor,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Lỗi khi chụp ảnh: $e", style: const TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }

                return Column(
                  children: [
                    // Header cố định
                    _DisasterDialogUIHelper._buildHeader(
                      context: ctx,
                      isCreate: isCreate,
                      controller: controller,
                    ),

                    // Form có thể cuộn
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            _DisasterDialogUIHelper._buildForm(
                              context: context,
                              controller: controller,
                              isCreate: isCreate,
                              disaster: disaster,
                              nameController: nameController,
                              descController: descController,
                              selectedType: selectedType,
                              selectedDisasterType: selectedDisasterType,
                              newImagePaths: _newImagePaths,
                              existingImages: _existingImages,
                              imageIdsToRemove: _imageIdsToRemove,
                              onTypeChanged: (val) {
                                setModalState(() => selectedType = val);
                              },
                              onSelectImages: _selectImage,
                              onCaptureImage: _captureImage,
                              onRemoveNewImage: (index) {
                                setModalState(() {
                                  _newImagePaths.removeAt(index);
                                });
                              },
                              onRemoveExistingImage: (imageId) {
                                setModalState(() {
                                  _imageIdsToRemove.add(imageId);
                                });
                              },
                              onRestoreExistingImage: (imageId) {
                                setModalState(() {
                                  _imageIdsToRemove.remove(imageId);
                                });
                              },
                            ),
                            // Thêm khoảng đệm dưới cùng cho nút actions
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),

                    // Actions cố định ở dưới cùng
                    _DisasterDialogUIHelper._buildActions(
                      context: ctx,
                      controller: controller,
                      isCreate: isCreate,
                      disaster: disaster,
                      nameController: nameController,
                      descController: descController,
                      selectedType: selectedType,
                      newImagePaths: _newImagePaths,
                      imageIdsToRemove: _imageIdsToRemove.toList(),
                      onSuccess: onSuccess,
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }
}