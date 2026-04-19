import 'package:cloud_firestore/cloud_firestore.dart';

class AgreementModel {
  final String id;
  final String creatorId; // Typically the current user
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String projectTitle;
  final String description;
  final String deadline;
  final String totalAmount;
  final String paymentStructure;
  final DateTime createdAt;
  final String status;

  AgreementModel({
    required this.id,
    required this.creatorId,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.projectTitle,
    required this.description,
    required this.deadline,
    required this.totalAmount,
    required this.paymentStructure,
    required this.createdAt,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'projectTitle': projectTitle,
      'description': description,
      'deadline': deadline,
      'totalAmount': totalAmount,
      'paymentStructure': paymentStructure,
      'createdAt': FieldValue.serverTimestamp(),
      'status': status,
    };
  }

  AgreementModel copyWith({
    String? id,
    String? creatorId,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    String? projectTitle,
    String? description,
    String? deadline,
    String? totalAmount,
    String? paymentStructure,
    DateTime? createdAt,
    String? status,
  }) {
    return AgreementModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhone: clientPhone ?? this.clientPhone,
      projectTitle: projectTitle ?? this.projectTitle,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStructure: paymentStructure ?? this.paymentStructure,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  factory AgreementModel.fromMap(Map<String, dynamic> map, String docId) {
    return AgreementModel(
      id: docId,
      creatorId: map['creatorId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientEmail: map['clientEmail'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      projectTitle: map['projectTitle'] ?? '',
      description: map['description'] ?? '',
      deadline: map['deadline'] ?? '',
      totalAmount: map['totalAmount'] ?? '',
      paymentStructure: map['paymentStructure'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: map['status'] ?? 'Pending',
    );
  }
}
