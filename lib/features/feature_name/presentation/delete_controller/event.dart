class DeleteEvents {}

class DeleteStartEvens extends DeleteEvents {
  final int index;
  final num id;

  DeleteStartEvens({required this.index, required this.id});
}
