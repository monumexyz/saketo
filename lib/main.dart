import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:saketo/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saketo/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';
import 'db/main/objectbox.dart';
import 'nodes/node.dart';

// Use this variable to access the database at any time in the app
late ObjectBox objectbox;

Future<void> addDefaultNodes() async {
  final hasNodes = (await SharedPreferences.getInstance()).getBool('has_nodes');
  if (hasNodes == null || !hasNodes) {
    final defaultNodes = [
      Node(const UuidV4().generate(), 'Stack Wallet Node', 'monero.stackwallet.com', 18081, true, false, true)
    ];
    for (final node in defaultNodes) {
      objectbox.store.box<Node>().put(node);
    }
    (await SharedPreferences.getInstance()).setBool('has_nodes', true);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  await addDefaultNodes();
  runApp(ChangeNotifierProvider(
    create: (context) => SyncService(),
    child: const Saketo(),
  ));
}

class Saketo extends StatelessWidget {
  const Saketo({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3E3E3E),
      ),
    );
    return MaterialApp.router(
      title: 'Saketo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3E3E3E), // Gunmetal
            primary: const Color(0xFF3E3E3E), // Gunmetal
            secondary: const Color(0xFF242424), // Charcoal
            tertiary: const Color(0xFFF0F0F0), // New Smoke
            surface: const Color(0xFFBBBBBB), // New Dark Text
            scrim: const Color(0xFF323232), // Greyish
            shadow: const Color(0x1AB3B3B3), // Simple Background
            outline: const Color(0xFF888888), // Hint
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      routerConfig: routerConfig,
    );
  }
}
