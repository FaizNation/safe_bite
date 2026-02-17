import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      _nameController.text = state.user.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4E7C5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D5016)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showImagePickerOptions(context);
                },
                child: Stack(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        ImageProvider? imageProvider;
                        if (state is ProfileLoaded) {
                          if (state.user.photoBlob != null) {
                            imageProvider = MemoryImage(state.user.photoBlob!);
                          } else if (state.user.photoUrl != null) {
                            imageProvider = NetworkImage(state.user.photoUrl!);
                          }
                        }
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              imageProvider ??
                              const NetworkImage(
                                'https://via.placeholder.com/150',
                              ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6B9F5E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProfileCubit>().updateProfile(
                        name: _nameController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B9F5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (pickedFile != null && mounted) {
        final bytes = await pickedFile.readAsBytes();
        // ignore: use_build_context_synchronously
        context.read<ProfileCubit>().updateProfilePhoto(bytes);
      }
    } catch (e) {
      AppLogger.error('Error picking image: $e');
    }
  }
}
