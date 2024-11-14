import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _taskController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF4A148C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _buildAddTask(),
                      SizedBox(height: 20),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('users')
                              .doc(_auth.currentUser?.uid)
                              .collection('tasks')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1A237E),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.task_alt_rounded,
                                      size: 70,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'No tasks yet',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final tasks = snapshot.data!.docs;
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return _buildTaskCard(task);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Text(
            'Daily Tasks',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTask() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Add a new task',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              style: GoogleFonts.poppins(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Color(0xFF1A237E), size: 32),
            onPressed: _addTask,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(QueryDocumentSnapshot task) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTask(task.id),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            task['title'],
            style: GoogleFonts.poppins(
              decoration: task['completed'] ? TextDecoration.lineThrough : null,
              color: task['completed'] ? Colors.grey : Colors.black87,
            ),
          ),
          trailing: Checkbox(
            value: task['completed'],
            onChanged: (bool? value) {
              _toggleTask(task.id, value ?? false);
            },
            activeColor: Color(0xFF1A237E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('tasks')
          .add({
        'title': _taskController.text.trim(),
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _taskController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleTask(String taskId, bool completed) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('tasks')
          .doc(taskId)
          .update({'completed': completed});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}