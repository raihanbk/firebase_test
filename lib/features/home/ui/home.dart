import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/db/auth_db.dart';
import 'package:firebase_test/features/img_storage/img_storage_home.dart';
import 'package:firebase_test/features/login/ui/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  late CollectionReference userCollection;

  @override
  void initState() {
    userCollection = FirebaseFirestore.instance.collection('users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget._auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {
                signOutUer();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            textField(label: 'Name', controller: nameController),
            textField(label: 'Email', controller: emailController),
            textField(label: 'Phone', controller: phoneController),
            MaterialButton(
              onPressed: () {
                Controller.addUser(
                    context: context,
                    nameController: nameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    userCollection: userCollection);
              },
              color: Colors.lightGreenAccent,
              shape: const StadiumBorder(),
              child: const Text('Add'),
            ),
            if (user != null)
              StreamBuilder<QuerySnapshot>(
                  stream: widget._firestore
                      .collection('users')
                      .where('userId', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error : ${snapshot.error}"));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Document does not exist'),
                      );
                    } else {
                      final users = snapshot.data!.docs;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final userId = user.id;
                            final name = user['Name'];
                            final email = user['Email'];
                            final phone = user['Phone'];
                            return Card(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name),
                                Text(email),
                                Text(phone),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          editUser(userId, name, email, phone);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          deleteUser(userId);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                )
                              ],
                            ));
                          },
                        ),
                      );
                    }
                  }),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StorageHome()));
                },
                child: Text('Image Storage')),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUser() {
    return userCollection.snapshots();
  }

  Widget textField(
      {required String label, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  void editUser(String userId, String name, String email, String phone) {
    showDialog(
        context: context,
        builder: (context) {
          final newNameController = TextEditingController(text: name);
          final newEmailController = TextEditingController(text: email);
          final newPhoneController = TextEditingController(text: phone);

          return AlertDialog(
            title: const Text('Edit User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textField(label: '', controller: newNameController),
                textField(label: '', controller: newEmailController),
                textField(label: '', controller: newPhoneController),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    String uid = userId;
                    String uName = newNameController.text;
                    String uEmail = newEmailController.text;
                    String uPhone = newPhoneController.text;
                    updateUser(uid, uName, uEmail, uPhone)
                        .then((value) => Navigator.pop(context));
                  },
                  child: const Text('Update')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  Future<void> updateUser(
      String uid, String uName, String uEmail, String uPhone) {
    var data = {'Name': uName, 'Email': uEmail, 'Phone': uPhone};

    return userCollection.doc(uid).update(data).then((value) {
      print('User updated Successfully');
    }).catchError((error) {
      print('Failed to update user');
    });
  }

  Future<void> deleteUser(String userId) {
    return userCollection.doc(userId).delete().catchError((error) {
      print('Failed to delete');
    });
  }

  void signOutUer() async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
            (route) => false));
  }
}
