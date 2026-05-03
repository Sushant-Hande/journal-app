import 'package:flutter/material.dart';
import 'package:journal_app/app_strings.dart';
import 'package:journal_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:journal_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:provider/provider.dart';
import '../../../routes.dart';
import 'favorites_tab.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vm = context.read<AuthViewModel>();
    final homeVM = context.read<HomeViewmodel>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Text('Journals'),
          centerTitle: false,
          shadowColor: Colors.black,
          // or any visible color
          elevation: 4.0,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'profile', child: Text('Profile')),
                PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'profile':
                    Navigator.of(context).pushNamed(Routes.profile);
                    break;

                  case 'logout':
                    await vm.logout();

                    if (!context.mounted) return;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(Routes.login, (route) => false);

                    break;
                }
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [HomeTab(), FavoritesTab()],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () async {
              // Open add journal screen and wait for the created JournalEntry.
              final result = await Navigator.pushNamed(
                context,
                Routes.addJournal,
              );

              // If a JournalEntry was returned, add it to HomeViewmodel so UI updates immediately.
              if (result is JournalEntry) {
                homeVM.addJournalEntry(result);
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 20,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: AppStrings.favorites,
            ),
          ],
        ),
      ),
    );
  }
}
