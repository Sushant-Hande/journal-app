import 'package:flutter/material.dart';
import 'package:journal_app/app_strings.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/date_helper.dart';
import 'package:journal_app/presentation/ui/widgets/circular_progress.dart';
import 'package:journal_app/presentation/viewmodels/add_journal_viewmodel.dart';
import 'package:provider/provider.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddJournalViewmodel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 4.0,
          title: Text(AppStrings.addJournal),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month, size: 15),
                            SizedBox(width: 5),
                            Text(getCurrentDate()),
                          ],
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: AppStrings.titleYourJournal,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _descriptionController,
                          maxLines: 8,
                          minLines: 8,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppStrings.beginYourReflectionHere,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            final title = _titleController.text.trim();
                            final description = _descriptionController.text
                                .trim();

                            if (title.isEmpty && description.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Title and description are required',
                                  ),
                                ),
                              );
                              return;
                            }

                            JournalEntry? journalEntry = await vm.addJournal(
                              title: title,
                              content: description,
                            );
                            if (journalEntry != null) {
                              // Return the newly created journal entry to the caller
                              Navigator.pop(context, journalEntry);
                            }
                          },
                          child: Text(AppStrings.addJournal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Full-screen blocking loader
            if (vm.isAddJournalApiLoading) const CircularProgress(),
          ],
        ),
      ),
    );
  }
}
