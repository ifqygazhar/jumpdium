import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/page/jump_media_page.dart';

class LinkDialogContent extends StatefulWidget {
  final bool isDarkMode;
  final TextEditingController textController;

  const LinkDialogContent({
    super.key,
    required this.isDarkMode,
    required this.textController,
  });

  @override
  State<LinkDialogContent> createState() => _LinkDialogContentState();
}

class _LinkDialogContentState extends State<LinkDialogContent> {
  bool isMediumLink = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: getSurfaceColor(widget.isDarkMode),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: getTextColor(widget.isDarkMode), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jump to Article",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(widget.isDarkMode),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: getTextColor(widget.isDarkMode),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Link Type Selector
            Container(
              decoration: BoxDecoration(
                color: getBackgroundColor(widget.isDarkMode),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      label: "Medium",
                      icon: Icons.article,
                      isSelected: isMediumLink,
                      onTap: () {
                        setState(() {
                          isMediumLink = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildOptionButton(
                      label: "Other",
                      icon: Icons.public,
                      isSelected: !isMediumLink,
                      onTap: () {
                        setState(() {
                          isMediumLink = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Text Field
            TextField(
              controller: widget.textController,
              style: TextStyle(
                color: getTextColor(widget.isDarkMode),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: isMediumLink
                    ? "Paste Medium link here..."
                    : "Paste any article link here...",
                hintStyle: TextStyle(color: hintColor.withValues(alpha: 0.7)),
                filled: true,
                fillColor: getBackgroundColor(widget.isDarkMode),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.link,
                  color: hintColor.withValues(alpha: 0.7),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            // Jump Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final link = widget.textController.text.trim();
                  if (link.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a link"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (isMediumLink && !link.contains("medium.com")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid Medium.com link"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JumpMediaPage(link: link),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Jump",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : getBackgroundColor(widget.isDarkMode),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : hintColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : getTextColor(widget.isDarkMode),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
