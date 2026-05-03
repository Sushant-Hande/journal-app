import 'package:flutter/material.dart';
import 'package:journal_app/data/repositories/home_repository.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/presentation/ui/homescreen/home_screen.dart';
import 'package:journal_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewmodel>(
      create: (context) => HomeViewmodel(
        context.read<HomeRepository>(),
        context.read<LocalStorageService>(),
      ),
      child: const HomeScreen(),
    );
  }
}

