class Subscription {
  String plan;
  DateTime purchasedTill;
  String channel;
  Remaining remaining;
  DateTime updatedAt;

  Subscription({
    required this.plan,
    required this.purchasedTill,
    required this.channel,
    required this.remaining,
    required this.updatedAt,
  });

  // Convert Subscription object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'purchased_till': purchasedTill.toIso8601String(),
      'channel': channel,
      'remaining': remaining.toJson(), // Convert Remaining to JSON
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Factory method to create Subscription object from JSON map
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      plan: json['plan'],
      purchasedTill: DateTime.parse(json['purchased_till']),
      channel: json['channel'],
      remaining: Remaining.fromJson(json['remaining']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Remaining {
  int y;
  int m;
  int d;
  int h;
  int i;
  int s;
  double f;
  int invert;
  bool days;
  bool fromString;

  Remaining({
    required this.y,
    required this.m,
    required this.d,
    required this.h,
    required this.i,
    required this.s,
    required this.f,
    required this.invert,
    required this.days,
    required this.fromString,
  });

  // Convert Remaining object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'y': y,
      'm': m,
      'd': d,
      'h': h,
      'i': i,
      's': s,
      'f': f,
      'invert': invert,
      'days': days,
      'from_string': fromString,
    };
  }

  factory Remaining.fromJson(Map<String, dynamic> json) {
    return Remaining(
      y: json['y'],
      m: json['m'],
      d: json['d'],
      h: json['h'],
      i: json['i'],
      s: json['s'],
      f: json['f'],
      invert: json['invert'],
      days: json['days'],
      fromString: json['from_string'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String city;
  final String state;
  final String code; // Change type to String
  final int status;
  final Subscription? subscription;
  final int isAwarded;
  final int isCodeValid;
  final DateTime createdAt;

  static User? _instance; // Singleton instance variable

  // Private constructor
  User._({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.city,
    required this.state,
    required this.code,
    required this.status,
    required this.subscription,
    required this.isAwarded,
    required this.isCodeValid,
    required this.createdAt,
  });

  // Factory constructor to get or create the singleton instance
  factory User({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String photo,
    required String city,
    required String state,
    required String code,
    required int status,
    required Subscription? subscription,
    required int isAwarded,
    required int isCodeValid,
    required DateTime createdAt,
  }) {
    _instance ??= User._(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photo: photo,
      city: city,
      state: state,
      code: code,
      status: status,
      subscription: subscription,
      isAwarded: isAwarded,
      isCodeValid: isCodeValid,
      createdAt: createdAt,
    );
    return _instance!;
  }

  // Method to get the singleton instance
  static User get instance => _instance!;

  // Method to reset the singleton instance (useful for testing or other purposes)
  static void reset() => _instance = null;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'] ?? "",
      city: json['city'],
      state: json['state'],
      code: json['code'], // Assuming 'code' is already changed to String
      status: json['status'],
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      isAwarded: json['is_awarded'],
      isCodeValid: json['is_code_valid'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'city': city,
      'state': state,
      'code': code,
      'status': status,
      'subscription': subscription?.toJson(),
      'is_awarded': isAwarded,
      'is_code_valid': isCodeValid,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
