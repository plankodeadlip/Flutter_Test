import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/disaster_type.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../app/models/disaster_image.dart';
import'../../helpers/disaster_dialog_UI_helper.dart';

/// Content widget cho DisasterDialog
class _DisasterDialogContent extends StatefulWidget {
  final CustomController.MapController controller;
  final bool isCreate;
  final Disaster? disaster;
  final VoidCallback onSuccess;

  const _DisasterDialogContent({
    required this.controller,
    required this.isCreate,
    this.disaster,
    required this.onSuccess,
  });

  @override
  State<_DisasterDialogContent> createState() => _DisasterDialogContentState();
}

class _DisasterDialogContentState extends State<_DisasterDialogContent>
    with WidgetsBindingObserver {
  late TextEditingController nameController;
  late TextEditingController descController;
  int? selectedTypeId;
  List<String> _newImagePaths = [];
  List<DisasterImage> _existingImages = [];
  Set<int> _imageIdsToRemove = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    nameController = TextEditingController(
      text: widget.isCreate ? '' : widget.disaster!.name,
    );
    descController = TextEditingController(
      text: widget.isCreate ? '' : widget.disaster!.description,
    );
    selectedTypeId = widget.isCreate ? null : widget.disaster!.typeId;

    if (!widget.isCreate) {
      print('=== DISASTER INFO ===');
      print('Disaster ID: ${widget.disaster!.id}');
      print('Disaster Name: ${widget.disaster!.name}');
      print('Disaster Images: ${widget.disaster!.images?.length ?? 0}');

      if (widget.disaster!.images != null) {
        for (var img in widget.disaster!.images!) {
          print('Image ID: ${img.id}, Path: ${img.imagePath}');
        }
      }
    }

    if (!widget.isCreate &&
        widget.disaster != null &&
        widget.disaster!.images != null &&
        widget.disaster!.images!.isNotEmpty) {
      _existingImages = List.from(widget.disaster!.images!);
      print('Loaded ${_existingImages.length} existing images');
    } else {
      print('No existing images found');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    nameController.dispose();
    descController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Đã chọn ${images.length} ảnh",
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: DisasterDialogUIHelper.accentColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Lỗi khi chọn ảnh: $e",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Đã chụp ảnh",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: DisasterDialogUIHelper.accentColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Lỗi khi chụp ảnh: $e",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DisasterType? selectedDisasterType = selectedTypeId != null
        ? widget.controller.getDisasterType(selectedTypeId!)
        : null;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Header
          DisasterDialogUIHelper.buildHeader(
            context: context,
            isCreate: widget.isCreate,
            controller: widget.controller,
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  DisasterDialogUIHelper.buildForm(
                    context: context,
                    controller: widget.controller,
                    isCreate: widget.isCreate,
                    disaster: widget.disaster,
                    nameController: nameController,
                    descController: descController,
                    selectedType: selectedTypeId,
                    selectedDisasterType: selectedDisasterType,
                    newImagePaths: _newImagePaths,
                    existingImages: _existingImages,
                    imageIdsToRemove: _imageIdsToRemove,
                    onTypeChanged: (val) {
                      if (mounted) setState(() => selectedTypeId = val);
                    },
                    onSelectImages: _selectImage,
                    onCaptureImage: _captureImage,
                    onRemoveNewImage: (index) {
                      if (mounted) {
                        setState(() => _newImagePaths.removeAt(index));
                      }
                    },
                    onRemoveExistingImage: (imageId) {
                      if (mounted) {
                        setState(() => _imageIdsToRemove.add(imageId));
                      }
                    },
                    onRestoreExistingImage: (imageId) {
                      if (mounted) {
                        setState(() => _imageIdsToRemove.remove(imageId));
                      }
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Actions
          DisasterDialogUIHelper.buildActions(
            context: context,
            controller: widget.controller,
            isCreate: widget.isCreate,
            disaster: widget.disaster,
            nameController: nameController,
            descController: descController,
            selectedType: selectedTypeId,
            newImagePaths: _newImagePaths,
            imageIdsToRemove: _imageIdsToRemove.toList(),
            onSuccess: widget.onSuccess,
          ),
        ],
      ),
    );
  }
}

/// Widget chính để hiển thị DisasterDialog
class DisasterDialogWidget {
  /// Hiển thị dialog thêm/sửa thảm họa
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