import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/utils/sealed_class_state.dart';
import '../blocs/edit_profile/edit_profile_bloc.dart';
import '../blocs/profile/profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditProfileBloc>(),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _usernameController = TextEditingController();

  File? _selectedImage;
  String? _existingImagePath;
  bool _imageWasRemoved = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.currentOrPreviousData;
    if (profile != null) {
      _usernameController.text = profile.username;
      _existingImagePath = profile.avatarUrl;
    }
  }

  @override
  dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoadFailure) {
          showErrorSnackbar(context, message: state.failure.message);
        }
        if (state is EditProfileLoadSuccess) {
          context.read<ProfileBloc>().add(MyProfileFetched());
          if (context.canPop()) context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is EditProfileLoadInProgress;
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_buildAvatar()],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    Widget imageWidget;

    if (_selectedImage != null) {
      imageWidget = Image.file(_selectedImage!, fit: BoxFit.cover);
    } else if (_existingImagePath != null && !_imageWasRemoved) {
      imageWidget = CachedNetworkImage(
        imageUrl: _existingImagePath!,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = const Icon(Icons.person, size: 60, color: Colors.grey);
    }

    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(60),
          child: imageWidget,
        ),
      ),
    );
  }
}
