import 'package:flutter/material.dart';
import 'package:officialagreement/models/agreement_model.dart';
import 'package:officialagreement/services/firestore_service.dart';
import 'package:officialagreement/widgets/aadhaar_esign_dialog.dart';

class AgreementDetailsScreen extends StatefulWidget {
  final AgreementModel agreement;

  const AgreementDetailsScreen({super.key, required this.agreement});

  @override
  State<AgreementDetailsScreen> createState() => _AgreementDetailsScreenState();
}

class _AgreementDetailsScreenState extends State<AgreementDetailsScreen> {
  bool _isLoading = false;
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _signAgreement() async {
    // Open the Aadhaar eSign Gateway simulation
    final bool? isSigned = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AadhaarEsignDialog(),
    );

    if (isSigned != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('e-Sign cancelled.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedAgreement = widget.agreement.copyWith(
        status: 'Signed',
        // In a real scenario we could add a `signedAt` field here.
      );

      await _firestoreService.updateAgreement(updatedAgreement);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agreement signed successfully via Aadhaar!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final bool isSigned = widget.agreement.status == 'Signed';

    return Scaffold(
      appBar: AppBar(title: const Text('Agreement Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.agreement.projectTitle.isNotEmpty
                  ? widget.agreement.projectTitle
                  : 'Document Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Status',
              widget.agreement.status,
              isSigned ? Colors.green : Colors.orange,
            ),
            _buildDetailRow('Client', widget.agreement.clientName, textColor),
            _buildDetailRow('Email', widget.agreement.clientEmail, textColor),
            _buildDetailRow('Phone', widget.agreement.clientPhone, textColor),
            _buildDetailRow('Deadline', widget.agreement.deadline, textColor),
            const Divider(height: 48),
            Text(
              'Description / Scope of Work',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.agreement.description.isNotEmpty
                  ? widget.agreement.description
                  : 'No description provided.',
              style: TextStyle(fontSize: 15, color: textColor),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Structure',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.agreement.paymentStructure,
              style: TextStyle(fontSize: 15, color: textColor),
            ),
            _buildDetailRow(
              'Total Amount',
              widget.agreement.totalAmount,
              textColor,
            ),

            const SizedBox(height: 48),
            if (!isSigned)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signAgreement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF160AE8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign Agreement with OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            if (isSigned)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'This document has been safely signed.',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
