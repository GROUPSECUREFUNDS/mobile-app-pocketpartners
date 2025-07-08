// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mobile_app_pocketpartners/features/payments/models/receipt_entity.dart';
//
// class ReceiptItem extends StatelessWidget {
//   final ReceiptEntity receipt;
//
//   const ReceiptItem({Key? key, required this.receipt}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       leading: const Icon(Icons.receipt),
//       title: Text(
//         receipt.name ?? "Sin título",
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text("Monto: \$${receipt.amount?.toStringAsFixed(2) ?? '0.00'}"),
//       children: [
//         ListTile(
//           title: const Text("Nombre del comprobante"),
//           subtitle: Text(receipt.name ?? "Sin nombre"),
//         ),
//         ListTile(
//           title: const Text("Número del comprobante"),
//           subtitle: Text(receipt.receiptNumber?? "Sin número"),
//         ),
//         ListTile(
//           title: const Text("Monto del comprobante"),
//           subtitle: Text("\$${receipt.amount?.toStringAsFixed(2) ?? '0.00'}"),
//         ),
//         ListTile(
//           title: const Text("Fecha de emisión"),
//           subtitle: Text(
//             receipt.issueDate != null
//                 ? DateFormat('dd/MM/yyyy').format(receipt.issueDate)
//                 : "Sin fecha",
//           ),
//         ),
//         if (receipt.imagePath != null)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.network(receipt.imagePath!),
//           )
//         else
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text("Sin imagen adjunta"),
//           ),
//       ],
//     );
//   }
// }
