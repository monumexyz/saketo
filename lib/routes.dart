import 'package:go_router/go_router.dart';
import 'package:saketo/pages/enter_password_page.dart';
import 'package:saketo/pages/main_wallet_page.dart';
import 'package:saketo/pages/network/main_network_page.dart';
import 'package:saketo/pages/network/nodes/add_or_edit_node_page.dart';
import 'package:saketo/pages/network/nodes/manage_nodes_page.dart';
import 'package:saketo/pages/onboarding/create_password_page.dart';
import 'package:saketo/pages/entrypoint.dart';
import 'package:saketo/pages/onboarding/mnemonic_display_page.dart';
import 'package:saketo/pages/onboarding/mnemonic_input_page.dart';
import 'package:saketo/pages/onboarding/mode_selection_page.dart';
import 'package:saketo/pages/onboarding/preview_configuration_page.dart';
import 'package:saketo/pages/onboarding/welcome_page.dart';
import 'package:saketo/pages/receive/main_recive_page.dart';
import 'package:saketo/pages/settings/main_settings_page.dart';
import 'package:saketo/wallet/wallet.dart';

final routerConfig = GoRouter(routes: [
  GoRoute(
    path: Entrypoint.routeName,
    builder: (context, state) => const Entrypoint(),
  ),
  GoRoute(
    path: WelcomePage.routeName,
    builder: (context, state) => const WelcomePage(),
  ),
  GoRoute(
      path: ModeSelectionPage.routeName,
      builder: (context, state) {
        return ModeSelectionPage(extra: state.extra as Map<String, Object>);
      }),
  GoRoute(
    path: PreviewConfigurationPage.routeName,
    builder: (context, state) {
      return PreviewConfigurationPage(
          extra: state.extra as Map<String, Object>);
    },
  ),
  GoRoute(
      path: CreatePasswordPage.routeName,
      builder: (context, state) {
        return CreatePasswordPage(extra: state.extra as Map<String, Object>);
      }),
  GoRoute(
      path: MnemonicDisplayPage.routeName,
      builder: (context, state) {
        return MnemonicDisplayPage(extra: state.extra as Map<String, Object>);
      }),
  GoRoute(
      path: MnemonicInputPage.routeName,
      builder: (context, state) {
        return MnemonicInputPage(extra: state.extra as Map<String, Object>);
      }),
  GoRoute(path: MainWalletPage.routeName, builder: (context, state) {
    return MainWalletPage(theWallet: state.extra as Wallet);
  }),
  GoRoute(path: MainSettingsPage.routeName, builder: (context, state) {
    return MainSettingsPage(theWallet: state.extra as Wallet);
  }),
  GoRoute(path: EnterPasswordPage.routeName, builder: (context, state) {
    return EnterPasswordPage(theWallet: state.extra as Wallet);
  }),
  GoRoute(path: MainReceivePage.routeName, builder: (context, state) {
    return MainReceivePage(theWallet: state.extra as Wallet);
  }),
  GoRoute(path: MainNetworkPage.routeName, builder: (context, state) {
    return MainNetworkPage(theWallet: state.extra as Wallet);
  }),
  GoRoute(path: ManageNodesPage.routeName, builder: (context, state) {
    return const ManageNodesPage();
  }),
  GoRoute(path: AddOrEditNodePage.routeName, builder: (context, state) {
    final extra = state.extra as Map<String, Object>;
    return AddOrEditNodePage(nodeId: extra['nodeId'] as String, isEdit: extra['isEdit'] as bool);
  }),
]);
