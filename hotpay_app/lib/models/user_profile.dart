class UserProfile {
  String name;
  String id;
  String phone;
  String email;
  String initials;
  int totalOrders;
  String favoriteMenu;
  bool isEmailVerified;

  UserProfile({
    required this.name,
    required this.id,
    required this.phone,
    required this.email,
    required this.initials,
    this.totalOrders = 12,
    this.favoriteMenu = 'Mie Sagu',
    this.isEmailVerified = true,
  });

  static UserProfile get sampleUser => UserProfile(
    name: 'Ahmad Pratama',
    id: '#SB-98421',
    phone: '+62 812-xxxx-xxxx',
    email: 'ahmad@gmail.com',
    initials: 'AP',
    totalOrders: 12,
    favoriteMenu: 'Mie Sagu',
    isEmailVerified: true,
  );
}
