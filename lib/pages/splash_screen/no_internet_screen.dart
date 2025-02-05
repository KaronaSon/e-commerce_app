// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

// class NoInternetScreen extends StatefulWidget {
//   const NoInternetScreen({super.key});

//   @override
//   State<NoInternetScreen> createState() => _NoInternetScreenState();
// }

// class _NoInternetScreenState extends State<NoInternetScreen> {
//   Future<void> checkConnectivity() async {
//     final result = await Connectivity().checkConnectivity();
//     if (result != ConnectivityResult.none) {
//       Navigator.pop(context);
//     } else {
//       IconSnackBar.show(
//         context,
//         snackBarType: SnackBarType.fail,
//         label: "Still no internet connection",
//         labelTextStyle: const TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Image.asset(
//                 "assets/icons/no_internet.jpg",
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: checkConnectivity,
//               child: const Text(
//                 'Retry',
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
