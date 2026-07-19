import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/layouts/desktop_scaffold.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../widgets/student_form_dialog.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StudentBloc>()..add(const LoadStudents()),
      child: const _StudentListView(),
    );
  }
}

class _StudentListView extends StatelessWidget {
  const _StudentListView();

  void _openStudentForm(BuildContext context, {Student? student}) {
    final bloc = context.read<StudentBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => StudentFormDialog(
        initialStudent: student,
        onSubmit: (firstName, lastName, phone, level) {
          if (student == null) {
            bloc.add(
              AddStudentRequested(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phone,
                classLevel: level,
              ),
            );
          } else {
            bloc.add(
              UpdateStudentRequested(
                student.copyWith(
                  firstName: firstName,
                  lastName: lastName,
                  phoneNumber: phone,
                  classLevel: level,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      currentRoute: '/students',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Öğrenciler', style: AppTextStyles.heading1),
                FilledButton.icon(
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Öğrenci Ekle'),
                  onPressed: () => _openStudentForm(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                  if (state.students.isEmpty) {
                    return  Center(
                      child: Text(
                        'Henüz öğrenci eklenmedi',
                        style: AppTextStyles.body,
                      ),
                    );
                  }
                  return Card(
                    child: ListView.separated(
                      itemCount: state.students.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppColors.border),
                      itemBuilder: (context, index) {
                        final student = state.students[index];
                        return FadeSlideIn(
                          index: index,
                          child: ListTile(
                            title: Text(student.fullName, style: AppTextStyles.bodyMedium),
                            subtitle: Text(
                              '${student.classLevel.label} · ${student.phoneNumber}',
                              style: AppTextStyles.caption,
                            ),
                            onTap: () => _openStudentForm(context, student: student),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  color: AppColors.textSecondary,
                                  onPressed: () =>
                                      _openStudentForm(context, student: student),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: AppColors.coral,
                                  onPressed: () {
                                    context.read<StudentBloc>().add(
                                          DeleteStudentRequested(student.id!),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
