String getconversationIdHash(String user1, String user2) {
  return user1.hashCode <= user2.hashCode
      ? '${user1}_$user2'
      : '${user2}_$user1';
}
