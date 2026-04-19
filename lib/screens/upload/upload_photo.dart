import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iamfertilizer/services/fastapi_service.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _result;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _selectedImage = File(picked.path);
      _result = null;
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final result = await FastApiService.uploadCropImage(_selectedImage!.path);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _result = result['data'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Analysis failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  Widget _actionButton(String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: const Color(0xff11998e),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyze Crop"),
        backgroundColor: const Color(0xff11998e),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: _selectedImage == null
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 70, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No image selected"),
                  ],
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _actionButton("Camera", Icons.camera_alt, () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 12),
                _actionButton("Gallery", Icons.photo, () => _pickImage(ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Analyze Now"),
              ),
            ),
            const SizedBox(height: 22),
            if (_result != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Result", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text("Detected: ${_result!['disease']}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Confidence: ${_result!['confidence']}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      "Recommendation: ${_result!['recommendation']}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff11998e)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "This result has been saved to history automatically.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}