import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ImageUpload.dart';
import 'constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doctorExperienceController = TextEditingController();
  final TextEditingController _doctorStudiesController = TextEditingController();

  String? _imageUrl;
  bool _loading = false;
  String? _selectedUserType;

  final _formKey = GlobalKey<FormState>();

  Future<bool?> createUser({
    required final String email,
    required final String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return true;
      } else {
        context.showErrorMessage('Error during sign up: ${response}');
        return false;
      }
    } catch (error) {
      context.showErrorMessage('Error during sign up: $error');
      return false;
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    final userName = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final user = Supabase.instance.client.auth.currentUser;
    final experience = _doctorExperienceController.text;
    final studies = _doctorStudiesController.text;

    if (user == null) {
      context.showErrorMessage('No user found. Please try again.');
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      if (_selectedUserType == 'client') {
        // Update the 'client' table for clients
        final updates = {
          'id': user.id,
          'username': userName,
          'Phone_number': phoneNumber,
          'avatar_url': _imageUrl,
        };

        print('Updating client profile with: $updates');
        final response = await Supabase.instance.client.from('client').insert(updates);
        if (response.error != null) {
          print('Insert client error: ${response.error!.message}');
          context.showErrorMessage('Failed to update client profile. Please try again.');
        }
      } else if (_selectedUserType == 'doctor') {
        // Update the 'professionel' table for doctors
        final doctorUpdates = {
          'id': user.id,
          'username': userName,
          'Phone_number': phoneNumber,
          'experience': experience,
          'studies': studies,
          'avatar_url': _imageUrl,
        };

        print('Updating doctor profile with: $doctorUpdates');
        final response = await Supabase.instance.client.from('professionel').insert(doctorUpdates);
        if (response.error != null) {
          print('Insert doctor error: ${response.error!.message}');
          context.showErrorMessage('Failed to update doctor profile. Please try again.');
        }
      }

      if (mounted) {
        context.showSuccessMessage('Successfully updated profile!');
      }
    } on PostgrestException catch (error) {
      print('PostgrestException: ${error.message}');
      context.showErrorMessage('Failed to update profile. Please try again.');
    } catch (error) {
      print('Unexpected error: $error');
      context.showErrorMessage('Unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (double.tryParse(value) != null) {
      return 'Name cannot be a number';
    }
    if (value.length <= 2) {
      return 'You must enter a longer name';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 8) {
      return 'A phone number must contain 8 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'You must enter a longer password';
    }
    return null;
  }

  String? _validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Experience is required';
    }
    if (value.length > 2) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _validateStudies(String? value) {
    if (value == null || value.isEmpty) {
      return 'Studies is required';
    }
    if (double.tryParse(value) != null) {
      return 'Studies cannot be a number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Avatar(
                  imageUrl: _imageUrl,
                  onUpload: (imageUrl) async {
                    setState(() {
                      _imageUrl = imageUrl!;
                    });
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  validator: _validatePhone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedUserType,
                  onChanged: (value) {
                    setState(() {
                      _selectedUserType = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'client',
                      child: Text('Client'),
                    ),
                    DropdownMenuItem(
                      value: 'doctor',
                      child: Text('Professional'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'User Type',
                  ),
                ),
                if (_selectedUserType == 'doctor') ...[
                  TextFormField(
                    controller: _doctorExperienceController,
                    validator: _validateExperience,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Professionnel Experience (in years)',
                    ),
                  ),
                  TextFormField(
                    controller: _doctorStudiesController,
                    validator: _validateStudies,
                    decoration: InputDecoration(
                      labelText: 'Professionnel Studies',
                    ),
                  ),
                ],
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final userCreated = await createUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );


                      if (userCreated==true) {
                        await _updateProfile();
                        if (_selectedUserType == 'client') {
                          Navigator.pushReplacementNamed(context, '/interfaceclient');
                        } else if (_selectedUserType == 'doctor') {
                          Navigator.pushReplacementNamed(context, '/interfaceprofessionel');
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Sign Up Failed'),
                            content: Text('Invalid entry. Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: prColor,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension ShowSuccessMessage on BuildContext {
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

extension ShowErrorMessage on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
