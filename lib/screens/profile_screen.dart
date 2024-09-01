import 'package:flutter/material.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:basic_app/services/connectivity_service.dart';
import 'package:basic_app/widgets/navigation_menu.dart';
import 'package:basic_app/models/user_profile.dart';
import 'package:provider/provider.dart' as provider;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  UserProfile? _originalProfile;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final authService = provider.Provider.of<AuthService>(context, listen: false);
    final cachedProfile = await authService.getCachedUserProfile();
    setState(() {
      _userProfile = cachedProfile ?? authService.currentUserProfile;
      _originalProfile = _userProfile?.clone();
      _isLoading = false;
    });
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate() && _userProfile != null) {
      final authService = provider.Provider.of<AuthService>(context, listen: false);
      final connectivityService = provider.Provider.of<ConnectivityService>(context, listen: false);
      
      if (connectivityService.isOffline) {
        await authService.saveProfileLocally(_userProfile!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved locally. Will sync when online.')),
        );
      } else {
        try {
          await authService.updateUserProfile(_userProfile!);
          _originalProfile = _userProfile?.clone();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
      setState(() {}); // Trigger a rebuild to reflect changes
    }
  }

  bool get _hasUnsavedChanges => !(_userProfile?.equals(_originalProfile) ?? true);

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      onChanged: (newValue) {
        setState(() {
          onChanged(newValue);
        });
      },
    );
  }

  Widget _buildPrivacyToggle(String field) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$field visibility:'),
        DropdownButton<bool>(
          value: _userProfile?.privacySettings[field] ?? false,
          items: [
            DropdownMenuItem(child: Text('Private'), value: false),
            DropdownMenuItem(child: Text('Public'), value: true),
          ],
          onChanged: (value) {
            setState(() {
              if (_userProfile != null) {
                _userProfile!.privacySettings[field] = value!;
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = provider.Provider.of<ConnectivityService>(context).isOffline;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (_hasUnsavedChanges)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _updateProfile,
            ),
        ],
      ),
      drawer: NavigationMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? Center(child: Text('Failed to load profile. Please try again.'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOffline)
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'You are offline. Changes will be saved locally.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        _buildTextField('Username', _userProfile!.username,
                            (value) => _userProfile!.username = value),
                        _buildTextField('Email', _userProfile!.email,
                            (value) => _userProfile!.email = value),
                        _buildPrivacyToggle('email'),
                        _buildTextField('Name', _userProfile!.name,
                            (value) => _userProfile!.name = value),
                        _buildPrivacyToggle('name'),
                        _buildTextField('Pronouns', _userProfile!.pronouns,
                            (value) => _userProfile!.pronouns = value),
                        _buildPrivacyToggle('pronouns'),
                        _buildTextField('Phone', _userProfile!.phone,
                            (value) => _userProfile!.phone = value),
                        _buildPrivacyToggle('phone'),
                        _buildTextField('Website', _userProfile!.website,
                            (value) => _userProfile!.website = value),
                        _buildPrivacyToggle('website'),
                        _buildTextField('Bio', _userProfile!.bio,
                            (value) => _userProfile!.bio = value),
                        _buildPrivacyToggle('bio'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _hasUnsavedChanges ? _updateProfile : null,
                          child: Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}