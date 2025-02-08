import 'package:flutter/material.dart';

class DropdownItem {
  final String title;
  final int id;
  final List<DropdownItem>? children;
  bool isExpanded;
  bool isSelected;

  DropdownItem({
    required this.title,
    required this.id,
    this.children,
    this.isExpanded = false,
    this.isSelected = false,
  });
}

enum ChipDisplayMode { wrap, scrollableRow }

class MultiSelectDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final ChipDisplayMode chipDisplayMode;
  final ValueChanged<List<DropdownItem>> onChanged;
  final String hintText;
  final bool isLoading;
  final List<DropdownItem> value;

  const MultiSelectDropdown({
    Key? key,
    required this.items,
    this.chipDisplayMode = ChipDisplayMode.wrap,
    required this.onChanged,
    this.hintText = "اختر عناصر",
    this.isLoading = false,
    required this.value,
  }) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<DropdownItem> selectedValues = [];
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.isLoading
              ? null
              : () {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(
              maxHeight: widget.chipDisplayMode == ChipDisplayMode.wrap
                  ? _calculateWrapHeight()
                  : 60,
            ),
            child: widget.isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildChipDisplay(),
          ),
        ),
        if (isDropdownOpen && !widget.isLoading)
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: widget.items
                    .map((item) => _buildDropdownItem(item))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  double _calculateWrapHeight() {
    int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
    int numRows = (selectedValues.length / maxItemsInRow).ceil();
    return selectedValues.isEmpty
        ? 60.0
        : (numRows * 40.0) + 20; // Calculate height based on rows
  }

  Widget _buildChipDisplay() {
    if (selectedValues.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintText,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    switch (widget.chipDisplayMode) {
      case ChipDisplayMode.scrollableRow:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: selectedValues.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  label: Text(item.title),
                  deleteIcon: Icon(Icons.clear),
                  onDeleted: () {
                    setState(() {
                      item.isSelected = false;
                      selectedValues.remove(item);
                      widget.onChanged(selectedValues);
                    });
                  },
                  backgroundColor: Colors.orangeAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        );
      case ChipDisplayMode.wrap:
      default:
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedValues.map((item) {
            return Chip(
              label: Text(item.title),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  item.isSelected = false;
                  selectedValues.remove(item);
                  widget.onChanged(selectedValues);
                });
              },
              backgroundColor: Colors.orangeAccent,
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        );
    }
  }

  Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            value: selectedValues.contains(item),
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  selectedValues.add(item);
                  item.isSelected = true;
                } else {
                  selectedValues.remove(item);
                  item.isSelected = false;
                }
                widget.onChanged(selectedValues);
              });
            },
            activeColor: Colors.green,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              color:
                  selectedValues.contains(item) ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
          onTap: () {
            if (item.children != null) {
              setState(() {
                item.isExpanded = !item.isExpanded;
              });
            } else {
              setState(() {
                if (selectedValues.contains(item)) {
                  selectedValues.remove(item);
                  item.isSelected = false;
                } else {
                  selectedValues.add(item);
                  item.isSelected = true;
                }
                widget.onChanged(selectedValues);
              });
            }
          },
          trailing: item.children != null
              ? Icon(
                  item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 20,
                )
              : null,
        ),
        if (item.children != null && item.isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: item.children!
                  .map((child) => _buildDropdownItem(child, level: level + 1))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
