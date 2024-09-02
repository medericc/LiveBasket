import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();

  final confNameController = TextEditingController();
  final speakerNameController = TextEditingController();

  String selectedConfType = 'talk';
  DateTime? selectedConfDate = DateTime.now(); // Corrected DateTime initialization

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: confNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Entrer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez compléter ce champ";
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: speakerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom2',
                  hintText: 'Entrer2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez compléter ce champ";
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField<String>(
                value: selectedConfType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'talk', child: Text('Talk')),
                  DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                  DropdownMenuItem(value: 'seminar', child: Text('Seminar')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedConfType = value!;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter Date',
                  border: OutlineInputBorder(),
                ),
                firstDate: DateTime.now().add(const Duration(days: 10)),
                lastDate: DateTime.now().add(const Duration(days: 40)),
               initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
  onChanged: (DateTime? value) {
    selectedDate = value;
  },
                
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final confName = confNameController.text;
                    final speakerName = speakerNameController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi en cours..."))
                    );
                    FocusScope.of(context).requestFocus(FocusNode());
                    print("Ajout de la conférence $confName par le speaker $speakerName");
                    print("Type de conférence: $selectedConfType");
                    print("Date de la conférence: $selectedConfDate");
                  }
                },
                child: const Text("Envoyer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
