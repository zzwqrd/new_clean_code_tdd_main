// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: FilterForm(),
//     );
//   }
// }
//
// class FilterForm extends StatefulWidget {
//   @override
//   _FilterFormState createState() => _FilterFormState();
// }
//
// class _FilterFormState extends State<FilterForm> {
//   final TextEditingController fromDateController = TextEditingController();
//   final TextEditingController toDateController = TextEditingController();
//   final TextEditingController categoryIdController = TextEditingController();
//   final TextEditingController targetIdController = TextEditingController();
//
//   AdvancedFilterManager filterManager = AdvancedFilterManager();
//
//   void sendRequest() async {
//     String jsonData = filterManager.toJson();
//
//     print('Sending data: $jsonData');
//
//     // final response = await http.post(
//     //   Uri.parse('YOUR_API_ENDPOINT'),
//     //   headers: {
//     //     'Content-Type': 'application/json',
//     //   },
//     //   body: jsonData,
//     // );
//
//     // if (response.statusCode == 200) {
//     //   print('Success: ${response.body}');
//     // } else {
//     //   print('Error: ${response.statusCode}');
//     // }
//   }
//
//   void handleSubmit() {
//     filterManager.clearFilters();
//     if (fromDateController.text.isNotEmpty) {
//       filterManager.addFilter("fromDateTimeString", fromDateController.text);
//     }
//
//     if (toDateController.text.isNotEmpty) {
//       filterManager.addFilter("toDateTimeString", toDateController.text);
//     }
//     if (categoryIdController.text.isNotEmpty) {
//       filterManager.addFilter("categoryId", categoryIdController.text);
//     }
//     if (targetIdController.text.isNotEmpty) {
//       filterManager.addFilter("targetId", targetIdController.text);
//     }
//
//     sendRequest();
//   }
//
//   void handleRefresh() async {
//     // تفريغ الفلاتر
//     filterManager.clearFilters();
//     String jsonData = filterManager.toJson();
//
//     print('Sending data: $jsonData');
//
//     // إرسال طلب POST لجلب كل البيانات بدون فلترة
//     // final response = await http.post(
//     //   Uri.parse('YOUR_API_ENDPOINT'),
//     //   headers: {
//     //     'Content-Type': 'application/json',
//     //   },
//     //   body: json.encode({"advancedFilter": []}), // إرسال طلب بدون فلاتر
//     // );
//
//     // if (response.statusCode == 200) {
//     //   List<dynamic> responseData = json.decode(response.body)['data'];
//     //   setState(() {
//     //     filterManager.updateFilteredData(responseData);
//     //   });
//     // } else {
//     //   print('Error: ${response.statusCode}');
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Form'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: fromDateController,
//               decoration: InputDecoration(
//                 labelText: 'From Date (ISO 8601 format)',
//               ),
//             ),
//             TextField(
//               controller: toDateController,
//               decoration: InputDecoration(
//                 labelText: 'To Date (ISO 8601 format)',
//               ),
//             ),
//             TextField(
//               controller: categoryIdController,
//               decoration: InputDecoration(
//                 labelText: 'Category ID',
//               ),
//             ),
//             TextField(
//               controller: targetIdController,
//               decoration: InputDecoration(
//                 labelText: 'Target ID',
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filterManager.filteredDataList.length,
//                 itemBuilder: (context, index) {
//                   final data = filterManager.filteredDataList[index];
//                   return ListTile(
//                     title: Text(data.name),
//                     subtitle: Text(data.id),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: handleSubmit,
//                   child: Text('Send Data'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: handleRefresh,
//                   child: Text('Refresh'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AdvancedFilterManager {
//   List<Map<String, dynamic>> advancedFilter = [];
//   List<FilteredData> filteredDataList = [];
//
//   void addFilter(String parameterName, String parameterValue) {
//     advancedFilter.add({
//       "parameterzName": parameterName,
//       "parameterzValue": parameterValue,
//       "condition": 0, // تعيين القيمة الأولية لـ condition
//       "operation": 0,
//     });
//
//     // تحديث قيمة condition بعد إضافة الفلتر
//     for (int i = 0; i < advancedFilter.length; i++) {
//       advancedFilter[i]["condition"] = i == 0 ? 0 : 1;
//     }
//   }
//
//   dynamic toJson() {
//     Map<String, dynamic> data = {
//       "advancedFilter": advancedFilter,
//     };
//     return json.encode(data);
//   }
//
//   void clearFilters() {
//     advancedFilter.clear();
//   }
//
//   void updateFilteredData(List<dynamic> data) {
//     filteredDataList = data.map((item) => FilteredData.fromJson(item)).toList();
//   }
// }
//
// class FilteredData {
//   final String id;
//   final String name;
//   // أضف هنا الحقول الأخرى التي تحتاجها
//
//   FilteredData({required this.id, required this.name});
//
//   factory FilteredData.fromJson(Map<String, dynamic> json) {
//     return FilteredData(
//       id: json['id'],
//       name: json['name'],
//       // أضف هنا الحقول الأخرى
//     );
//   }
// }

//
// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:multi_dropdown/multiselect_dropdown.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: FilterForm(),
//     );
//   }
// }
//
// class FilterForm extends StatefulWidget {
//   @override
//   _FilterFormState createState() => _FilterFormState();
// }
//
// class _FilterFormState extends State<FilterForm> {
//   final TextEditingController fromDateController = TextEditingController();
//   final TextEditingController toDateController = TextEditingController();
//   final TextEditingController categoryIdController = TextEditingController();
//   final TextEditingController targetIdController = TextEditingController();
//
//   AdvancedFilterManager filterManager = AdvancedFilterManager();
//
//   void sendRequest() async {
//     String jsonData = filterManager.toJson();
//
//     print('Sending data: $jsonData');
//
//     // final response = await http.post(
//     //   Uri.parse('YOUR_API_ENDPOINT'),
//     //   headers: {
//     //     'Content-Type': 'application/json',
//     //   },
//     //   body: jsonData,
//     // );
//
//     // if (response.statusCode == 200) {
//     //   print('Success: ${response.body}');
//     // } else {
//     //   print('Error: ${response.statusCode}');
//     // }
//   }
//
//   void handleSubmit() {
//     filterManager.clearFilters();
//     if (fromDateController.text.isNotEmpty) {
//       filterManager.addFilter("fromDateTimeString", fromDateController.text);
//     }
//
//     if (toDateController.text.isNotEmpty) {
//       filterManager.addFilter("toDateTimeString", toDateController.text);
//     }
//     if (categoryIdController.text.isNotEmpty) {
//       filterManager.addFilter("categoryId", categoryIdController.text);
//     }
//     if (targetIdController.text.isNotEmpty) {
//       filterManager.addFilter("targetId", targetIdController.text);
//     }
//
//     sendRequest();
//   }
//
//   void handleRefresh() async {
//     // تفريغ الفلاتر
//     filterManager.clearFilters();
//     String jsonData = filterManager.toJson();
//
//     print('Sending data: $jsonData');
//
//     // إرسال طلب POST لجلب كل البيانات بدون فلترة
//     // final response = await http.post(
//     //   Uri.parse('YOUR_API_ENDPOINT'),
//     //   headers: {
//     //     'Content-Type': 'application/json',
//     //   },
//     //   body: json.encode({"advancedFilter": []}), // إرسال طلب بدون فلاتر
//     // );
//
//     // if (response.statusCode == 200) {
//     //   List<dynamic> responseData = json.decode(response.body)['data'];
//     //   setState(() {
//     //     filterManager.updateFilteredData(responseData);
//     //   });
//     // } else {
//     //   print('Error: ${response.statusCode}');
//     // }
//   }
//
//   final List<Place> places = [
//     Place(id: 1, title: 'Option 1'),
//     Place(id: 2, title: 'Option 2'),
//     Place(id: 3, title: 'Option 3'),
//     Place(id: 4, title: 'Option 4'),
//     Place(id: 5, title: 'Option 5'),
//     Place(id: 6, title: 'Option 6'),
//   ];

// void handleSelectionChanged(List<ValueItem> selectedOptions) async {
//   List<Place> selectedPlaces = selectedOptions.map((item) {
//     return places.firstWhere((place) => place.id == item.value);
//   }).toList();
//   int checkId = 1; // يمكن تغيير هذا إلى القيمة التي تريد التحقق منها
//   bool containsElement = selectedOptions.any((item) => item.value == checkId);
//
//   if (containsElement) {
//     print('The selected options add contain the element with id $checkId');
//   } else {
//     print(
//         'The selected options delete do not contain the element with id $checkId');
//   }
//   print('The selected  $selectedPlaces');
//   // await apiService.sendPlaces(selectedPlaces);
// }
//   final List<Product> products = [
//     Product(productId: 1, buyQuantity: 1, productPrice: 1000, isVoucher: 0),
//     Product(productId: 2, buyQuantity: 2, productPrice: 2000, isVoucher: 0),
//   ];
//
//   final ApiService apiService = ApiService();
//   Set<Product> selectedProducts = {};
//
//   void handleSelectionChanged(List<ValueItem<int>> selectedOptions) async {
//     Set<int?> selectedIds = selectedOptions.map((item) => item.value).toSet();
//
//     // تحديث قائمة المنتجات المختارة بناءً على العناصر المحددة
//     selectedProducts = products
//         .where((product) => selectedIds.contains(product.productId))
//         .toSet();
//
//     // إرسال البيانات إلى الـ backend
//     await apiService.sendProducts(selectedProducts.toList());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Form'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: fromDateController,
//               decoration: InputDecoration(
//                 labelText: 'From Date (ISO 8601 format)',
//               ),
//             ),
//             TextField(
//               controller: toDateController,
//               decoration: InputDecoration(
//                 labelText: 'To Date (ISO 8601 format)',
//               ),
//             ),
//             TextField(
//               controller: categoryIdController,
//               decoration: InputDecoration(
//                 labelText: 'Category ID',
//               ),
//             ),
//             TextField(
//               controller: targetIdController,
//               decoration: InputDecoration(
//                 labelText: 'Target ID',
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: MultiSelectDropDown<int>(
//                 onOptionSelected: handleSelectionChanged,
//                 options: products
//                     .map((product) => ValueItem(
//                     label: 'Product ${product.productId}',
//                     value: product.productId))
//                     .toList(),
//                 selectionType: SelectionType.multi,
//                 chipConfig: const ChipConfig(wrapType: WrapType.scroll),
//                 dropdownHeight: 300,
//                 optionTextStyle: const TextStyle(fontSize: 16),
//                 selectedOptionIcon: const Icon(Icons.check_circle),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filterManager.filteredDataList.length,
//                 itemBuilder: (context, index) {
//                   final data = filterManager.filteredDataList[index];
//                   return ListTile(
//                     title: Text(data.name),
//                     subtitle: Text(data.id),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: handleSubmit,
//                   child: Text('Send Data'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: handleRefresh,
//                   child: Text('Refresh'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await apiService.sendProducts(selectedProducts.toList());
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AdvancedFilterManager {
//   List<Map<String, dynamic>> advancedFilter = [];
//   List<FilteredData> filteredDataList = [];
//
//   void addFilter(String parameterName, String parameterValue) {
//     advancedFilter.add({
//       "parameterzName": parameterName,
//       "parameterzValue": parameterValue,
//       "condition": 0, // تعيين القيمة الأولية لـ condition
//       "operation": 0,
//     });
//
//     // تحديث قيمة condition بعد إضافة الفلتر
//     for (int i = 0; i < advancedFilter.length; i++) {
//       advancedFilter[i]["condition"] = i == 0 ? 0 : 1;
//     }
//   }
//
//   dynamic toJson() {
//     Map<String, dynamic> data = {
//       "advancedFilter": advancedFilter,
//     };
//     return json.encode(data);
//   }
//
//   void clearFilters() {
//     advancedFilter.clear();
//   }
//
//   void updateFilteredData(List<dynamic> data) {
//     filteredDataList = data.map((item) => FilteredData.fromJson(item)).toList();
//   }
// }
//
// class FilteredData {
//   final String id;
//   final String name;
//   // أضف هنا الحقول الأخرى التي تحتاجها
//
//   FilteredData({required this.id, required this.name});
//
//   factory FilteredData.fromJson(Map<String, dynamic> json) {
//     return FilteredData(
//       id: json['id'],
//       name: json['name'],
//       // أضف هنا الحقول الأخرى
//     );
//   }
// }
//
// class Place {
//   final int id;
//   final String title;
//
//   Place({
//     required this.id,
//     required this.title,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//     };
//   }
// }
//
// class Product {
//   final int productId;
//   final int buyQuantity;
//   final int productPrice;
//   final int isVoucher;
//
//   Product({
//     required this.productId,
//     required this.buyQuantity,
//     required this.productPrice,
//     required this.isVoucher,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'product_id': productId,
//       'buy_quantity': buyQuantity,
//       'product_price': productPrice,
//       'is_voucher': isVoucher,
//     };
//   }
// }
//
// class ApiService {
//   final Dio _dio = Dio();
//
//   Future<void> sendProducts(List<Product> products) async {
//     final ddd = products.map((product) => product.toJson()).toList();
//     final data = jsonEncode(ddd);
//     print(">>>>>>>>>>> $data");
//     // try {
//     //   final response = await _dio.post(
//     //     'YOUR_BACKEND_URL', // ضع هنا رابط الـ backend الخاص بك
//     //     data: {
//     //       'products': products.map((product) => product.toJson()).toList(),
//     //     },
//     //   );
//     //
//     //   if (response.statusCode == 200) {
//     //     print('Data sent successfully');
//     //   } else {
//     //     print('Failed to send data');
//     //   }
//     // } catch (e) {
//     //   print('Error: $e');
//     // }
//   }
// }
