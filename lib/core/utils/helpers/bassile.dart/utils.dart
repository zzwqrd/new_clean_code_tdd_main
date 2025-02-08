// part of 'UtilsImports.dart';

// class Utils {
//   static Future<void> manipulateSplashData(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     initDio(lang: "ar", context: context);
//     initCustomWidgets(language: "ar");
//     GlobalState.instance.set("token", "");
//     var strUser = prefs.get("user");
//     if (strUser != null) {
//       var cats = await CustomerRepository(context).getActivity(true);
//       context.read<CatsCubit>().onUpdateData(cats);
//       print("catsCubit is ${context.read<CatsCubit>().state.cats.length}");
//       UserModel data = UserModel.fromJson(json.decode("$strUser"));

//       GlobalState.instance.set("token", data.token);
//       changeLanguage(data.lang ?? "ar", context);
//       setCurrentUserData(data, context);
//     } else {
//       context.read<AuthCubit>().onUpdateAuth(false);
//       changeLanguage("ar", context);
//       AutoRouter.of(context).push(SelectLangRoute());
//     }
//   }

//   static updatePackage(BuildContext context, dynamic data) async {
//     UserModel user = UserModel();
//     user.lang = context.read<LangCubit>().state.locale.languageCode;
//     user.token = data["token"];
//     int type = data["typeUser"];
//     user.typeUser = type;
//     user.providerLoginModel = ProviderLoginModel.fromJson(data);
//     GlobalState.instance.set("token", user.token);
//     setCurrentUserData(user, context);
//     await saveUserData(user);
//     AutoRouter.of(context).push(ProHomeRoute(index: 1));
//   }

//   static updateProviserData(BuildContext context, dynamic data) async {
//     UserModel user = UserModel();
//     user.lang = context.read<LangCubit>().state.locale.languageCode;
//     user.token = context.read<UserCubit>().state.model.token;
//     user.typeUser = context.read<UserCubit>().state.model.typeUser;
//     GlobalState.instance.set("token", user.token);
//     user.providerLoginModel = ProviderLoginModel.fromJson(data);
//     context.read<UserCubit>().onUpdateUserData(user);
//     await saveUserData(user);
//     return true;
//   }

//   static initDio({required String lang, required BuildContext context}) {
//     DioUtils.init(
//       baseUrl: ApiNames.baseUrl,
//       style: CustomInputTextStyle(lang: lang),
//       primary: MyColors.primary,
//       authLink: LoginRoute.name,
//       language: lang,
//       dismissFunc: EasyLoading.dismiss,
//       showLoadingFunc: LoadingDialog.showLoadingDialog,
//       branch: ApiNames.branch,
//       authClick: () => AutoRouter.of(context).push(LoginRoute()),
//     );
//   }

//   static initCustomWidgets({required String language}) {
//     WidgetUtils.init(
//         style: CustomInputTextStyle(lang: language),
//         primary: MyColors.primary,
//         language: language,
//         inputStyle: ({
//           String? label,
//           String? hint,
//           Widget? prefixIcon,
//           Widget? suffixIcon,
//           Widget? suffixWidget,
//           Widget? prefixWidget,
//           Color? hintColor,
//           Color? fillColor,
//           BorderRadius? radius,
//           Color? focusBorderColor,
//           EdgeInsets? padding,
//           Color? enableColor,
//           double? hintSize,
//         }) =>
//             CustomInputDecoration(
//                 lang: language,
//                 labelTxt: label,
//                 hint: hint,
//                 prefixIcon: prefixIcon,
//                 suffixIcon: suffixIcon,
//                 enableColor: enableColor,
//                 customFillColor: fillColor,
//                 padding: padding));
//   }

//   static Future<bool> manipulateLoginData(
//       BuildContext context, dynamic data, String token) async {
//     if (data != null) {
//       await Utils.setDeviceId("$token");
//       UserModel user = UserModel();
//       user.lang = context.read<LangCubit>().state.locale.languageCode;
//       user.token = data["token"];
//       int type = data["typeUser"];
//       user.typeUser = type;
//       type == 1
//           ? user.customerLoginModel = CustomerLoginModel.fromJson(data)
//           : user.providerLoginModel = ProviderLoginModel.fromJson(data);
//       GlobalState.instance.set("token", user.token);
//       await Utils.saveUserData(user);
//       // CustomToast.showSimpleToast(msg: tr(context, "loginSucceed"));
//       Utils.setCurrentUserData(user, context);
//       return true;
//     }
//     return false;
//   }

//   static void setCurrentUserData(UserModel model, BuildContext context) async {
//     context.read<UserCubit>().onUpdateUserData(model);
//     context.read<AuthCubit>().onUpdateAuth(true);
//     var cats = await CustomerRepository(context).getActivity(true);
//     context.read<CatsCubit>().onUpdateData(cats);
//     if (model.typeUser == 1) {
//       AutoRouter.of(context)
//           .pushAndPopUntil(CusHomeRoute(index: 0), predicate: (value) => true);
//     } else {
//       if (model.providerLoginModel!.alreadyHasPackage) {
//         AutoRouter.of(context).pushAndPopUntil(ProHomeRoute(index: 0),
//             predicate: (value) => true);
//       } else {
//         AutoRouter.of(context).pushAndPopUntil(
//             SubPackagesRoute(
//                 providerId: model.providerLoginModel?.id ?? "", logOut: true),
//             predicate: (value) => true);
//       }
//     }
//   }

//   static Future<void> saveUserData(UserModel model) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("user", json.encode(model.toJson()));
//   }

//   static void changeLanguage(String lang, BuildContext context) {
//     DioUtils.lang = lang;
//     WidgetUtils.lang = lang;
//     context.read<LangCubit>().onUpdateLanguage(lang);
//   }

//   static UserModel getSavedUser({required BuildContext context}) {
//     return context.read<UserCubit>().state.model;
//   }

//   static Future<String?> getDeviceId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString("deviceId");
//   }

//   static void shareFile(String path) {
//     LoadingDialog.showLoadingDialog();
//     final uri = Uri.file(path);
//     Share.shareFiles([uri.path]).whenComplete(() {
//       EasyLoading.dismiss();
//     });
//   }

//   static Future<void> setDeviceId(String token) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("deviceId", token);
//   }

//   static void clearSavedData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }

//   // static String getCurrentUserId({required BuildContext context}) {
//   //   var provider = context.watch<UserCubit>().state.model;
//   //   return provider.customerLoginModel!.id;
//   // }

//   static void launchURL({required String url}) async {
//     if (!url.toString().startsWith("https")) {
//       url = "https://" + url;
//     }
//     // if (await canLaunch(url)) {
//     await launch(url);
//     // } else {
//     //   CustomToast.showToastNotification("من فضلك تآكد من الرابط");
//     // }
//   }

//   static void launchWhatsApp(phone) async {
//     String message = 'مرحبا بك';
//     if (phone.startsWith("00966")) {
//       phone = phone.substring(5);
//     }
//     var _whatsAppUrl = "whatsapp://send?phone=+966$phone&text=$message";
//     print(_whatsAppUrl);
//     // if (await canLaunch(_whatsAppUrl)) {
//     await launch(_whatsAppUrl);
//     // } else {
//     //   throw 'حدث خطأ ما';
//     // }
//   }

//   static void launchYoutube({required String url}) async {
//     if (Platform.isIOS) {
//       if (await canLaunch('$url')) {
//         await launch('$url', forceSafariVC: false);
//       } else {
//         if (await canLaunch('$url')) {
//           await launch('$url');
//         } else {
//           throw 'Could not launch $url';
//         }
//       }
//     } else {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     }
//   }

//   static void callPhone({phone}) async {
//     await launch("tel:$phone");
//   }

//   static void sendMail(mail) async {
//     await launch("mailto:$mail");
//   }

//   static void shareApp(url) {
//     LoadingDialog.showLoadingDialog();
//     Share.share(url).whenComplete(() {
//       EasyLoading.dismiss();
//     });
//   }

//   static Future<File?> getImage() async {
//     final ImagePicker _picker = ImagePicker();
//     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       File imageFile = File(image.path);
//       return imageFile;
//     }
//     return null;
//   }

//   static Future<File?> getImageByCamera() async {
//     final ImagePicker _picker = ImagePicker();
//     XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       File imageFile = File(image.path);
//       return imageFile;
//     }
//     return null;
//   }

//   static Future<List<File>> getImages() async {
//     final ImagePicker _picker = ImagePicker();
//     final List<XFile>? result = await _picker.pickMultiImage(imageQuality: 20);
//     if (result != null) {
//       List<File> files = result.map((e) => File(e.path)).toList();
//       return files;
//     } else {
//       return [];
//     }
//   }

//   static Future<List<File>> getPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null) {
//       List<File> files = result.paths.map((path) => File("$path")).toList();
//       return files;
//     } else {
//       return [];
//     }
//   }

//   static Future<File?> getVideo() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       File imageFile = File(video.path);
//       return imageFile;
//     }
//     return null;
//   }

//   static void copToClipboard(
//       {required String text, required GlobalKey<ScaffoldState> scaffold}) {
//     if (text.trim().isEmpty) {
//       CustomToast.showToastNotification("لا يوجد بيانات للنسخ");
//       return;
//     } else {
//       Clipboard.setData(ClipboardData(text: "$text")).then((value) {
//         CustomToast.showToastNotification("تم النسخ بنجاح");
//       });
//     }
//   }

//   static Future<Position?> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.requestPermission();
//       CustomToast.showToastNotification('Location services are Enabled',
//           color: MyColors.black);
//       return null;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         CustomToast.showSimpleToast(msg: 'Location permissions are denied');
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       CustomToast.showSimpleToast(
//           msg:
//               'Location permissions are permanently denied, we cannot request permissions');
//       return null;
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   static void navigateToMapWithDirection(
//       {required String lat,
//       required String lng,
//       required BuildContext context}) async {
//     if (lat == "0") return;
//     try {
//       final coords = Coords(double.parse(lat), double.parse(lng));
//       final title = "Destination";
//       final availableMaps = await MapLauncher.installedMaps;

//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Container(
//                 child: Wrap(
//                   children: <Widget>[
//                     for (var map in availableMaps)
//                       ListTile(
//                         onTap: () => map.showMarker(
//                           coords: coords,
//                           title: title,
//                         ),
//                         title: Text(map.mapName),
//                         leading: SvgPicture.asset(
//                           map.icon,
//                           height: 30.0,
//                           width: 30.0,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       CustomToast.showSimpleToast(msg: "$e");
//     }
//   }

//   static Future<String> getAddress(LatLng latLng, BuildContext context) async {
//     // GeoCoding geoCode = GeoCode();

//     try {
//       List<geocoding.Placemark> address = await geocoding
//           .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//       var data =
//           "${address[0].country ?? ""}  ${address[0].locality ?? ""}  ${address[0].subLocality ?? ""}  ${address[0].street ?? ""}";
//       print(data);
//       return data;
//     } catch (e) {
//       print("element is $e");
//       return "";
//     }
//   }

//   static String convertDigitsToLatin(String s) {
//     var sb = new StringBuffer();
//     for (int i = 0; i < s.length; i++) {
//       switch (s[i]) {
//         //Arabic digits
//         case '\u0660':
//           sb.write('0');
//           break;
//         case '\u0661':
//           sb.write('1');
//           break;
//         case '\u0662':
//           sb.write('2');
//           break;
//         case '\u0663':
//           sb.write('3');
//           break;
//         case '\u0664':
//           sb.write('4');
//           break;
//         case '\u0665':
//           sb.write('5');
//           break;
//         case '\u0666':
//           sb.write('6');
//           break;
//         case '\u0667':
//           sb.write('7');
//           break;
//         case '\u0668':
//           sb.write('8');
//           break;
//         case '\u0669':
//           sb.write('9');
//           break;
//         default:
//           sb.write(s[i]);
//           break;
//       }
//     }
//     return sb.toString();
//   }
// }
