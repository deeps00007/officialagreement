import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agreement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _agreementsRef => _db.collection('agreements');

  // Save an agreement to Firestore
  Future<void> createAgreement(AgreementModel agreement) async {
    try {
      final docRef = _agreementsRef.doc(); // generates new random ID

      // We will override the id with the auto-generated one at save time
      final dataToSave = agreement.toMap();
      dataToSave['id'] = docRef.id;

      await docRef.set(dataToSave);
    } catch (e) {
      throw Exception('Failed to create agreement: $e');
    }
  }

  // Update an existing agreement
  Future<void> updateAgreement(AgreementModel agreement) async {
    try {
      final docRef = _agreementsRef.doc(agreement.id);
      await docRef.update(agreement.toMap());
    } catch (e) {
      throw Exception('Failed to update agreement: $e');
    }
  }

  // Get current user's agreements
  Stream<List<AgreementModel>> getMyAgreements() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _agreementsRef
        .where('creatorId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AgreementModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }
}
