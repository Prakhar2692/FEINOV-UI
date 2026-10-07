enum PaymentMethodType { upi, card, wallet, netbanking }

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.last4,
    this.isDefault = false,
  });

  final String id;
  final PaymentMethodType type;
  final String title;
  final String? subtitle;
  final String? last4;
  final bool isDefault;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    final type = switch ((json['type'] ?? 'card').toString()) {
      'upi' => PaymentMethodType.upi,
      'wallet' => PaymentMethodType.wallet,
      'netbanking' => PaymentMethodType.netbanking,
      _ => PaymentMethodType.card,
    };

    return PaymentMethod(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      type: type,
      title: (json['title'] ?? json['name'] ?? 'Payment method').toString(),
      subtitle: json['subtitle']?.toString(),
      last4: json['last4']?.toString(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  String get maskedDisplay {
    if (type == PaymentMethodType.card && last4 != null && last4!.isNotEmpty) {
      final label = title
          .replaceAll(RegExp(r' ending in .*', caseSensitive: false), '')
          .trim();
      return '$label •••• $last4';
    }
    return title;
  }

  bool get isCard => type == PaymentMethodType.card;
  bool get isUpi => type == PaymentMethodType.upi;
  bool get isWallet => type == PaymentMethodType.wallet;
}

class PaymentInitiationRequest {
  const PaymentInitiationRequest({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.customerName,
    required this.email,
    required this.contact,
    this.paymentMethod,
  });

  final String orderId;
  final double amount;
  final String currency;
  final String customerName;
  final String email;
  final String contact;
  final String? paymentMethod;

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'amount': amount,
    'currency': currency,
    'customerName': customerName,
    'email': email,
    'contact': contact,
    'paymentMethod': paymentMethod,
  };
}

class PaymentInitiationResult {
  const PaymentInitiationResult({
    required this.paymentId,
    required this.status,
    this.message,
    this.redirectUrl,
    this.orderId,
  });

  final String paymentId;
  final String status;
  final String? message;
  final String? redirectUrl;
  final String? orderId;

  factory PaymentInitiationResult.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationResult(
      paymentId: (json['paymentId'] ?? json['id'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      message: json['message']?.toString(),
      redirectUrl: json['redirectUrl']?.toString(),
      orderId: json['orderId']?.toString(),
    );
  }
}

class PaymentVerificationRequest {
  const PaymentVerificationRequest({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  final String paymentId;
  final String orderId;
  final String signature;

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'orderId': orderId,
    'signature': signature,
  };
}

class PaymentVerificationResult {
  const PaymentVerificationResult({
    required this.isSuccessful,
    required this.status,
    this.message,
  });

  final bool isSuccessful;
  final String status;
  final String? message;

  factory PaymentVerificationResult.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResult(
      isSuccessful: json['isSuccessful'] ?? json['success'] ?? false,
      status: (json['status'] ?? 'failed').toString(),
      message: json['message']?.toString(),
    );
  }
}
