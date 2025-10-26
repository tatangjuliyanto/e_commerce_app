import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:e_commerce_app/core/widgets/app_color_custom.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(GetprofileEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: AppColorsCustom.primary,
        ),
        body: AppBackground(
          isScrollable: false,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return ListView(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              'assets/images/profile_avatar.png',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColorsCustom.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.email,
                            style: const TextStyle(
                              color: AppColorsCustom.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.book_online_rounded,
                              color: AppColorsCustom.textPrimary,
                            ),
                            title: const Text(
                              'My Orders',
                              style: TextStyle(
                                color: AppColorsCustom.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              color: AppColorsCustom.textPrimary,
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: AppColorsCustom.textPrimary,
                            ),
                            title: const Text(
                              'Settings',
                              style: TextStyle(
                                color: AppColorsCustom.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              color: AppColorsCustom.textPrimary,
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.lock,
                              color: AppColorsCustom.textPrimary,
                            ),
                            title: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: AppColorsCustom.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColorsCustom.textPrimary,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: AppColorsCustom.textPrimary,
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColorsCustom.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColorsCustom.textPrimary,
                              size: 16,
                            ),
                            onTap: () async {
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Logout Confirmation'),
                                      content: const Text(
                                        'Are you sure you want to logout?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          child: const Text(
                                            'Logout',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                              if (shouldLogout != true) return;
                              context.read<AuthBloc>().add((AuthLogoutEvent()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
