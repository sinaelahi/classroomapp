import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/enums/class_level.dart';
import '../../../../shared/layouts/desktop_scaffold.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../students/domain/entities/student.dart';
import '../../../students/presentation/bloc/student_bloc.dart';
import '../../../students/presentation/bloc/student_event.dart';
import '../../../students/presentation/bloc/student_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StudentBloc>()..add(const LoadStudents()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  ClassLevel? _selectedLevel;

  void _sendMessage(BuildContext context, Student student) {
    // TODO: mesajlaşma API'si bağlanınca burası gerçek isteği atacak.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.fullName} için mesaj gönderme yakında aktif olacak'),
      ),
    );
  }

  void _sendBulkMessage(BuildContext context, List<Student> allStudents) {
    // TODO: mesajlaşma API'si bağlanınca burada TÜM öğrencilere toplu
    // mesaj isteği atılacak (öğrenci listesi: allStudents).
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Toplu mesaj: ${allStudents.length} öğrenciye gönderim yakında aktif olacak',
        ),
      ),
    );
  }

  void _sendGroupMessage(
    BuildContext context,
    ClassLevel? level,
    List<Student> groupStudents,
  ) {
    if (level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grup mesajı için önce yukarıdan bir seviye (grup) seç'),
        ),
      );
      return;
    }
    // TODO: mesajlaşma API'si bağlanınca burada SADECE seçili gruba
    // (groupStudents) mesaj isteği atılacak.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${level.label} grubu: ${groupStudents.length} öğrenciye grup mesajı '
          'gönderim yakında aktif olacak',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      currentRoute: '/',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel', style: AppTextStyles.heading1),
            const SizedBox(height: 6),
            Text(
              'Tüm öğrenciler. İstersen seviyeye göre filtrele.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  if (state.status == StudentStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == StudentStatus.failure) {
                    return Center(
                      child: Text(state.errorMessage ?? 'Bir hata oluştu'),
                    );
                  }

                  final filteredStudents = _selectedLevel == null
                      ? state.students
                      : state.students
                          .where((s) => s.classLevel == _selectedLevel)
                          .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LevelFilterBar(
                        selected: _selectedLevel,
                        onChanged: (level) =>
                            setState(() => _selectedLevel = level),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.campaign_rounded, size: 18),
                            label: Text(
                              'Toplu Mesaj (${state.students.length})',
                            ),
                            onPressed: () =>
                                _sendBulkMessage(context, state.students),
                          ),
                          FilledButton.icon(
                            icon: const Icon(Icons.groups_rounded, size: 18),
                            label: Text(
                              _selectedLevel == null
                                  ? 'Grup Mesajı'
                                  : 'Grup Mesajı (${filteredStudents.length})',
                            ),
                            onPressed: () => _sendGroupMessage(
                              context,
                              _selectedLevel,
                              filteredStudents,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: filteredStudents.isEmpty
                            ? Center(
                                child: Text(
                                  state.students.isEmpty
                                      ? 'Henüz öğrenci eklenmedi'
                                      : 'Bu seviyede öğrenci yok',
                                  style: AppTextStyles.body,
                                ),
                              )
                            : Card(
                                child: ListView.separated(
                                  itemCount: filteredStudents.length,
                                  separatorBuilder: (_, __) => const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                  itemBuilder: (context, index) {
                                    final student = filteredStudents[index];
                                    return FadeSlideIn(
                                      index: index,
                                      child: ListTile(
                                        title: Text(
                                          student.fullName,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        subtitle: Text(
                                          '${student.classLevel.label} · ${student.phoneNumber}',
                                          style: AppTextStyles.caption,
                                        ),
                                        trailing: OutlinedButton.icon(
                                          icon: const Icon(
                                            Icons.message,
                                            size: 16,
                                          ),
                                          label: const Text('Mesaj Gönder'),
                                          onPressed: () =>
                                              _sendMessage(context, student),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelFilterBar extends StatelessWidget {
  final ClassLevel? selected;
  final ValueChanged<ClassLevel?> onChanged;

  const _LevelFilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'Tümü',
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: 8),
          for (final level in ClassLevel.values) ...[
            _FilterChip(
              label: level.label,
              selected: selected == level,
              onTap: () => onChanged(level),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.indigoSoft,
        labelStyle: TextStyle(
          color: selected ? AppColors.indigo : AppColors.textPrimary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(color: selected ? AppColors.indigo : AppColors.border),
        backgroundColor: AppColors.surface,
      ),
    );
  }
}
