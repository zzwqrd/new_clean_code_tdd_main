import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// النموذج لتمثيل العنصر في الدروب داون
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

// حالات الـ Cubit
abstract class DropdownState {}

class DropdownLoading extends DropdownState {}

class DropdownLoaded extends DropdownState {
  final List<DropdownItem> items;
  final DropdownItem? selectedItem; // العنصر المختار

  DropdownLoaded(this.items, {this.selectedItem});
}

// الكيوبت لإدارة حالة جلب البيانات
class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownLoading());

  final dataSelected = DropdownItem(id: 5, title: "ججج");

  // الدالة لجلب البيانات
  Future<void> fetchData() async {
    emit(DropdownLoading()); // إصدار حالة التحميل
    await Future.delayed(Duration(seconds: 2)); // محاكاة وقت التحميل

    final fetchedItems = [
      DropdownItem(
        id: 1,
        title: "أمريكا الشمالية",
        children: [
          DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
          DropdownItem(id: 3, title: "كوبا"),
        ],
      ),
      DropdownItem(
        id: 4,
        title: "المكسيك",
        children: [
          DropdownItem(id: 5, title: "ججج"),
          DropdownItem(id: 6, title: "ررر"),
        ],
      ),
      DropdownItem(id: 7, title: "آسيا"),
      DropdownItem(id: 8, title: "أوروبا"),
      DropdownItem(
        id: 9,
        title: "زين",
        children: [
          DropdownItem(id: 10, title: "١١"),
          DropdownItem(id: 11, title: "٢٢٢"),
          DropdownItem(id: 12, title: "٣٣٣"),
          DropdownItem(id: 13, title: "٤٤٤٤"),
        ],
      ),
      DropdownItem(id: 14, title: "أمريكا الجنوبية"),
    ];
    // البحث عن العنصر المحدد مع التعامل مع حالة الأب
    DropdownItem? selectedItem;
    for (var item in fetchedItems) {
      if (item.id == dataSelected.id) {
        selectedItem = item;
        break;
      } else if (item.children != null) {
        selectedItem = item.children!.firstWhere(
            (child) => child.id == dataSelected.id,
            orElse: () => item);
        if (selectedItem.id == dataSelected.id) {
          break;
        }
      }
    }

    if (selectedItem != null) {
      selectedItem.isSelected = true;
    }

    emit(DropdownLoaded(fetchedItems, selectedItem: selectedItem));
    // // البحث عن العنصر في القائمة وتعيينه كقيمة مختارة
    // DropdownItem? selectedItem;
    // selectedItem =
    //     fetchedItems.expand((item) => item.children ?? [item]).firstWhere(
    //           (item) =>
    //               item.id ==
    //               dataSelected.id, // البحث عن العنصر المطابق لـ dataSelected
    //           orElse: () => fetchedItems.first,
    //         );
    //
    // selectedItem.isSelected = true; // تعيينه كقيمة مختارة
    //
    // emit(DropdownLoaded(fetchedItems,
    //     selectedItem: selectedItem)); // إصدار حالة البيانات التي تم جلبها
  }
}

class DropdownScreen extends StatefulWidget {
  @override
  _DropdownScreenState createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => DropdownCubit()..fetchData(),
          child: BlocBuilder<DropdownCubit, DropdownState>(
            builder: (context, state) {
              if (state is DropdownLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DropdownLoaded) {
                return CustomDropdown(
                  items: state.items,
                  hintText: "اختر منتجًا",
                  isLoading: false,
                  selectedValue: state.selectedItem,
                  onChanged: (selectedItem) {
                    context.read<DropdownCubit>().emit(DropdownLoaded(
                        state.items,
                        selectedItem: selectedItem));
                  },
                );
              } else {
                return Center(child: Text("خطأ في تحميل البيانات"));
              }
            },
          ),
        ),
      ),
    );
  }
}

// CustomDropdown المعدل الذي يعرض اللودينج عند الحاجة
class CustomDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final ValueChanged<DropdownItem?>? onChanged;
  final bool isEnabled;
  final bool isLoading;
  final DropdownItem? selectedValue;
  final String hintText;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.onChanged,
    this.isEnabled = true,
    this.isLoading = false,
    this.selectedValue,
    this.hintText = "اختر عنصر",
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            elevation: 2.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildDropdownList(widget.items),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.isEnabled && !widget.isLoading
                ? () {
                    setState(() {
                      if (isDropdownOpen) {
                        _closeDropdown();
                      } else {
                        _openDropdown();
                      }
                    });
                  }
                : null,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.selectedValue?.title ?? widget.hintText),
                  ),
                  if (widget.selectedValue != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.onChanged != null) {
                            widget.onChanged!(null);
                          }
                        });
                      },
                      child: const Icon(Icons.clear, color: Colors.redAccent),
                    ),
                  const SizedBox(width: 8), // مسافة بين النص والأيقونة
                  Icon(
                    isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.isLoading) // إظهار اللودينج فوق الدروب داون
          Positioned.fill(
            child: Container(
              color: Colors.black38, // خلفية شفافة
              child: const Center(
                child: CircularProgressIndicator(), // مؤشر التحميل
              ),
            ),
          ),
      ],
    );
  }

  void _openDropdown() {
    setState(() {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    setState(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
      isDropdownOpen = false;
    });
  }

  Widget _buildDropdownList(List<DropdownItem> items) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: items.map((item) => _buildDropdownItem(item)).toList(),
    );
  }

  Widget _buildDropdownItem(DropdownItem item) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
              if (item.children != null && item.children!.isNotEmpty)
                GestureDetector(
                  onTap: widget.isEnabled
                      ? () {
                          setState(() {
                            _toggleExpandState(item);
                          });
                        }
                      : null,
                  child: Icon(
                    item.isExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ),
            ],
          ),
          onTap: widget.isEnabled
              ? () {
                  setState(() {
                    _selectItem(item);
                    _closeParent(item);
                    _closeDropdown(); // إغلاق الدروب داون بعد اختيار العنصر الأب
                  });

                  if (widget.onChanged != null) {
                    widget.onChanged!(item);
                    _closeDropdown();
                    setState(() {});
                  }
                }
              : null,
        ),
        if (item.isExpanded && item.children != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: item.children!.map((child) {
                return ListTile(
                  title: Text(child.title),
                  onTap: widget.isEnabled
                      ? () {
                          setState(() {
                            // اختيار أحد الأبناء وإغلاق الدروب داون
                            _selectItem(child);
                            _closeDropdown(); // إغلاق الدروب داون بعد اختيار العنصر الابن
                            _closeParent(item); // إغلاق الأب بعد اختيار الابن
                            setState(() {});
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(child);
                            _closeDropdown();
                            setState(() {});
                          }
                        }
                      : null,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _selectItem(DropdownItem item) {
    if (widget.onChanged != null) {
      widget.onChanged!(item);
    }
  }

  void _toggleExpandState(DropdownItem item) {
    setState(() {
      for (var i in widget.items) {
        if (i != item && i.isExpanded) {
          i.isExpanded = false;
        }
      }
      item.isExpanded = !item.isExpanded;
    });
    _refreshOverlay();
  }

  void _refreshOverlay() {
    setState(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _openDropdown();
    });
  }

  void _closeAllParents() {
    for (var item in widget.items) {
      item.isExpanded = false;
    }
    _refreshOverlay();
  }

  void _closeParent(DropdownItem parent) {
    parent.isExpanded = false;
    _refreshOverlay();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
