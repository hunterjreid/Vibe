// Vibe - Find your Vibe
// Architected by Hunter Reid
//
//dependencies import
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing the cloud_firestore package for Firestore database operations
import 'package:get/get.dart'; // Importing the get package for state management
import 'package:vibe/constants.dart'; // Importing the constants.dart file from the vibe package
import 'package:vibe/models/user.dart'; // Importing the user.dart file from the vibe/models directory

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]); // Creating a reactive variable to hold the searched users

  List<User> get searchedUsers => _searchedUsers.value; // Getter to access the value of searchedUsers

  Future<void> searchUser(String typedUser) async {
    _searchedUsers.bindStream(FirebaseFirestore
        .instance // Binding the stream of Firestore query results to the _searchedUsers variable
        .collection('users') // Accessing the 'users' collection in Firestore
        .where('name',
            isGreaterThanOrEqualTo:
                typedUser) // Querying documents where the 'name' field is greater than or equal to the typedUser string
        .snapshots() // Listening to the snapshots of the query results
        .map((QuerySnapshot query) {
      // Mapping the QuerySnapshot to a List of User objects
      List<User> retVal = [];
      for (var elem in query.docs) {
        retVal.add(User.fromSnap(elem)); // Creating a User object from each document snapshot and adding it to the list
      }
      return retVal;
    }));
  }
}
