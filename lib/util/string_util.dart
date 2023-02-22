
bool isNotEmpty(String? text) {
  return !(text == null || text.isEmpty);
}
bool isEmpty(String? text) {
  return !isNotEmpty(text);
}