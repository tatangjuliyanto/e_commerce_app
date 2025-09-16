import 'package:e_commerce_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../domain/usecases/get_profile_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.email,
                          style: const TextStyle(color: Colors.grey),
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
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Change Password'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () async {
                            await Supabase.instance.client.auth.signOut();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/login');
                            }
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
    );
  }
}

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;

//     return BlocProvider(
//       create:
//           (_) => ProfileBloc(
//             getProfileUser: GetProfileUser(
//               ProfileRepositoryImpl(
//                 profileRemoteDataSource: ProfileRemoteDataSourceImpl(),
//               ),
//             ),
//           )..add(GetProfileEvent(user!.id)), // dispatch event
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Profile')),
//         body: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ProfileLoaded) {
//               return ListView(
//                 children: [
//                   const SizedBox(height: 24),
//                   Center(
//                     child: Column(
//                       children: [
//                         const CircleAvatar(
//                           radius: 48,
//                           backgroundImage: AssetImage(
//                             'assets/images/profile_avatar.png',
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           state.name,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           state.email,
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.settings),
//                           title: const Text('Settings'),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 16,
//                           ),
//                           onTap: () {},
//                         ),
//                         const Divider(),
//                         ListTile(
//                           leading: const Icon(Icons.lock),
//                           title: const Text('Change Password'),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 16,
//                           ),
//                           onTap: () {},
//                         ),
//                         const Divider(),
//                         ListTile(
//                           leading: const Icon(Icons.logout),
//                           title: const Text('Logout'),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 16,
//                           ),
//                           onTap: () async {
//                             await Supabase.instance.client.auth.signOut();
//                             if (context.mounted) {
//                               Navigator.pushReplacementNamed(context, '/login');
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             } else if (state is ProfileError) {
//               return Center(child: Text(state.message));
//             }
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }
// }
