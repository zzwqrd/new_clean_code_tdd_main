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

class SingleSelectDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final ValueChanged<DropdownItem?> onChanged;
  final String hintText;
  final bool isLoading;
  final DropdownItem? value;

  const SingleSelectDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText = "اختر عنصر",
    this.isLoading = false,
    this.value,
  }) : super(key: key);

  @override
  _SingleSelectDropdownState createState() => _SingleSelectDropdownState();
}

class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
  DropdownItem? selectedItem;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.value;
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
            constraints: BoxConstraints(maxHeight: 60),
            child: widget.isLoading
                ? Center(child: CircularProgressIndicator())
                : selectedItem == null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.hintText,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Chip(
                        label: Text(selectedItem!.title),
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: () {
                          setState(() {
                            selectedItem!.isSelected = false;
                            selectedItem = null;
                            widget.onChanged(null);
                          });
                        },
                        backgroundColor: Colors.orangeAccent,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
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

  Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
    return Column(
      children: [
        ListTile(
          leading: Radio<DropdownItem>(
            value: item,
            groupValue: selectedItem,
            onChanged: (selected) {
              setState(() {
                selectedItem = selected;
                widget.onChanged(selected);
              });
            },
            activeColor: Colors.green,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              color: selectedItem == item ? Colors.green : Colors.black,
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
                selectedItem = item;
                widget.onChanged(item);
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
