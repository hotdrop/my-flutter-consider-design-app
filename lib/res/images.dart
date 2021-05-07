class Images {
  Images._({required String rootPath})
      : startImage = '$rootPath/start.png',
        homePointCard = '$rootPath/home_card.png';

  factory Images.createCoffee() {
    return Images._(rootPath: 'assets/app_coffee_images');
  }

  factory Images.createTea() {
    return Images._(rootPath: 'assets/app_tea_images');
  }

  final String startImage;
  final String homePointCard;
}
