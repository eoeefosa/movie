import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieboxclone/models/usermodel.dart';
import 'package:movieboxclone/styles/snack_bar.dart';

class Auth{
final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

Future<Usermodel?> signUpuser(
  String email,
  String password,
)  async{
  try{
    final UserCredential userCredential=
    await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim(),);
    final User? firebaseUser= userCredential.user;
    if(firebaseUser!=null){
      return Usermodel(id: firebaseUser.uid, email: firebaseUser.email??'', displayName: firebaseUser.displayName??'', profileImageUrl: firebaseUser.photoURL??'', username: firebaseUser.displayName??'');
    }
  } on FirebaseAuthException catch (e){
    hideSnackBar();
    showsnackBar(e.toString());
  }
  return null;
}

Future<void> signOutUser() async{
  final User? firebaseUser= FirebaseAuth.instance.currentUser;
  if(firebaseUser!=null){
    await FirebaseAuth.instance.signOut();
  }
}
}