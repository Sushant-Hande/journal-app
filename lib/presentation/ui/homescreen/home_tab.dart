import 'package:flutter/material.dart';
import 'package:journal_app/date_helper.dart';
import 'package:journal_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../network/api_status.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeViewmodel>().getJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final vm = context.watch<HomeViewmodel>();

    if (vm.getJournalsApiStatus == ApiStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            vm.getJournalErrorMessage ?? 'Failed to load Journals',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (vm.journals.isEmpty) {
      return const Center(child: Text('No journals yet'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await vm.getJournals();
      },
      child: Stack(
        children: [
          ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: vm.journals.length,
            itemBuilder: (context, index) {
              final journal = vm.journals[index];

              return Dismissible(
                key: ValueKey(
                  '${journal.id?.timestamp ?? index}_${journal.date ?? ''}',
                ),
                direction: DismissDirection.endToStart,
                // left swipe
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                confirmDismiss: (_) async {
                  return true;
                },

                onDismissed: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Journal deleted')),
                  );
                },
                child: Card(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journal.title?.trim().isNotEmpty == true
                                ? journal.title!
                                : 'Untitled',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              journal.content?.trim().isNotEmpty == true
                                  ? journal.content!
                                  : 'No content',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 14,
                                  color: colors.onSurface,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: Text(
                                    journal.date?.formatDate() ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (vm.getJournalsApiStatus == ApiStatus.loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
