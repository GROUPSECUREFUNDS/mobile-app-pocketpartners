import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReceiptDialog extends StatefulWidget {
  final PaymentModel payment;

  const AddReceiptDialog({Key? key, required this.payment}) : super(key: key);

  @override
  State<AddReceiptDialog> createState() => _AddReceiptDialogState();
}

class _AddReceiptDialogState extends State<AddReceiptDialog> {
  final _formKey = GlobalKey<FormState>();
  final receiptService = PaymentService();

  String name = '';
  String receiptNumber = '';
  double amount = 0;
  DateTime issueDate = DateTime.now();
  String? imageId;
  File? imageFile;

  bool loading = false;
  bool ocrLoading = false;
  bool imageUploading = false;

  late TextEditingController nameController;
  late TextEditingController receiptNumberController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    receiptNumberController = TextEditingController(text: receiptNumber);
    amountController = TextEditingController(text: amount != 0 ? amount.toString() : '');
  }

  @override
  void dispose() {
    nameController.dispose();
    receiptNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => imageUploading = true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      try {
        final uploadedImageId = await receiptService.uploadImage(File(pickedFile.path), token);
        setState(() {
          imageFile = File(pickedFile.path);
          imageId = uploadedImageId;
        });
      } catch (e) {
        print("Error uploading image: $e");
      } finally {
        setState(() => imageUploading = false);
      }
    }
  }

  Future<void> extractOCR() async {
    if (imageId == null) return;

    setState(() => ocrLoading = true);
    debugPrint("Image id ${imageId}");
    try {
      final ocrData = await receiptService.extractFieldsFromImage(imageId!);

      setState(() {
        // Actualizar variables con resultados del OCR
        name = ocrData['name'] ?? name;
        receiptNumber = ocrData['receiptNumber'] ?? receiptNumber;
        amount = (ocrData['amount'] as num?)?.toDouble() ?? amount;

        // Actualizar controllers para reflejar en los TextFormField
        nameController.text = name;
        receiptNumberController.text = receiptNumber;
        amountController.text = amount != 0 ? amount.toString() : '';

        // Actualizar issueDate si viene en el OCR
        if (ocrData['issueDate'] != null) {
          List<dynamic> dateArray = ocrData['issueDate'];
          issueDate = DateTime(dateArray[0], dateArray[1], dateArray[2]);
        }
      });
    } catch (e) {
      print("Error extracting OCR: $e");
    } finally {
      setState(() => ocrLoading = false);
    }
  }

  void addReceipt() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        debugPrint("Data: $name + $receiptNumber + $amount + $issueDate + $imageId");
        await receiptService.createReceiptByPayment({
          "name": name,
          "receiptNumber": receiptNumber,
          "amount": amount,
          "issueDate": issueDate.toIso8601String(),
          "imagePath": imageId ?? "",
        }, widget.payment.id);

        Navigator.pop(context, true);
      } catch (e) {
        print("Error adding receipt: $e");
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Deseas agregar comprobantes de pago?"),
      content: loading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Si deseas agregar comprobantes de pago, puedes hacerlo a continuación. Si no, puedes cerrar este diálogo."),
              TextFormField(
                decoration:
                const InputDecoration(labelText: "Nombre del comprobante"),
                controller: nameController,
                onSaved: (value) => name = value ?? '',
                validator: (value) => value!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Número de comprobante"),
                controller: receiptNumberController,
                onSaved: (value) => receiptNumber = value ?? '',
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: "Monto del comprobante"),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                amount = double.tryParse(value ?? '0') ?? 0,
                validator: (value) => value!.isEmpty ? "Requerido" : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: issueDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null)
                    setState(() => issueDate = picked);
                },
                child: Text("Fecha: ${issueDate.toLocal()}".split(' ')[0]),
              ),
              const SizedBox(height: 16),
              if (imageUploading)
                const CircularProgressIndicator()
              else if (imageFile != null)
                Image.file(imageFile!, height: 100),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Agregar foto del recibo"),
                onPressed: pickImage,
              ),
              if (imageId != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.document_scanner),
                  label: const Text("OCR"),
                  onPressed: ocrLoading ? null : extractOCR,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar")),
        ElevatedButton(
            onPressed: addReceipt, child: const Text("Agregar Comprobante")),
      ],
    );
  }
}
