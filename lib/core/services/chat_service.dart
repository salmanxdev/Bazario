import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  Future<String> getOrCreateChatRoom(String sellerId) async {
    final roomId = _getRoomId(_currentUserId, sellerId);
    final roomDoc = await _firestore.collection('chat_rooms').doc(roomId).get();

    if (!roomDoc.exists) {
      await _firestore.collection('chat_rooms').doc(roomId).set({
        'participants': [_currentUserId, sellerId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }
    return roomId;
  }

  String _getRoomId(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort();
    return ids.join('_');
  }

  Stream<List<Message>> getMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String roomId, String text) async {
    if (text.trim().isEmpty) return;

    final message = Message(
      id: '',
      senderId: _currentUserId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toMap());

    await _firestore.collection('chat_rooms').doc(roomId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getChatRooms() {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: _currentUserId)
        .snapshots();
  }
}
