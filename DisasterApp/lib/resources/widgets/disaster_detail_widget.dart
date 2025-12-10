import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/controllers/map_controller.dart' as CustomController;
import '../../../app/models/disaster.dart';
import '../../../helpers/svg_helper.dart';

class DisasterDetailWidget {
  static void show({
    required BuildContext context,
    required CustomController.MapController controller,
    required Disaster disaster,
  }) async {
    // Hiển thị loading nhẹ hoặc chờ dữ liệu
    final detailedDisaster = await controller.loadDisasterDetails(disaster.id!);
    if (detailedDisaster == null) return;
    final selectedDisasterType = controller.getDisasterType(detailedDisaster.typeId);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Quan trọng để full chiều cao
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Thanh kéo (Handle bar)
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Header
                  _buildHeader(modalContext, detailedDisaster, controller),

                  const Divider(height: 1),

                  // Nội dung cuộn
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ảnh
                          _buildImageSection(
                              context, detailedDisaster, scrollController),

                          const SizedBox(height: 20),

                          // Loại thảm họa (Dạng Chip/Tag)
                          _buildTypeTag(selectedDisasterType),

                          const SizedBox(height: 12),

                          // Mô tả
                          const Text('Mô tả sự kiện',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            detailedDisaster.description.isNotEmpty
                                ? detailedDisaster.description
                                : "Không có mô tả chi tiết.",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.5,
                                fontSize: 14),
                          ),

                          const SizedBox(height: 24),

                          // Thông tin chi tiết (Grid 2 cột)
                          _buildInfoGrid(detailedDisaster),

                          const SizedBox(height: 24),

                          // Nút đóng (Optional, vì đã có nút X ở trên)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(modalContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Đóng"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildHeader(
      BuildContext modalContext,
      Disaster disaster,
      CustomController.MapController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              disaster.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(modalContext);
              controller.clearSelection();
            },
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              padding: const EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildTypeTag(dynamic selectedDisasterType) {
    if (selectedDisasterType == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgHelper.buildSvgFromBase64(
            base64String: selectedDisasterType.image,
            width: 20,
            height: 20,
            color: Colors.blue.shade700, // Tint màu nếu icon hỗ trợ
          ),
          const SizedBox(width: 8),
          Text(
            selectedDisasterType.name,
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildImageSection(
      BuildContext context, Disaster disaster, ScrollController sc) {
    if (disaster.images == null || disaster.images!.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined,
                size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text("Không có hình ảnh",
                style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: disaster.images!.length,
            controller: PageController(viewportFraction: 0.95),
            padEnds: false, // Align left nếu muốn
            itemBuilder: (context, index) {
              final image = disaster.images![index];
              return GestureDetector(
                onTap: () => _showFullImage(
                    context, image.imagePath, disaster.images!, index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(image.imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ),
                        ),
                        // Badge số lượng ảnh
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.photo_library,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  '${index + 1}/${disaster.images!.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Thumbnail strip nếu có nhiều ảnh
        if (disaster.images!.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: disaster.images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullImage(
                      context, disaster.images![index].imagePath, disaster.images!, index),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(
                        File(disaster.images![index].imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]
      ],
    );
  }

  static Widget _buildInfoGrid(Disaster disaster) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                label: "Vị trí",
                content:
                "${disaster.lat.toStringAsFixed(4)}, ${disaster.lon.toStringAsFixed(4)}",
                icon: Icons.location_on_rounded,
                iconColor: Colors.redAccent,
                bgColor: Colors.red.shade50,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                label: "Ngày tạo",
                content: _formatDate(disaster.createdAt),
                icon: Icons.calendar_today_rounded,
                iconColor: Colors.orangeAccent,
                bgColor: Colors.orange.shade50,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          label: "Cập nhật lần cuối",
          content: _formatDate(disaster.updatedAt),
          icon: Icons.update_rounded,
          iconColor: Colors.green,
          bgColor: Colors.green.shade50,
          isFullWidth: true,
        ),
      ],
    );
  }

  static Widget _buildInfoCard({
    required String label,
    required String content,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    // Helper format date đơn giản
    final local = date.toLocal();
    return "${local.day}/${local.month}/${local.year} - ${local.hour}:${local.minute.toString().padLeft(2, '0')}";
  }

  static void _showFullImage(
      BuildContext context,
      String initialImagePath,
      List images,
      int initialIndex,
      ) {
    // Giữ nguyên logic cũ, chỉ đổi background trong suốt hơn xíu nếu thích
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.file(
                      File(image.imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.white54),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }
}