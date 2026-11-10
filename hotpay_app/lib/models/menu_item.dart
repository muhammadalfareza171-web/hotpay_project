class MenuItem {
  final String id;
  final String name;
  final String category;
  final String subCategory;
  final String description;
  final String fullDescription;
  final int price;
  final int availablePortions;
  final double rating;
  final String temperature;
  final bool isAvailable;
  final String imageAsset;
  final String portionWeight;
  final String cookTime;
  final String hygieneSpec;
  final String noticeText;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    this.subCategory = 'Makanan Berat • Siap Saji Otomatis',
    required this.description,
    required this.fullDescription,
    required this.price,
    required this.availablePortions,
    required this.rating,
    this.temperature = '85°C',
    this.isAvailable = true,
    required this.imageAsset,
    this.portionWeight = '1 Mangkok (350g)',
    this.cookTime = '< 3 Menit Otomatis',
    this.hygieneSpec = 'Food Grade 100°C',
    this.noticeText = 'Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser kios setelah konfirmasi.',
  });

  static List<MenuItem> get sampleMenuItems => [
    const MenuItem(
      id: 'm1',
      name: 'Mie Tarempa Seafood',
      category: 'Makanan Berat',
      subCategory: 'Makanan Berat • Siap Saji Otomatis',
      description: 'Mie kuning pipih bertekstur kenyal dengan topping seafood',
      fullDescription: 'Mie pipih kenyal khas Kepulauan Riau yang ditumis rempah cabe pedas manis gurih, dengan topping seafood segar pilihan, telur orak-arik, dan taburan bawang goreng renyah aromatik.',
      price: 28000,
      availablePortions: 12,
      rating: 4.8,
      temperature: '85°C',
      isAvailable: true,
      imageAsset: 'assets/images/mie tarempa seafood.jpg',
      portionWeight: '1 Mangkok (350g)',
      cookTime: '< 3 Menit Otomatis',
      hygieneSpec: 'Food Grade 100°C',
      noticeText: 'Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser kios setelah konfirmasi.',
    ),
    const MenuItem(
      id: 'm2',
      name: 'Mie Tarempa Ayam',
      category: 'Makanan Berat',
      subCategory: 'Makanan Berat • Siap Saji Otomatis',
      description: 'Mie kuning pipih bertekstur kenyal dengan topping ayam',
      fullDescription: 'Mie kuning pipih kenyal khas Kepulauan Riau berpadu dengan bumbu rempah aromatik pedas gurih, dilengkapi suwiran ayam lezat dan sayuran segar.',
      price: 25000,
      availablePortions: 12,
      rating: 4.8,
      temperature: '85°C',
      isAvailable: true,
      imageAsset: 'assets/images/mie tarempa ayam.jpg',
      portionWeight: '1 Mangkok (350g)',
      cookTime: '< 3 Menit Otomatis',
      hygieneSpec: 'Food Grade 100°C',
      noticeText: 'Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser kios setelah konfirmasi.',
    ),
    const MenuItem(
      id: 'm3',
      name: 'Mie Sagu',
      category: 'Makanan Berat',
      subCategory: 'Makanan Berat • Siap Saji Otomatis',
      description: 'Mie sagu kenyal khas dengan kaldu gurih dan bumbu rempah.',
      fullDescription: 'Mie sagu kenyal khas Kepulauan Riau yang diolah dari pati sagu murni pilihan, disajikan dengan kaldu ayam kampung gurih berrempah aromatik, suwiran ayam empuk, telur rebus, dan taburan seledri serta bawang goreng renyah.',
      price: 18000,
      availablePortions: 12,
      rating: 4.8,
      temperature: '85°C',
      isAvailable: true,
      imageAsset: 'assets/images/mie sagu.jpg',
      portionWeight: '1 Mangkok (350g)',
      cookTime: '< 3 Menit Otomatis',
      hygieneSpec: 'Food Grade 100°C',
      noticeText: 'Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser kios setelah konfirmasi.',
    ),
    const MenuItem(
      id: 'm4',
      name: 'Luti Gendang Ikan',
      category: 'Camilan',
      subCategory: 'Camilan • Box Isi 4 Pcs',
      description: 'Roti dengan isian abon ikan berisi 4pcs',
      fullDescription: 'Roti goreng khas Anambas dengan tekstur renyah di luar dan lembut di dalam, berisi abon ikan tongkol gurih berbumbu rempah pedas manis. Disajikan dalam box higienis isi 4 pcs.',
      price: 16000,
      availablePortions: 5,
      rating: 4.7,
      temperature: '80°C',
      isAvailable: true,
      imageAsset: 'assets/images/luti gendang ikan.jpg',
      portionWeight: '1 Box Isi 4 Pcs (240g)',
      cookTime: '< 2 Menit Cepat',
      hygieneSpec: 'Eco Box Food Grade',
      noticeText: 'Camilan siap ambil dalam kemasan box tertutup rapat dari modul dispenser kios setelah konfirmasi.',
    ),
    const MenuItem(
      id: 'm5',
      name: 'Luti Gendang Ayam',
      category: 'Camilan',
      subCategory: 'Camilan • Box Isi 4 Pcs',
      description: 'Roti dengan isian abon ayam berisi 4pcs',
      fullDescription: 'Roti goreng khas Anambas dengan tekstur renyah di luar dan lembut di dalam, berisi abon ayam gurih berbumbu rempah pedas manis. Disajikan dalam box higienis isi 4 pcs.',
      price: 10000,
      availablePortions: 5,
      rating: 4.7,
      temperature: '80°C',
      isAvailable: true,
      imageAsset: 'assets/images/luti gendang ayam.jpg',
      portionWeight: '1 Box Isi 4 Pcs (240g)',
      cookTime: '< 2 Menit Cepat',
      hygieneSpec: 'Eco Box Food Grade',
      noticeText: 'Camilan siap ambil dalam kemasan box tertutup rapat dari modul dispenser kios setelah konfirmasi.',
    ),
    const MenuItem(
      id: 'm6',
      name: 'Mie Tarempa Ori',
      category: 'Makanan Berat',
      subCategory: 'Makanan Berat • Siap Saji Otomatis',
      description: 'Mie kuning pipih bertekstur kenyal khas Kepulauan Riau',
      fullDescription: 'Mie kuning pipih bertekstur kenyal khas Kepulauan Riau ditumis dengan bumbu original rempah khas Melayu.',
      price: 20000,
      availablePortions: 0,
      rating: 4.9,
      temperature: '85°C',
      isAvailable: false,
      imageAsset: 'assets/images/mie tarempa ori.jpg',
      portionWeight: '1 Mangkok (350g)',
      cookTime: '< 3 Menit Otomatis',
      hygieneSpec: 'Food Grade 100°C',
      noticeText: 'Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser kios setelah konfirmasi.',
    ),
  ];
}
