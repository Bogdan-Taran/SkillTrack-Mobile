import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skilltrack/src/features/auth/routing/auth_routes.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'src/core/utils/logger.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return TalkerWrapper(
          talker: talker,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'SkillTrack',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
