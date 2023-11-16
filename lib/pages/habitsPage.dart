import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _habitController = TextEditingController();
  String _selectedType = 'builders'; // Default selected type

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Center(child: Text('Please log in to view your habits.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddHabitDialog(context, user.uid),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildHabitsList(user.uid, 'builders', 'Good Habits'),
          ),
          Expanded(
            child: _buildHabitsList(user.uid, 'breakers', 'Bad Habits'),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(String userId, String type, String title) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('habits')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No $title found'));
        }
        return Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.headline5),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(doc['name']),
                    subtitle: Text('Days: ${doc['days']}'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddHabitDialog(BuildContext context, String userId) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _habitController,
                decoration: InputDecoration(labelText: 'Habit Name'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['builders', 'breakers'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child:
                        Text(value == 'builders' ? 'Good Habit' : 'Bad Habit'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType =
                        value ?? 'builders'; // Update the selected type
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_habitController.text.isNotEmpty) {
                  _firestore.collection('habits').add({
                    'userId': userId,
                    'name': _habitController.text,
                    'type': _selectedType, // Use the selected type
                    'days': 0,
                  });
                  _habitController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
