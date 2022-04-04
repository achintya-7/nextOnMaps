import 'dart:convert';

class MonumentsList {
 static List<Monument> monuments = [
    Monument(name: "Jaisalmer", url: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/View_from_Jaisalmer_fort.jpg/1200px-View_from_Jaisalmer_fort.jpg"),
    Monument(name: "Dehradun", url: "https://www.transindiatravels.com/wp-content/uploads/sahastradhara-1.jpg"),
    Monument(name: "Jaipur", url: "https://honestlywtf.com/wp-content/uploads/2020/01/india75.jpg"),  
    Monument(name: "Gulmarg", url: "https://static.toiimg.com/photo/81325157.cms"),
    Monument(name: "Bikaner", url: "https://thumbs.dreamstime.com/b/junagarh-fort-bikaner-rajasthan-north-india-was-originally-known-as-chintamani-renamed-old-148727596.jpg"),
    Monument(name: "Leh Ladakh", url: "https://www.holidify.com/images/cmsuploads/compressed/2999_20190305160539.jpg")

  ];
}

class Monument {
  String name;
  String url;

  Monument({
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory Monument.fromMap(Map<String, dynamic> map) {
    return Monument(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Monument.fromJson(String source) => Monument.fromMap(json.decode(source));
}
