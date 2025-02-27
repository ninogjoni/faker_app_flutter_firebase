import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_flutter_firebase/src/data/job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addJob(String uid, String title, String company) =>
      _firestore.collection('users/$uid/jobs').add({
        'title': title,
        'company': company,
      });

  /// access the .doc by adding the $jobId to the "path"
  Future<void> updateJob(
          String uid, String jobId, String title, String company) =>

      /// OR _firestore.collection('jobs').doc(jobId).update({ ... })
      _firestore.doc('users/$uid/jobs/$jobId').update({
        'title': title,
        'company': company,
      });

  Future<void> deleteJob(String uid, String jobId) =>

      /// OR       _firestore.collection('jobs').doc(jobId).delete();
      _firestore.doc('users/$uid/jobs/$jobId').delete();

  Query<Job> jobsQuery(String uid) {
    return _firestore.collection('users/$uid/jobs').withConverter(
          fromFirestore: (snapshot, _) => Job.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
