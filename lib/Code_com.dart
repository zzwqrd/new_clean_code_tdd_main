import 'package:flutter/material.dart';

class CodeCom extends StatefulWidget {
  const CodeCom({super.key});

  @override
  State<CodeCom> createState() => _CodeComState();
}

class _CodeComState extends State<CodeCom> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountry = "EG"; // الدولة الافتراضية هي مصر

  final List<String> countryCodes = [
    "EG",
    "US",
    "GB",
    "FR",
    "DE",
    "IN",
    "SA",
    "AE",
    "CN",
    "JP"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Dropdown for selecting country
                DropdownButton<String>(
                  value: selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountry = newValue!;
                    });
                  },
                  items: countryCodes
                      .map<DropdownMenuItem<String>>((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Row(
                        children: [
                          Text(
                            country.toFlag, // عرض العلم
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 10),
                          Text(country.toDialCode), // عرض كود الاتصال
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),

                // TextField for phone number
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "رقم الهاتف",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String fullPhoneNumber =
                    "${selectedCountry.toDialCode} ${phoneController.text}";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم إدخال الرقم: $fullPhoneNumber")),
                );
              },
              child: Text("إرسال"),
            ),
          ],
        ),
      ),
    );
  }
}

extension ConvertCountryInfo on String {
  /// تحويل كود الدولة إلى علم
  String get toFlag {
    return toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  /// استخراج كود الدولة من رمز العلم
  String get extractCountryCode {
    if (length == 4) {
      return String.fromCharCode(codeUnitAt(0) - 127397) +
          String.fromCharCode(codeUnitAt(2) - 127397);
    } else {
      return "🚫 غير صالح";
    }
  }

  /// استخراج كود الاتصال الدولي
  String get toDialCode {
    String countryCode = length == 4 ? extractCountryCode : toUpperCase();

    switch (countryCode) {
      case "EG":
        return "+20";
      case "US":
        return "+1";
      case "GB":
        return "+44";
      case "FR":
        return "+33";
      case "DE":
        return "+49";
      case "IN":
        return "+91";
      case "SA":
        return "+966";
      case "AE":
        return "+971";
      case "CN":
        return "+86";
      case "JP":
        return "+81";
      default:
        return "❌ غير متوفر";
    }
  }

  /// استخراج العلم وكود الاتصال تلقائيًا
  String get countryFlagAndDialCode {
    if (length != 2 && length != 4) return "🚫 غير صالح";
    String countryCode = length == 4 ? extractCountryCode : toUpperCase();
    return "${countryCode.toFlag} ${countryCode.toDialCode}";
  }
}

// extension CountryDetails on String {
//   /// استنتاج رمز الدولة تلقائيًا من العلم 🇪🇬 → EG
//   String get extractCountryCode {
//     if (length == 4) {
//       return String.fromCharCode(codeUnitAt(0) - 127397) +
//           String.fromCharCode(codeUnitAt(2) - 127397);
//     } else {
//       return "🚫 غير صالح";
//     }
//   }
//
//   /// استنتاج التفاصيل بناءً على الإدخال (رمز علم أو كود دولة)
//   String get countryDetails {
//     if (length == 2 && RegExp(r'^[A-Za-z]{2}$').hasMatch(this)) {
//       return "$toFlag ($this)";
//     } else if (length == 4) {
//       return "$this (${extractCountryCode})";
//     } else {
//       return "🚫 غير صالح";
//     }
//   }
//
//   /// تحويل كود الدولة إلى علم
//   String get toFlag {
//     return toUpperCase().replaceAllMapped(
//       RegExp(r'[A-Z]'),
//       (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
//     );
//   }
// }

//
// extension CountryCodeExtractor on String {
//   /// استخراج كود الدولة (ISO 3166-1 alpha-2) تلقائيًا من رمز العلم 🇪🇬 → EG
//   String get extractCountryCode {
//     if (length == 4) {
//       // تحليل رمز العلم إلى كود الدولة
//       return String.fromCharCode(codeUnitAt(0) - 127397) +
//           String.fromCharCode(codeUnitAt(2) - 127397);
//     } else {
//       return "🚫 غير صالح";
//     }
//   }
// }
// extension ConvertCountry on String {
//   /// إرجاع علم الدولة مع كود الاتصال بناءً على كود الدولة (ISO 3166-1 alpha-2)
//   String get toFlagWithDialCode {
//     if (length != 2 || !RegExp(r'^[A-Za-z]{2}$').hasMatch(this)) {
//       return "🚫 غير صالح";
//     }
//
//     // تحويل كود الدولة إلى علم
//     String flag = toUpperCase().replaceAllMapped(
//       RegExp(r'[A-Z]'),
//       (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
//     );
//
//     // استخراج كود الاتصال بناءً على أول حرف
//     String dialCode;
//     switch (toUpperCase()) {
//       case "EG":
//         dialCode = "+20";
//         break;
//       case "US":
//         dialCode = "+1";
//         break;
//       case "GB":
//         dialCode = "+44";
//         break;
//       case "FR":
//         dialCode = "+33";
//         break;
//       case "DE":
//         dialCode = "+49";
//         break;
//       case "IN":
//         dialCode = "+91";
//         break;
//       case "SA":
//         dialCode = "+966";
//         break;
//       case "AE":
//         dialCode = "+971";
//         break;
//       case "CN":
//         dialCode = "+86";
//         break;
//       case "JP":
//         dialCode = "+81";
//         break;
//       default:
//         dialCode = "❌ غير متوفر";
//     }
//
//     return "$flag $dialCode";
//   }
// }

// extension ConvertFlag on String {
//   String get toFlag {
//     if (length == 2 && RegExp(r'^[A-Za-z]{2}$').hasMatch(this)) {
//       return toUpperCase().replaceAllMapped(
//         RegExp(r'[A-Z]'),
//         (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
//       );
//     } else if (length == 4) {
//       return String.fromCharCode(codeUnitAt(0) - 127397) +
//           String.fromCharCode(codeUnitAt(2) - 127397);
//     } else {
//       return "🚫 غير صالح";
//     }
//   }
// }
// extension convertFlag on String {
//   String get toFlag {
//     return (this).toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
//         (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
//   }
// }
