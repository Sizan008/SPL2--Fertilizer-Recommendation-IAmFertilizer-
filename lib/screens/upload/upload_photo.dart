import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/fastapi_service.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false; // লোডিং স্টেট

  // ছবি তোলার বা গ্যালারি থেকে নেওয়ার ফাংশন
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // এনালাইসিস বাটন প্রেস করলে যা হবে
  void _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    // API কল করা
    var result = await FastApiService.uploadCropImage(_image!.path);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // সাকসেস হলে একটি ডায়লগ বক্সে রেজাল্ট দেখানো
      _showResultDialog(
        result['data']['disease'],
        result['data']['recommendation'],
        result['data']['confidence'] ?? "N/A",
      );
    } else {
      // এরর হলে মেসেজ দেখানো
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  // রেজাল্ট দেখানোর ডায়লগ বক্স
  void _showResultDialog(String disease, String recommendation, String confidence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Analysis Result", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Disease: $disease", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 5),
            Text("Confidence: $confidence"),
            const Divider(),
            const Text("Recommendation:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(recommendation),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Color(0xff11998e))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Analyze Crop", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ইমেজ প্রিভিউ বক্স
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xff11998e).withOpacity(0.3)),
                ),
                child: _image == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image_search, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No image selected", style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // বাটন সেকশন (ক্যামেরা ও গ্যালারি)
            Row(
              children: [
                _buildActionButton(Icons.camera_alt, "Camera", () => getImage(ImageSource.camera)),
                const SizedBox(width: 15),
                _buildActionButton(Icons.photo_library, "Gallery", () => getImage(ImageSource.gallery)),
              ],
            ),

            const SizedBox(height: 20),

            // এনালাইসিস বাটন
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff11998e),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                onPressed: (_image == null || _isLoading) ? null : _analyzeImage,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Get Recommendation",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // কাস্টম বাটন উইজেট
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xff11998e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff11998e)),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xff11998e)),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff11998e))),
            ],
          ),
        ),
      ),
    );
  }
}