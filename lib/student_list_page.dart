import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/notification/notification_bloc.dart';
import 'package:miniapp/notification/notification_event.dart';
import 'package:miniapp/notification/notification_state.dart';
import 'package:miniapp/presentation/auth_bloc.dart';
import 'package:miniapp/presentation/auth_event.dart';
import 'package:miniapp/presentation/register_page.dart';
import 'package:miniapp/presentation/student/student_bloc.dart';
import 'package:miniapp/presentation/student/student_event.dart';
import 'package:miniapp/presentation/student/student_state.dart';
import 'package:miniapp/student_detail_page.dart';
import 'package:miniapp/theme/theme_bloc.dart';
import 'package:miniapp/theme/theme_event.dart';
import 'package:miniapp/theme/theme_state.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final ScrollController _scrollController = ScrollController();
  double _elevation = 0;

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(LoadStudents());
    
    _scrollController.addListener(() {
      setState(() {
        _elevation = _scrollController.offset > 10 ? 4 : 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshStudents() async {
    context.read<StudentBloc>().add(RefreshStudents());
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode 
          ? Colors.grey[900]
          : Colors.grey[50],
      
      appBar: AppBar(
        title: Text(
          "Daftar Siswa",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        centerTitle: false,
        elevation: _elevation,
        shadowColor: isDarkMode ? Colors.black : Colors.grey[300],
        backgroundColor: isDarkMode 
            ? Colors.grey[850]
            : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          _buildNotificationButton(isDarkMode),
          _buildThemeToggleButton(isDarkMode),
          _buildLogoutButton(isDarkMode),
        ],
      ),

      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoaded) {
            if (state.students.isEmpty) {
              return _buildEmptyState(theme, isDarkMode);
            }

            return _buildStudentList(state, theme, isDarkMode);
          }

          return _buildLoadingState(theme);
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
          context.read<StudentBloc>().add(LoadStudents());
        },
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.person_add_alt_1, size: 22),
        label: const Text(
          "Tambah Siswa",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(bool isDarkMode) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    size: 22,
                  ),
                  onPressed: () {
                    context.read<NotificationBloc>().add(ClearNotifications());
                    _showNotificationSnackbar(context);
                  },
                ),
              ),
              
              if (state.unreadCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[850]! : Colors.white,
                        width: 2,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      state.unreadCount > 9 ? '9+' : '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeToggleButton(bool isDarkMode) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.amber[300] : Colors.grey[700],
              size: 22,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(bool isDarkMode) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.logout,
          color: Colors.redAccent,
          size: 22,
        ),
        onPressed: () => _showLogoutDialog(context, isDarkMode),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshStudents,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                "Belum ada siswa terdaftar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList(StudentLoaded state, ThemeData theme, bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshStudents,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.students.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final student = state.students[index];
          
          return _buildStudentCard(student, theme, isDarkMode);
        },
      ),
    );
  }

  Widget _buildStudentCard(dynamic student, ThemeData theme, bool isDarkMode) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDetailPage(student: student),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NISN: ${student.nisn}",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Jurusan: ${student.major}",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Memuat data siswa...",
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Tidak ada notifikasi baru"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        title: Text(
          "Logout",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Yakin ingin logout?",
          style: TextStyle(
            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Batal",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}