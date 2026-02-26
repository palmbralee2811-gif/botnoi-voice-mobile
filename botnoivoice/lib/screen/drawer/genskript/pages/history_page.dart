import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/history_service.dart';
import 'history_detail_page.dart'; // ✅ Import the detail page

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _historyItems = [];
  dynamic _selectedItem; // For Desktop Split View
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final items = await HistoryService.fetchHistory();
    if (mounted) {
      setState(() {
        // Sort items เรียงตามวันที่อัปเดต/สร้าง ล่าสุดให้อยู่บนสุดเสมอ
        items.sort((a, b) {
          String dateA = a['updated_at'] ?? a['created_at'] ?? "";
          String dateB = b['updated_at'] ?? b['created_at'] ?? "";

          DateTime timeA = DateTime.tryParse(dateA) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          DateTime timeB = DateTime.tryParse(dateB) ??
              DateTime.fromMillisecondsSinceEpoch(0);

          return timeB.compareTo(
              timeA); // เอา B เทียบ A จะได้แบบ Descending (ใหม่ไปเก่า)
        });

        _historyItems = items;

        _isLoading = false;
        // Auto-select first item for desktop view
        if (_historyItems.isNotEmpty && _selectedItem == null) {
          _selectedItem = _historyItems.first;
        }
      });
    }
  }

  Future<void> _handleDelete(String id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Workspace"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await HistoryService.deleteWorkspace(id);
      if (success) {
        _loadHistory(); // Refresh list
        setState(() => _selectedItem = null);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Deleted successfully")));
      } else {
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to delete")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 1024;

        if (_isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blue));
        }

        if (_historyItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text("ยังไม่มีประวัติ",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18)),
                Text("เริ่มสร้างสคริปต์เพื่อดูประวัติที่นี่",
                    style:
                        GoogleFonts.prompt(fontSize: 14, color: Colors.grey)),
              ],
            ),
          );
        }

        return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
      },
    );
  }

  // --- DESKTOP LAYOUT (Split View) ---
  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: List
          Expanded(
            flex: 1,
            child: ListView.separated(
              itemCount: _historyItems.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _historyItems[index];
                return _buildHistoryItemCard(item, onTap: () {
                  setState(() => _selectedItem = item);
                });
              },
            ),
          ),
          const SizedBox(width: 24),
          // Right: Detail View
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: _selectedItem == null
                  ? Center(
                      child: Text("Select an item to view details",
                          style: GoogleFonts.prompt()))
                  : HistoryDetailPage(
                      key: ValueKey(_selectedItem['id'] ??
                          _selectedItem['_id']), // Force refresh on change
                      item: _selectedItem,
                      onBack: () => setState(() => _selectedItem = null),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MOBILE LAYOUT (Navigation) ---
  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _historyItems.length,
        separatorBuilder: (c, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _historyItems[index];
          return _buildHistoryItemCard(item, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  backgroundColor: const Color(0xFFF9FAFB),
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: const BackButton(color: Colors.black),
                    title: Text(item['title'] ?? "Detail",
                        style: GoogleFonts.prompt(color: Colors.black)),
                  ),
                  body: HistoryDetailPage(
                      item: item, onBack: () => Navigator.pop(context)),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // --- CUSTOM CARD WIDGET ---
  Widget _buildHistoryItemCard(dynamic item, {required VoidCallback onTap}) {
    String title = item['title'] ?? item['genskript_id'] ?? "Untitled";

    // Parse Date
    String dateStr = item['updated_at'] ??
        item['created_at'] ??
        DateTime.now().toIso8601String();
    DateTime date = DateTime.tryParse(dateStr) ?? DateTime.now();
    String formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    // เช็คสถานะการประมวลผล
    bool isProcessing = item['video_status'] == 'processing';

    // เช็คว่ามีไฟล์ให้โหลดหรือไม่ โดยเช็คจากฟิลด์ audio ตาม JSON
    bool hasDownload = !isProcessing &&
        ((item['audio'] != null && item['audio'].toString().isNotEmpty) ||
            (item['scripts'] != null &&
                item['scripts'].isNotEmpty &&
                item['scripts'][0]['audio'] != null));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ]),
        child: Row(
          children: [
            // Left Side: Title and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isProcessing) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: Colors.orange.shade200)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.hourglass_bottom,
                                  size: 12, color: Colors.orange.shade600),
                              const SizedBox(width: 4),
                              Text("กำลังประมวลผลวิดีโอ",
                                  style: GoogleFonts.prompt(
                                      fontSize: 11,
                                      color: Colors.orange.shade700)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Last update: $formattedDate",
                    style: GoogleFonts.prompt(
                        fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // Middle: Gradient Download Button (Visible only if video exists)
            if (hasDownload) ...[
              const SizedBox(width: 8),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9E81FF), Color(0xFF2CB5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // ใส่ Logic ดาวน์โหลดเสียง (audio) หรือวิดีโอ (videoUrl) ตามต้องการ
                    String targetUrl =
                        item['audio'] ?? item['scripts'][0]['audio'];
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("เตรียมดาวน์โหลด...")));
                    // Add logic to call DownloadService here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    "ดาวน์โหลด",
                    style: GoogleFonts.prompt(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],

            // Right: 3-Dot Menu (Delete)
            PopupMenuButton<String>(
              icon:
                  Icon(Icons.more_vert, color: Colors.grey.shade700, size: 20),
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'delete') {
                  _handleDelete(item['genskript_id'] ?? item['id'] ?? "");
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text('Delete',
                          style: GoogleFonts.prompt(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
