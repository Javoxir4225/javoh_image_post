import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:javoh_image_post/models/post_model.dart';

class DBService {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static Future<List<PostModel>> getPosts() async {
    final ref = _db.ref("posts");

    final data = await ref.get();
    print("DBService: getPosts: data => ${data.value}");
    final result = <PostModel>[];
    for (var post in data.children) {
      final postModel = PostModel.fromJson(
        Map<String, dynamic>.from(
          post.value as Map,
        ),
      );
      result.add(postModel);
    }
    return result;
  }

  static Future<bool> createPost(PostModel post, File? file) async {
    final ref = _db.ref("posts/${post.id}");
    // print("DBGService:createPost: createPost => ");
    try {
      TaskSnapshot? res;
      if (file != null) {
        res = await _storage
            .ref("posts")
            .child(file.path.split("/").last)
            .putFile(file);
      }
      post.image = await res?.ref.getDownloadURL();
      print(
          "DBServise: createPost: image Ref =====================>>>> ${(post.image)}");
      await ref.set(post.toJson());
    } catch (e) {
      print("DBGService:createPost: error => $e");
      return false;
    }
    return true;
  }

  static Future<bool> deletPost(String? id) async {
    final ref = _db.ref("posts/$id");
    if (id != null) {
      try {
        await ref.remove();
        return true;
      } catch (e) {
        print("DBService:deletPost: error  => $e");
        return false;
      }
    } else {
      return false;
    }
  }
}
