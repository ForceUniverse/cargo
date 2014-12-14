import 'package:unittest/html_enhanced_config.dart';
import 'cargo_tests.dart' as tests;

main() {
  useHtmlEnhancedConfiguration();
  tests.main();
}