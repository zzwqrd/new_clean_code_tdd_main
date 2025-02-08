import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dropdown extends StatefulWidget {
  final List<String> list;
  final String? title;
  final Function(List<int>) selectedIndex; // Use dynamic type
  final int? selectedItem; // Use dynamic type
  final bool isFirstSelected;
  final bool isDisable;
  final bool isMultiSelect;
  final Color? borderColor;

  const Dropdown({
    required this.list,
    required this.selectedIndex,
    this.selectedItem,
    this.title,
    this.borderColor,
    this.isFirstSelected = true,
    this.isDisable = false,
    this.isMultiSelect = false,
    Key? key,
  }) : super(key: key);

  @override
  State<Dropdown> createState() => _PhoneNumberDropdownState();
}

class _PhoneNumberDropdownState extends State<Dropdown> {
  late List<String> textList;
  List<String> _currentSelectedItems = [];

  @override
  void initState() {
    super.initState();
    textList = widget.list;
    if (textList.isNotEmpty) {
      if (widget.isFirstSelected) {
        _currentSelectedItems = [
          widget.selectedItem == null
              ? textList[0]
              : textList[widget.selectedItem!]
        ];
      } else {
        _currentSelectedItems = [widget.title ?? ''];
      }
    } else {
      textList = ['لا توجد بيانات'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0.r),
        border: Border.all(
          color: widget.borderColor ?? Colors.blue,
        ),
      ),
      child: PopupMenuButton<String>(
        color: Colors.white,
        itemBuilder: (context) {
          return textList.map((str) {
            return PopupMenuItem(
              value: str,
              enabled: textList.isNotEmpty ? true : false,
              child: Text(
                str,
              ),
            );
          }).toList();
        },
        onSelected: widget.isDisable
            ? null
            : (v) {
                setState(() {
                  if (!widget.isMultiSelect) {
                    _currentSelectedItems = [v];
                  } else {
                    if (_currentSelectedItems.contains(v)) {
                      _currentSelectedItems.remove(v);
                    } else {
                      _currentSelectedItems.add(v);
                    }
                  }
                  List<int> selected = [];
                  print(_currentSelectedItems);
                  _currentSelectedItems.forEach((element) {
                    selected.add(widget.list.indexOf(element));
                  });

                  widget
                      .selectedIndex(selected); // Pass selected items as a List
                });
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.arrow_drop_down,
              size: 30.r,
              color: widget.isDisable ? Colors.amber : Colors.white,
            ),
            Expanded(
              child: Text(
                _currentSelectedItems.join(', '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final String? title;
  final Function(List<int>) onSelectionChanged;
  final int? initialSelectedItem;
  final bool isFirstSelected;
  final bool isDisabled;
  final bool isMultiSelect;
  final Color? borderColor;

  const MultiSelectDropdown({
    required this.items,
    required this.onSelectionChanged,
    this.initialSelectedItem,
    this.title,
    this.borderColor,
    this.isFirstSelected = true,
    this.isDisabled = false,
    this.isMultiSelect = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> _availableItems;
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _availableItems = widget.items;
    if (_availableItems.isNotEmpty) {
      if (widget.isFirstSelected) {
        _selectedItems = [
          widget.initialSelectedItem == null
              ? _availableItems[0]
              : _availableItems[widget.initialSelectedItem!]
        ];
      } else {
        _selectedItems = [widget.title ?? ''];
      }
    } else {
      _availableItems = ['No data available'];
      _selectedItems = [''];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: widget.borderColor ?? Colors.blue,
        ),
      ),
      child: PopupMenuButton<String>(
        color: Colors.black,
        itemBuilder: (context) {
          return _availableItems.map((item) {
            return PopupMenuItem(
              value: item,
              enabled: _availableItems.isNotEmpty,
              child: Text(item),
            );
          }).toList();
        },
        onSelected: widget.isDisabled
            ? null
            : (selectedValue) {
                setState(() {
                  if (!widget.isMultiSelect) {
                    _selectedItems = [selectedValue];
                  } else {
                    if (_selectedItems.contains(selectedValue)) {
                      _selectedItems.remove(selectedValue);
                    } else {
                      _selectedItems.add(selectedValue);
                    }
                  }
                  List<int> selectedIndexes = _selectedItems
                      .map((item) => widget.items.indexOf(item))
                      .toList();

                  widget.onSelectionChanged(selectedIndexes);
                });
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: widget.isDisabled ? Colors.amber : Colors.white,
            ),
            Expanded(
              child: Text(
                _selectedItems.join(', '),
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class Dropdown extends StatefulWidget {
//   final List<String> list ;
//   final String ?title;
//   final Function (int) selectedIndex;
//   final int ?selectedItem;
//   final bool isFirstSelected;
//   final bool isDisable;
//
//   const Dropdown({required this.list,required this.selectedIndex,this.selectedItem,this.title,this.isFirstSelected=true,this.isDisable=false,Key? key}) : super(key: key);
//
//   @override
//   State<Dropdown> createState() => _PhoneNumberDropdownState();
//
// }
//
// class _PhoneNumberDropdownState extends State<Dropdown> {
//   late List<String> textList ;
//    String ?_currentItemSelected;
//
//   @override
//   void initState() {
//     super.initState();
//     textList= widget.list;
//     if(widget.isFirstSelected){
//       _currentItemSelected = textList[widget.selectedItem ?? 0];
//     }else{
//       _currentItemSelected =widget.title;
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 50.h,
//       decoration: BoxDecoration(
//            color:  AppColors.mainDarkBlue,
//           borderRadius: BorderRadius.circular(10.0.r),
//           border:   Border.all(color:AppColors.policeBlue ,)
//       ),
//       child: PopupMenuButton<String>(
//         itemBuilder: (context) {
//           return textList.map((str) {
//             return PopupMenuItem(
//               value: str,
//               child: BasicText(titleText: str,color:widget.isDisable?AppColors.lightBlack:  AppColors.black),
//             );
//           }).toList();
//         },
//         onSelected: widget.isDisable?null: (v){
//           setState(() {
//             print('!!!===== $v');
//             widget.selectedIndex(textList.indexOf(v));
//             _currentItemSelected = v;
//           });
//         },
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Icon(Icons.arrow_drop_down ,size: 30.r,color:widget.isDisable?AppColors.hintColor:  AppColors.white),
//
//             Expanded(child: BasicText(titleText: _currentItemSelected??"",fontSize: 15.sp ,color: widget.isDisable?AppColors.hintColor: AppColors.white, )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MultiSelectDropdown extends StatefulWidget {
//   final List<String> items;
//   final List<String> selectedItems;
//   final ValueChanged<List<String>> onChanged;

//   MultiSelectDropdown({
//     Key? key,
//     required this.items,
//     required this.selectedItems,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
// }

// class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
//   late List<String> _selectedItems;

//   @override
//   void initState() {
//     super.initState();
//     _selectedItems = widget.selectedItems;
//   }

//   void _onItemCheckedChange(String item, bool checked) {
//     setState(() {
//       if (checked) {
//         _selectedItems.add(item);
//       } else {
//         _selectedItems.remove(item);
//       }
//     });
//     widget.onChanged(_selectedItems);
//   }

//   void _showMultiSelectDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Select Items'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: widget.items.map((item) {
//                 return CheckboxListTile(
//                   value: _selectedItems.contains(item),
//                   title: Text(item),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (checked) {
//                     _onItemCheckedChange(item, checked!);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showValueEditDialog(String item) {
//     TextEditingController _controller = TextEditingController(text: item);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Item'),
//           content: TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               labelText: 'Value',
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () {
//                 setState(() {
//                   int index = _selectedItems.indexOf(item);
//                   if (index != -1) {
//                     _selectedItems[index] = _controller.text;
//                     widget.onChanged(_selectedItems);
//                   }
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _showMultiSelectDialog,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: 'Select Items',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//         child: Wrap(
//           spacing: 8.0,
//           runSpacing: 4.0,
//           children: _selectedItems.map((item) {
//             return Chip(
//               label: GestureDetector(
//                 onTap: () => _showValueEditDialog(item),
//                 child: Text(item),
//               ),
//               onDeleted: () {
//                 setState(() {
//                   _selectedItems.remove(item);
//                 });
//                 widget.onChanged(_selectedItems);
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
