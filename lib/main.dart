import 'package:flutter/material.dart';
import 'package:linear_algebra_me/core/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/app_constants.dart';
import 'viewmodels/solver_viewmodel.dart';
import 'views/screens/workspace_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(
        AppConstants.defaultWindowWidth,
        AppConstants.defaultWindowHeight,
      ),
      minimumSize: Size(
        AppConstants.minWindowWidth,
        AppConstants.minWindowHeight,
      ),
      center: true,
      title: 'Linear Algebra Solver',
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final SolverViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SolverViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WorkspaceScreen(viewModel: viewModel),
    );
  }
}
