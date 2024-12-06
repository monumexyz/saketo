import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 96),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'app_assets/saketo_logo_combined.svg',
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.tertiary,
                          BlendMode.srcIn),
                      height: 48,
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                        child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.welcome,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          const SizedBox(height: 8),
                          Text(
                              AppLocalizations.of(context)!
                                  .startByCreatingWallet,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Pass parameters
                        context.push('/modeSelectionPage');
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          foregroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        AppLocalizations.of(context)!.createAWallet,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Column(children: [
                        Text(AppLocalizations.of(context)!.alreadyHaveOne,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.tertiary)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () {
                              // TODO: Pass parameters
                              context.push('/modeSelectionPage');
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 64, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                    borderRadius: BorderRadius.circular(5))),
                            child: Text(
                              AppLocalizations.of(context)!.restore,
                              style: const TextStyle(fontSize: 16),
                            )),
                      ]),
                    )
                  ],
                ),
              ),
            )));
  }
}