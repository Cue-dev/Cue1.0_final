import 'package:Cue/app.dart';
import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/reference_video_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ReferenceVideoModel()),
    Provider<AuthProvider>(
      create: (_) => AuthProvider(FirebaseAuth.instance),
    ),
    StreamProvider(
      create: (context) => context.read<AuthProvider>().authState,
    )
    // ChangeNotifierProvider<FirebaseAuthService>(
    //     create: (context) => FirebaseAuthService())
  ], child: CueApp()));
}
