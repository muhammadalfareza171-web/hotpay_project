class MenuItem {
  final String id, name, desc, category, time, portion, pack;
  final int price, stock;
  final double rating;

  const MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.stock,
    required this.rating,
    this.time = '< 3 Menit',
    this.portion = '1 Mangkok (350g)',
    this.pack = 'Food Grade 100°C',
  });

  bool get soldOut => stock == 0;
  String get image => 'assets/images/$id.jpg';
}

String rp(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

const menus = <MenuItem>[
  MenuItem(id: 'mie_tarempa_seafood', name: 'Mie Tarempa Seafood', category: 'Makanan Berat', price: 28000, stock: 12, rating: 4.8,
      desc: 'Mie kuning pipih berbahan rempah dengan topping seafood segar, telur orak-arik, dan taburan bawang goreng renyah aromatik.'),
  MenuItem(id: 'mie_tarempa_ayam', name: 'Mie Tarempa Ayam', category: 'Makanan Berat', price: 25000, stock: 8, rating: 4.8,
      desc: 'Mie pipih kenyal khas Kepulauan Riau yang ditumis rempah cabe pedas manis gurih, dengan topping suwiran ayam pilihan.'),
  MenuItem(id: 'mie_sagu', name: 'Mie Sagu', category: 'Makanan Berat', price: 18000, stock: 12, rating: 4.8,
      desc: 'Mie sagu kenyal khas kepulauan yang diolah dari pati sagu murni pilihan, disajikan dengan kuah kaldu ayam kampung gurih.'),
  MenuItem(id: 'luti_gendang_ikan', name: 'Luti Gendang Ikan', category: 'Camilan', price: 16000, stock: 8, rating: 4.7,
      time: '< 2 Menit Cepat', portion: '1 Box Isi 4 Pcs (240g)', pack: 'Eco Box Food Grade',
      desc: 'Roti goreng khas Anambas dengan tekstur renyah di luar dan lembut di dalam, berisi abon ikan tongkol gurih berbumbu rempah.'),
  MenuItem(id: 'luti_gendang_ayam', name: 'Luti Gendang Ayam', category: 'Camilan', price: 10000, stock: 6, rating: 4.7,
      time: '< 2 Menit Cepat', portion: '1 Box Isi 4 Pcs (240g)', pack: 'Eco Box Food Grade',
      desc: 'Roti goreng khas Anambas dengan tekstur renyah di luar dan lembut di dalam, berisi abon ayam gurih berbumbu rempah manis.'),
  MenuItem(id: 'mie_tarempa_ori', name: 'Mie Tarempa Ori', category: 'Makanan Berat', price: 20000, stock: 0, rating: 4.5,
      desc: 'Mie tarempa original dengan bumbu rempah khas Kepulauan Riau.'),
];
