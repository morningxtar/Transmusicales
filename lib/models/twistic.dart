class Twistic{

  String contenu;
  String pseudo;
  String urlPhoto;
  DateTime writtenDate = DateTime.now();

  Twistic({
    this.contenu = '',
    this.pseudo = '',
    this.urlPhoto = '',
  });

  @override
  String toString() {
    return 'pseudo: ' + pseudo + ' | contenu: ' + contenu + ' | urlPhoto: ' + urlPhoto + ' | writtenDate: ' + writtenDate.toString();
  }
}