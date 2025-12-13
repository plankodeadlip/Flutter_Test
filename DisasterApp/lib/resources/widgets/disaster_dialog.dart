import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/disaster_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../app/models/disaster_image.dart';
import '../../app/forms/disaster_form.dart';
import 'buttons/buttons.dart';

/// Content widget cho DisasterDialog
class _DisasterDialogContent extends NyStatefulWidget {
  final CustomController.MapController controller;
  final bool isCreate;
  final Disaster? disaster;
  final VoidCallback onSuccess;

  _DisasterDialogContent({
    Key? key,
    required this.controller,
    required this.isCreate,
    this.disaster,
    required this.onSuccess,
  }) : super(key: key, child: () => _DisasterDialogContentState());
}

class _DisasterDialogContentState extends NyState<_DisasterDialogContent>
    with WidgetsBindingObserver {
  late CustomController.MapController controller;
  late DisasterForm form;
  int? selectedTypeId;
  List<String> _newImagePaths = [];
  List<DisasterImage> _existingImages = [];
  Set<int> _imageIdsToRemove = {};

  late TextEditingController _latController;
  late TextEditingController _lonController;
  bool _isLocationFromMap = false;

  @override
  get init => () async {
    WidgetsBinding.instance.addObserver(this);
    controller = widget.controller;

    // ✅ Khởi tạo form với initial values
    if (!widget.isCreate && widget.disaster != null) {
      form = DisasterForm(
        initialName: widget.disaster!.name,
        initialDescription: widget.disaster!.description,
      );

      _latController = TextEditingController(text: widget.disaster!.lat.toString());
      _lonController = TextEditingController(text: widget.disaster!.lon.toString());
      _isLocationFromMap = false;

      selectedTypeId = widget.disaster!.typeId;

      if (widget.disaster!.images != null && widget.disaster!.images!.isNotEmpty) {
        _existingImages = List.from(widget.disaster!.images!);
        print('✅ Loaded ${_existingImages.length} existing images');
      }
    } else {
      // Create mode
      form = DisasterForm();

      if (controller.hasSelectedPoint) {
        _latController = TextEditingController(
            text: controller.selectedPoint!.latitude.toStringAsFixed(6)
        );
        _lonController = TextEditingController(
            text: controller.selectedPoint!.longitude.toStringAsFixed(6)
        );
        _isLocationFromMap = true;
      } else {
        _latController = TextEditingController();
        _lonController = TextEditingController();
        _isLocationFromMap = false;
      }
    }

    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) setState(() {});
  };

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Chọn ảnh từ thư viện
  void _selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 75);

      if (images.isNotEmpty && mounted) {
        setState(() {
          _newImagePaths.addAll(images.map((img) => img.path));
        });
        showToastNotification(
          context,
          title: "Thành công",
          description: "Đã chọn ${images.length} ảnh",
          style: ToastNotificationStyleType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Không thể chọn ảnh: $e",
          style: ToastNotificationStyleType.danger,
        );
      }
    }
  }

  /// Chụp ảnh bằng camera
  void _captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null && mounted) {
        setState(() {
          _newImagePaths.add(image.path);
        });
        showToastNotification(
          context,
          title: "Thành công",
          description: "Đã chụp ảnh",
          style: ToastNotificationStyleType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Không thể chụp ảnh: $e",
          style: ToastNotificationStyleType.danger,
        );
      }
    }
  }

  /// Submit form
  Future<void> _submitForm(Map<String, dynamic> data) async {
    try {
      if (selectedTypeId == null) {
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Vui lòng chọn loại thảm họa",
          style: ToastNotificationStyleType.warning,
        );
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      final formData = data as Map<String, dynamic>;
      final name = formData['name']?.toString().trim() ?? '';
      final description = formData['description']?.toString().trim() ?? '';

      if (name.isEmpty) {
        Navigator.pop(context); // Hide loading
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Tên thảm họa không được để trống",
          style: ToastNotificationStyleType.warning,
        );
        return;
      }

      bool success;
      if (widget.isCreate) {
        success = await controller.createDisaster(
          name: name,
          description: description,
          typeId: selectedTypeId!,
          imagePaths: _newImagePaths,
        );
      } else {
        success = await controller.updateDisaster(
          id: widget.disaster!.id!,
          name: name,
          description: description,
          typeId: selectedTypeId!,
          newImagePaths: _newImagePaths,
          imageIdsToRemove: _imageIdsToRemove.toList(),
        );
      }
      if (mounted) Navigator.pop(context);

      if (success && mounted) {
        Navigator.pop(context);
        widget.onSuccess();
        showToastNotification(
          context,
          title: "Thành công",
          description:
              widget.isCreate ? "Đã thêm thảm họa mới" : "Đã cập nhật thảm họa",
          style: ToastNotificationStyleType.success,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);

      if (mounted) {
        showToastNotification(
          context,
          title: "Lỗi",
          description: "Không thể lưu thảm họa: $e",
          style: ToastNotificationStyleType.danger,
        );
      }
    }
  }

  @override
  Widget view(BuildContext context) {
    final DisasterType? selectedDisasterType = selectedTypeId != null
        ? controller.getDisasterType(selectedTypeId!)
        : null;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Header
          _buildHeader(),
          // Form
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loại thảm họa
                  _buildDisasterTypeSelector(selectedDisasterType),

                  SizedBox(height: 16),

                  // NyForm fields
                  NyForm(
                    form: form,
                    validateOnFocusChange: true,
                  ),

                  SizedBox(height: 16),

                  // Lat/Lon readonly fields
                  _buildLocationFields(),

                  SizedBox(height: 16),

                  // Quản lý ảnh
                  _buildImageSection(),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Submit button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Text(
            widget.isCreate ? "Thêm thảm họa mới" : "Chỉnh sửa thảm họa",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              controller.clearSelection();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDisasterTypeSelector(DisasterType? selectedType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Loại thảm họa *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: selectedTypeId,
          focusColor: Colors.red,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          hint: Text("Chọn loại thảm họa"),
          items: controller.disasterTypes.map((type) {
            return DropdownMenuItem<int>(
              value: type.id,
              child: Text(type.name),
            );
          }).toList(),
          onChanged: (value) {
            if (mounted) setState(() => selectedTypeId = value);
          },
          validator: (value) {
            if (value == null) return "Vui lòng chọn loại thảm họa";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vĩ độ (Latitude) *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _latController,
                    readOnly: _isLocationFromMap,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      filled: true,
                      fillColor: _isLocationFromMap
                          ? Colors.grey.shade200
                          : Colors.grey.shade50,
                      suffixIcon: _isLocationFromMap
                          ? Icon(Icons.lock_outline,
                              size: 18, color: Colors.grey)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kinh độ (Longitude) *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _lonController,
                    readOnly: _isLocationFromMap,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      filled: true,
                      fillColor: _isLocationFromMap
                          ? Colors.grey.shade200
                          : Colors.grey.shade50,
                      suffixIcon: _isLocationFromMap
                          ? Icon(Icons.lock_outline,
                              size: 18, color: Colors.grey)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLocationFromMap) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tọa độ được chọn từ bản đồ (chỉ đọc)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Hình ảnh",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: _selectImage,
              icon: Icon(Icons.photo_library, size: 18),
              label: Text("Chọn ảnh"),
            ),
            TextButton.icon(
              onPressed: _captureImage,
              icon: Icon(Icons.camera_alt, size: 18),
              label: Text("Chụp"),
            ),
          ],
        ),
        SizedBox(height: 8),

        // Existing images
        if (_existingImages.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _existingImages.map((img) {
              final isMarkedForRemoval = _imageIdsToRemove.contains(img.id);
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isMarkedForRemoval
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Opacity(
                        opacity: isMarkedForRemoval ? 0.3 : 1.0,
                        child: Image.file(
                          File(img.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      icon: Icon(
                        isMarkedForRemoval ? Icons.undo : Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            isMarkedForRemoval ? Colors.orange : Colors.red,
                        padding: EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isMarkedForRemoval) {
                            _imageIdsToRemove.remove(img.id);
                          } else {
                            _imageIdsToRemove.add(img.id!);
                          }
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 8),
        ],

        // New images
        if (_newImagePaths.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _newImagePaths.asMap().entries.map((entry) {
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.green.shade300, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(entry.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      icon: Icon(Icons.close, size: 18, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        setState(() {
                          _newImagePaths.removeAt(entry.key);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
        if (_existingImages.isEmpty && _newImagePaths.isEmpty)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                "Chưa có ảnh nào",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clearSelection();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Hủy"),
            ),
          ),
          SizedBox(width: 12),

          // 🔥 Nút Submit dùng chuẩn mới của Nylo 6.9
          Expanded(
            flex: 2,
            child: Button.primary(
              text: widget.isCreate ? "Thêm mới" : "Cập nhật",
              submitForm: (
                form,
                (data) async {
                  await _submitForm(Map<String, dynamic>.from(data));
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget chính để hiển thị DisasterDialog
class DisasterDialogWidget {
  static void show({
    required BuildContext context,
    required CustomController.MapController controller,
    required bool isCreate,
    Disaster? disaster,
    required VoidCallback onSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) => WillPopScope(
        onWillPop: () async {
          controller.clearSelection();
          return true;
        },
        child: _DisasterDialogContent(
          controller: controller,
          isCreate: isCreate,
          disaster: disaster,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}
