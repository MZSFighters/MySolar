import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Database Connection Test', () {
    setUpAll(() async {
      await Firebase.initializeApp();
    });

    testWidgets('Test Stable Connection to Firestore', (WidgetTester tester) async {
      bool isConnected = false;

      try {
      
        await FirebaseFirestore.instance.collection('appliances').limit(1).get();
        isConnected = true;
      } catch (e) {
        isConnected = false;
      }

      expect(isConnected, true);
    });
  });
}

