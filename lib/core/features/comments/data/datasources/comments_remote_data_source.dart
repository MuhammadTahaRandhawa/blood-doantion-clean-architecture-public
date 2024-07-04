import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/comments/data/datamodel/comment_model.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';

abstract interface class CommentsRemoteDataSource {
  Future<Unit> postACommentOnDonation(
      CommentModel commentModel, String donationId);
  Future<List<CommentModel>> fetchDonationComments(String donationId);
  Future<Unit> postACommentOnRequest(
      CommentModel commentModel, String requestId);
  Future<List<CommentModel>> fetchRequestComments(String requestId);
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  CommentsRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  Future<List<CommentModel>> fetchDonationComments(String donationID) async {
    try {
      final response = await firebaseFirestore
          .collection('donations')
          .doc(donationID)
          .collection('comments')
          .get();
      final comments = response.docs
          .map((e) => CommentModel.fromJson(e.data(), CommentType.donation))
          .toList();
      return comments;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CommentModel>> fetchRequestComments(String requestID) async {
    try {
      final response = await firebaseFirestore
          .collection('requests')
          .doc(requestID)
          .collection('comments')
          .get();
      final comments = response.docs
          .map((e) => CommentModel.fromJson(e.data(), CommentType.request))
          .toList();
      return comments;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postACommentOnDonation(
      CommentModel commentModel, String donationId) async {
    try {
      await firebaseFirestore
          .collection('donations')
          .doc(donationId)
          .collection('comments')
          .doc(commentModel.commentId)
          .set(commentModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postACommentOnRequest(
      CommentModel commentModel, String requestId) async {
    try {
      await firebaseFirestore
          .collection('requests')
          .doc(requestId)
          .collection('comments')
          .doc(commentModel.commentId)
          .set(commentModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
