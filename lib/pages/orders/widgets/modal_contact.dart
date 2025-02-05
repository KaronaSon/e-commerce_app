// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

class ContactNumberModalDailog {
  ContactNumberModalDailog._();

  static Future show(
    BuildContext context,
    String contactNumber,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ContactOptionModal(
            contackNumber: contactNumber,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ContactOptionModal extends StatefulWidget {
  String contackNumber;
  ContactOptionModal({
    super.key,
    required this.contackNumber,
  });

  @override
  State<ContactOptionModal> createState() => _ContactOptionModalState();
}

class _ContactOptionModalState extends State<ContactOptionModal> {
  var txtNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtNumber.text = widget.contackNumber;
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {});
              Navigator.pop(
                context,
                txtNumber.text,
              );
            },
            child: Container(
              height: 24,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('Contact Number'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: TextField(
              autofocus: true,
              controller: txtNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
              ),
              onPressed: () {
                setState(() {
                  if (txtNumber.text.isEmpty) {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.alert,
                      label: "Please enter your contact number",
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: "Saved your Phone Number",
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  }
                });
                Navigator.pop(
                  context,
                  txtNumber.text,
                );
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
