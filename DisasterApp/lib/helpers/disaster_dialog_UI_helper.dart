import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/disaster_type.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../app/models/disaster_image.dart';
import '../../../helpers/svg_helper.dart';
import 'dart:io';

/// Helper class chứa các hàm build UI cho DisasterDialog
class DisasterDialogUIHelper {
  // Màu sắc chính
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF388E3C);

  /// Build header của dialog
  static Widget buildHeader({
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
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
                controller.clearSelection();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Build form chính
  static Widget buildForm({
    required BuildContext context,
    required CustomController.MapController controller,
    required bool isCreate,
    required Disaster? disaster,
    required TextEditingController nameController,
    required TextEditingController descController,
    required int? selectedType,
    required DisasterType? selectedDisasterType,
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
          buildFormLabel('Loại thảm họa *', isRequired: true),
          buildTypeDropdown(
            controller: controller,
            selectedType: selectedType,
            onTypeChanged: onTypeChanged,
          ),
          if (selectedDisasterType != null) ...[
            const SizedBox(height: 12),
            buildTypePreview(selectedDisasterType),
          ],
          const SizedBox(height: 16),
          buildFormLabel('Tên sự kiện *', isRequired: true),
          TextFormField(
            controller: nameController,
            decoration: getInputDecoration(
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
          buildFormLabel('Mô tả'),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: getInputDecoration(
              hintText: "Mô tả chi tiết về sự kiện...",
              prefixIcon: Icons.description,
            ),
          ),
          const SizedBox(height: 16),
          buildFormLabel('Vị trí', color: primaryColor),
          buildLocationInfo(isCreate, disaster, controller),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 12),
          buildImageSectionHeader(totalImages),
          const SizedBox(height: 12),
          buildImageSelectionButtons(onSelectImages, onCaptureImage),
          const SizedBox(height: 16),
          buildImageGrids(
            visibleExistingImages,
            newImagePaths,
            imageIdsToRemove,
            onRemoveExistingImage,
            onRemoveNewImage,
            onRestoreExistingImage,
            existingImages,
          ),
          const SizedBox(height: 16),
          if (totalImages == 0 && imageIdsToRemove.isEmpty)
            buildImagePlaceholder(),
        ],
      ),
    );
  }

  /// Build label cho form field
  static Widget buildFormLabel(
    String label, {
    bool isRequired = false,
    Color color = Colors.black87,
  }) {
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

  /// Get InputDecoration cho TextField
  static InputDecoration getInputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey.shade600)
          : null,
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

  /// Build dropdown chọn loại thảm họa
  static Widget buildTypeDropdown({
    required CustomController.MapController controller,
    required int? selectedType,
    required Function(int?) onTypeChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: selectedType,
      hint: const Text("Chọn loại thảm họa"),
      decoration: getInputDecoration(
        hintText: "Chọn loại thảm họa",
        prefixIcon: Icons.warning_amber,
      ),
      iconEnabledColor: primaryColor,
      style: const TextStyle(
        color: primaryColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      selectedItemBuilder: (context) {
        return controller.disasterTypes.map((type) {
          return Row(
            children: [
              SvgHelper.buildSvgFromBase64(
                base64String: type.image,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                type.name,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
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
              color: selectedType == type.id
                  ? Colors.blue.shade50
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                SvgHelper.buildSvgFromBase64(
                  base64String: type.image,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  type.name,
                  style: TextStyle(
                    color:
                        selectedType == type.id ? primaryColor : Colors.black87,
                    fontSize: 15,
                    fontWeight: selectedType == type.id
                        ? FontWeight.w600
                        : FontWeight.normal,
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

  /// Build preview loại thảm họa đã chọn
  static Widget buildTypePreview(DisasterType selectedDisasterType) {
    final String imageName = selectedDisasterType.image;
    final String typeName = selectedDisasterType.name;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SvgHelper.buildSvgFromBase64(
            base64String: imageName,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Text(
            'Đã chọn: ${typeName}',
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

  /// Build thông tin vị trí
  static Widget buildLocationInfo(
    bool isCreate,
    Disaster? disaster,
    CustomController.MapController controller,
  ) {
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
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build header phần ảnh
  static Widget buildImageSectionHeader(int totalImages) {
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

  /// Build buttons chọn/chụp ảnh
  static Widget buildImageSelectionButtons(
    VoidCallback onSelectImages,
    VoidCallback onCaptureImage,
  ) {
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
                    Text(
                      'Thư viện',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                    Text(
                      'Chụp ảnh',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build thumbnail ảnh
  /// Build thumbnail ảnh
  static Widget buildImageThumbnail({
    required String imagePath,
    required VoidCallback onRemove,
    bool isNew = false,
    bool isDeleted = false,
    bool isExisting = false, // Biến này rất quan trọng
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

    // Tách logic hiển thị ảnh ra riêng
    Widget imageWidget;
    if (isDeleted) {
      imageWidget = Container(
        color: Colors.red.shade50,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.red.shade400,
              size: 30,
            ),
            Text(
              'Sẽ Xóa',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      imageWidget = Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 300,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, color: Colors.grey),
                const SizedBox(height: 4),
                Text('Lỗi file', style: TextStyle(fontSize: 10, color: Colors.grey)),              ],
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageWidget, // Sử dụng widget đã tách logic ở trên
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

  /// Build grid ảnh
  static Widget buildImageGrids(
    List<DisasterImage> visibleExistingImages,
    List<String> newImagePaths,
    Set<int> imageIdsToRemove,
    Function(int) onRemoveExistingImage,
    Function(int) onRemoveNewImage,
    Function(int) onRestoreExistingImage,
    List<DisasterImage> allExistingImages,
  ) {
    List<Widget> imageWidgets = [];

    print('=== DEBUG IMAGE INFO ===');
    print('Total existing images: ${allExistingImages.length}');
    print('Visible existing images: ${visibleExistingImages.length}');
    print('New image paths: ${newImagePaths.length}');
    print('Images to remove: ${imageIdsToRemove.length}');

    for (var img in allExistingImages) {
      print('Existing image ID: ${img.id}, Path: ${img.imagePath}');
    }

    // Ảnh hiện có
    for (var i = 0; i < visibleExistingImages.length; i++) {
      final image = visibleExistingImages[i];
      imageWidgets.add(
        buildImageThumbnail(
          imagePath: image.imagePath,
          onRemove: () {
            print('Removing existing image: ${image.id}');
            onRemoveExistingImage(image.id!);
          },
          isExisting: true,
        ),
      );
    }

    // Ảnh mới
    for (var i = 0; i < newImagePaths.length; i++) {
      print('Adding new image: ${newImagePaths[i]}');
      imageWidgets.add(
        buildImageThumbnail(
          imagePath: newImagePaths[i],
          onRemove: () {
            print('Removing new image at index: $i');
            onRemoveNewImage(i);
          },
          isNew: true,
        ),
      );
    }

    // Ảnh sẽ bị xóa
    final imagesToDelete = allExistingImages
        .where((img) => imageIdsToRemove.contains(img.id))
        .toList();
    for (var image in imagesToDelete) {
      imageWidgets.add(
        buildImageThumbnail(
          imagePath: image.imagePath,
          onRemove: () {},
          isDeleted: true,
          onRestore: () {
            print('Restoring image: ${image.id}');
            onRestoreExistingImage(image.id!);
          },
        ),
      );
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

  /// Build placeholder khi không có ảnh
  static Widget buildImagePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Chưa có ảnh nào được thêm',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sử dụng các nút bên trên để thêm ảnh',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build actions (nút Xóa, Lưu)
  static Widget buildActions({
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
                label: const Text(
                  'Xóa',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _handleDelete(
                  context,
                  controller,
                  disaster,
                  onSuccess,
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _handleSave(
                context,
                controller,
                isCreate,
                disaster,
                nameController,
                descController,
                selectedType,
                newImagePaths,
                imageIdsToRemove,
                onSuccess,
              ),
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

  /// Xử lý xóa thảm họa
  static Future<void> _handleDelete(
    BuildContext context,
    CustomController.MapController controller,
    Disaster? disaster,
    VoidCallback onSuccess,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text('Bạn có chắc muốn **xóa vĩnh viễn** thảm họa này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      bool ok = await controller.deleteDisaster(disaster!.id!);
      if (ok && context.mounted) {
        Navigator.pop(context);
        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Đã xóa thành công",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Xử lý lưu/cập nhật thảm họa
  static Future<void> _handleSave(
    BuildContext context,
    CustomController.MapController controller,
    bool isCreate,
    Disaster? disaster,
    TextEditingController nameController,
    TextEditingController descController,
    int? selectedType,
    List<String> newImagePaths,
    List<int> imageIdsToRemove,
    VoidCallback onSuccess,
  ) async {
    // Validate
    if (selectedType == null || nameController.text.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "⚠️ Vui lòng nhập đủ thông tin bắt buộc (Loại, Tên)",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Show loading
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

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
      if (context.mounted) Navigator.pop(context);

      if (success && context.mounted) {
        Navigator.pop(context);
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
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "❌ Có lỗi xảy ra trong quá trình lưu dữ liệu.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ Lỗi hệ thống: ${e.toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
