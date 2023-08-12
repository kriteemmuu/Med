import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "General Sales List",
          status: "active",
          imageUrl:
              "https://www.shutterstock.com/image-vector/various-meds-pills-capsules-blisters-glass-1409823341"),
      CategoryModel(
          categoryName: "Pharmacy Medicine",
          status: "active",
          imageUrl:
              "https://www.shutterstock.com/image-photo/drug-prescription-treatment-medication-pharmaceutical-260nw-769176202.jpg"),
      CategoryModel(
          categoryName: "Prescription Only Medicines",
          status: "active",
          imageUrl:
              "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fmedical%2F&psig=AOvVaw0rkkbNvT_RVzUGS-6xPv86&ust=1677695180546000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCKiVytvruP0CFQAAAAAdAAAAABAS"),
      CategoryModel(
          categoryName: "Controlled Drugs",
          status: "active",
          imageUrl:
              "https://www.shutterstock.com/image-vector/various-meds-pills-capsules-blisters-glass-1409823341"),
    ];
  }
}
