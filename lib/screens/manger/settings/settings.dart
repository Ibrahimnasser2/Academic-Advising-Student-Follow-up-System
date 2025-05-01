import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:followupst/componants/components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/manger_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';
import '../guidance_manager_home_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuidanceManagerCubit()..loadManagerProfile(),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تعديل الملف الشخصي',
            style: GoogleFonts.tajawal(),
          ),
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const EditProfileForm(),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
      listener: (context, state) {
        if (state is OperationSuccess) {
          showToast(
            message: state.message.toString(),
            state: ToastStates.SUCCESS,
          );
          navigate_to(context, GuidanceManagerHomeScreen());
        } else if (state is GuidanceManagerError) {
          showToast(
            message: state.message.toString(),
            state: ToastStates.ERROR,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<GuidanceManagerCubit>();

        if (state is ManagerProfileLoaded) {
          _nameController.text = state.manager.name;
          _emailController.text = state.manager.email;
          _phoneController.text = state.manager.phone;
          cubit.currentManager = state.manager;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 24),
                  _buildNameField(cubit),
                  const SizedBox(height: 16),
                  _buildEmailField(cubit),
                  const SizedBox(height: 16),
                  _buildPhoneField(cubit),
                  const SizedBox(height: 24),
                  _buildSectionTitle('تغيير كلمة المرور'),
                  const SizedBox(height: 16),
                  _buildCurrentPasswordField(cubit),
                  const SizedBox(height: 16),
                  _buildNewPasswordField(cubit),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(cubit),
                  const SizedBox(height: 32),
                  _buildSaveButton(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      child: const Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNameField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'الاسم الكامل',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال الاسم الكامل';
        }
        return null;
      },
      onChanged: (value) => cubit.name = value,
    );
  }

  Widget _buildEmailField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!value.contains('@')) {
          return 'البريد الإلكتروني غير صالح';
        }
        return null;
      },
      onChanged: (value) => cubit.email = value,
    );
  }

  Widget _buildPhoneField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'رقم الهاتف',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال رقم الهاتف';
        }
        if (value.length < 10) {
          return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
        }
        return null;
      },
      onChanged: (value) => cubit.phone = value,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureCurrentPassword,
      decoration: InputDecoration(
        labelText: 'كلمة المرور الحالية',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureCurrentPassword = !_obscureCurrentPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (_newPasswordController.text.isNotEmpty && (value == null || value.isEmpty)) {
          return 'الرجاء إدخال كلمة المرور الحالية';
        }
        return null;
      },
      onChanged: (value) => cubit.currentPassword = value,
    );
  }

  Widget _buildNewPasswordField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: _obscureNewPassword,
      decoration: InputDecoration(
        labelText: 'كلمة المرور الجديدة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
      onChanged: (value) => cubit.newPassword = value,
    );
  }

  Widget _buildConfirmPasswordField(GuidanceManagerCubit cubit) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'تأكيد كلمة المرور الجديدة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.lock_reset),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (_newPasswordController.text.isNotEmpty &&
            value != _newPasswordController.text) {
          return 'كلمة المرور غير متطابقة';
        }
        return null;
      },
      onChanged: (value) => cubit.confirmPassword = value,
    );
  }

  Widget _buildSaveButton(BuildContext context, GuidanceManagerState state) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: state is GuidanceManagerLoading
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            context.read<GuidanceManagerCubit>().update_managerProfile();


          }
        },
        child: state is GuidanceManagerLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          'حفظ التغييرات',
          style: GoogleFonts.tajawal(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showToast({required String message, required ToastStates state}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: state == ToastStates.SUCCESS ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }
}