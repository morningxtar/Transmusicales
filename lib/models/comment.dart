class CommentArtist{

  String contenu;
  String? pseudo;
  String id;
  DateTime writtenDate = DateTime.now();

  CommentArtist({
    this.contenu = '',
    this.pseudo = '',
    this.id = '',
  });

  @override
  String toString() {
    return 'pseudo: ' + pseudo! + ' | contenu: ' + contenu + ' | urlPhoto: ' + id + ' | writtenDate: ' + writtenDate.toString();
  }
}