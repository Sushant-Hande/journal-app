import 'package:flutter/material.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<_ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfileData();
  }

  Future<_ProfileData> _loadProfileData() async {
    final storage = context.read<LocalStorageService>();
    final userName = (await storage.getUserName())?.trim();
    final isLoggedIn = await storage.getIsLoggedIn();
    final token = await storage.getAuthToken();

    return _ProfileData(
      userName: (userName == null || userName.isEmpty) ? null : userName,
      isLoggedIn: isLoggedIn,
      hasToken: token != null && token.isNotEmpty,
    );
  }

  Future<void> _refresh() async {
    final future = _loadProfileData();
    setState(() {
      _profileFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: false,
          shadowColor: Colors.black,
          elevation: 4.0,
        ),
        body: FutureBuilder<_ProfileData>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Failed to load profile data.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data;
            if (data == null) {
              return const Center(child: Text('No profile data available.'));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 44,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.userName ?? 'Guest User',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Username'),
                        subtitle: Text(data.userName ?? 'Not available'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.verified_user_outlined),
                        title: const Text('Logged in'),
                        subtitle: Text(data.isLoggedIn ? 'Yes' : 'No'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.key_outlined),
                        title: const Text('Auth token'),
                        subtitle: Text(data.hasToken ? 'Available' : 'Missing'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileData {
  const _ProfileData({
    required this.userName,
    required this.isLoggedIn,
    required this.hasToken,
  });

  final String? userName;
  final bool isLoggedIn;
  final bool hasToken;
}
