import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String?> getImageUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return null;
      rethrow;
    }
  }

  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final ref = _storage.ref().child(path);
    await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType ?? 'image/png'),
    );
    return await ref.getDownloadURL();
  }

  Future<void> deleteImage(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }

  Future<String?> getBadgeUrl(String teamId) async {
    return getImageUrl('badges/$teamId.png');
  }

  Future<String?> getStadiumUrl(String stadiumId) async {
    return getImageUrl('stadiums/$stadiumId.jpg');
  }

  Future<String?> getPlayerImageUrl(String playerId) async {
    return getImageUrl('players/$playerId.jpg');
  }

  Future<String?> getSilhouetteUrl(String playerId) async {
    return getImageUrl('silhouettes/$playerId.png');
  }

  Future<String?> getCompetitionImageUrl(String competitionId) async {
    return getImageUrl('competitions/$competitionId.png');
  }
}
