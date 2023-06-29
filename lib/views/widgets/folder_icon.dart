import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderIcon extends StatefulWidget {
  final int savedCount;
  bool isFolderOpen;

  FolderIcon({required this.savedCount, required this.isFolderOpen});

  @override
  _FolderIconState createState() => _FolderIconState();
}

class _FolderIconState extends State<FolderIcon> {
  void toggleFolder() {
    setState(() {
      widget.isFolderOpen = !widget.isFolderOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleFolder,
      child: Column(
        children: [
          Icon(
            widget.isFolderOpen ? FontAwesomeIcons.solidFolder : FontAwesomeIcons.folderOpen,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          Text(
            widget.savedCount.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
