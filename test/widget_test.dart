import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillfix/main.dart';
import 'package:skillfix/services/favorites_service.dart';

void main() {
  testWidgets('HomeScreen shows SkillFix branding', (WidgetTester tester) async {
    final favs = FavoritesService();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: favs,
        child: const SkillFixApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SkillFix'), findsWidgets);
  });
}
