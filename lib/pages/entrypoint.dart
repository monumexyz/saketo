import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/pages/enter_password_page.dart';
import 'package:saketo/pages/main_wallet_page.dart';
import 'package:saketo/pages/onboarding/welcome_page.dart';
import 'package:saketo/pages/prerelease_disclaimer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../wallet/wallet.dart';

class Entrypoint extends StatefulWidget {
  const Entrypoint({super.key});

  static const routeName = '/';

  @override
  State<Entrypoint> createState() => _EntrypointState();
}

class _EntrypointState extends State<Entrypoint> {

  Future<void> runChecks() async {
    final isInitialized = await SharedPreferences.getInstance();
    if (!mounted) {
      runChecks();
      return;
    }
    if (isInitialized.getBool('is_initialized') == null ||
        !isInitialized.getBool('is_initialized')!) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) context.go(PrereleaseDisclaimerPage.routeName);
      });
      return;
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        final theWallet = objectbox.store.box<Wallet>().getAll().first;
        if (mounted) context.go(EnterPasswordPage.routeName, extra: theWallet);
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    runChecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
              child: SvgPicture.asset(
                'app_assets/saketo_logo_combined.svg',
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.tertiary, BlendMode.srcIn),
                height: 48,
              )
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              'app_assets/entrypoint_lines.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.tertiary, BlendMode.srcIn),
              height: 192,
            ),
          )
        ],
      ),
    );
  }
}