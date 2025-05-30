import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bloc/healthcare_center_bloc.dart';

class RatingForm extends StatefulWidget {
  final String centerId;

  const RatingForm({Key? key, required this.centerId}) : super(key: key);

  @override
  _RatingFormState createState() => _RatingFormState();
}

class _RatingFormState extends State<RatingForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate this center',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemCount: 5,
              itemSize: 32,
              allowHalfRating: false,
              unratedColor: Colors.grey.shade300,
              itemBuilder:
                  (_, __) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Leave a comment (optional)',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
              validator: (_) => _rating == 0 ? 'Please select a rating' : null,
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onPressed: _submitRating,
                icon: const Icon(Icons.send, size: 20),
                label: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    if (_formKey.currentState!.validate()) {
      context.read<HealthcareCenterBloc>().add(
        SubmitCenterRating(
          centerId: widget.centerId,
          userId: 'current_user_id',
          ratingValue: _rating.toInt(),
          comment: _commentController.text.trim(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks for your feedback!')),
      );

      _commentController.clear();
      setState(() => _rating = 0);
    }
  }
}
