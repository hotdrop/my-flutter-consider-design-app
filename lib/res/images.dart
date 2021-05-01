class Images {
  Images._({required String rootPath})
      : startImage = '$rootPath/start.png',
        homePointCard = '$rootPath/home_card.png';

  factory Images.createCoffee() {
    return Images._(rootPath: 'assets/app_coffee_images');
  }

  final String startImage;
  final String homePointCard;
}
