class ApiVoid {
  const ApiVoid();

  factory ApiVoid.fromJson(Map<String, dynamic> json) => const ApiVoid();

  Map<String, dynamic> toJson() => const {};
}

class AddCustomerAddressRequest {
  const AddCustomerAddressRequest({
    required this.userId,
    this.addressType,
    this.fullName,
    this.mobileNumber,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.isDefault,
  });

  final String userId;
  final String? addressType;
  final String? fullName;
  final String? mobileNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final bool isDefault;

  factory AddCustomerAddressRequest.fromJson(Map<String, dynamic> json) =>
      AddCustomerAddressRequest(
        userId: (json['userId'] ?? '').toString(),
        addressType: json['addressType']?.toString(),
        fullName: json['fullName']?.toString(),
        mobileNumber: json['mobileNumber']?.toString(),
        addressLine1: json['addressLine1']?.toString(),
        addressLine2: json['addressLine2']?.toString(),
        landmark: json['landmark']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        postalCode: json['postalCode']?.toString(),
        country: json['country']?.toString(),
        isDefault: json['isDefault'] ?? false,
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'addressType': addressType,
    'fullName': fullName,
    'mobileNumber': mobileNumber,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
    'isDefault': isDefault,
  };
}

class AddProductReviewRequest {
  const AddProductReviewRequest({
    required this.userId,
    required this.productId,
    required this.rating,
    this.reviewTitle,
    this.reviewText,
  });

  final String userId;
  final String productId;
  final int rating;
  final String? reviewTitle;
  final String? reviewText;

  factory AddProductReviewRequest.fromJson(Map<String, dynamic> json) =>
      AddProductReviewRequest(
        userId: (json['userId'] ?? '').toString(),
        productId: (json['productId'] ?? '').toString(),
        rating: (json['rating'] ?? 0) as int,
        reviewTitle: json['reviewTitle']?.toString(),
        reviewText: json['reviewText']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'productId': productId,
    'rating': rating,
    'reviewTitle': reviewTitle,
    'reviewText': reviewText,
  };
}

class AddToCartRequest {
  const AddToCartRequest({
    required this.userId,
    required this.variantId,
    required this.quantity,
  });

  final String userId;
  final String variantId;
  final int quantity;

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      AddToCartRequest(
        userId: (json['userId'] ?? '').toString(),
        variantId: (json['variantId'] ?? '').toString(),
        quantity: (json['quantity'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'variantId': variantId,
    'quantity': quantity,
  };
}

class CheckoutRequest {
  const CheckoutRequest({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.notes,
  });

  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? notes;

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      CheckoutRequest(
        userId: (json['userId'] ?? '').toString(),
        fullName: json['fullName']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        addressLine1: json['addressLine1']?.toString(),
        addressLine2: json['addressLine2']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        postalCode: json['postalCode']?.toString(),
        country: json['country']?.toString(),
        notes: json['notes']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
    'notes': notes,
  };
}

class CreateCategoryRequest {
  const CreateCategoryRequest({this.categoryName, this.description});

  final String? categoryName;
  final String? description;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      CreateCategoryRequest(
        categoryName: json['categoryName']?.toString(),
        description: json['description']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'description': description,
  };
}

class CreateOrderRequest {
  const CreateOrderRequest({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.notes,
  });

  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? notes;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      CreateOrderRequest(
        userId: (json['userId'] ?? '').toString(),
        fullName: json['fullName']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        addressLine1: json['addressLine1']?.toString(),
        addressLine2: json['addressLine2']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        postalCode: json['postalCode']?.toString(),
        country: json['country']?.toString(),
        notes: json['notes']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
    'notes': notes,
  };
}

class CreateProductRequest {
  const CreateProductRequest({
    required this.subcategoryId,
    this.productName,
    this.description,
    this.brand,
  });

  final String subcategoryId;
  final String? productName;
  final String? description;
  final String? brand;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      CreateProductRequest(
        subcategoryId: (json['subcategoryId'] ?? '').toString(),
        productName: json['productName']?.toString(),
        description: json['description']?.toString(),
        brand: json['brand']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'subcategoryId': subcategoryId,
    'productName': productName,
    'description': description,
    'brand': brand,
  };
}

class CreateProductVariantRequest {
  const CreateProductVariantRequest({
    this.sku,
    this.variantName,
    this.sizeMl,
    required this.mrp,
    required this.sellingPrice,
    this.barcode,
  });

  final String? sku;
  final String? variantName;
  final int? sizeMl;
  final double mrp;
  final double sellingPrice;
  final String? barcode;

  factory CreateProductVariantRequest.fromJson(Map<String, dynamic> json) =>
      CreateProductVariantRequest(
        sku: json['sku']?.toString(),
        variantName: json['variantName']?.toString(),
        sizeMl: json['sizeMl'] as int?,
        mrp: (json['mrp'] ?? 0).toDouble(),
        sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
        barcode: json['barcode']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'sku': sku,
    'variantName': variantName,
    'sizeMl': sizeMl,
    'mrp': mrp,
    'sellingPrice': sellingPrice,
    'barcode': barcode,
  };
}

class CreateSubcategoryRequest {
  const CreateSubcategoryRequest({this.subcategoryName, this.description});

  final String? subcategoryName;
  final String? description;

  factory CreateSubcategoryRequest.fromJson(Map<String, dynamic> json) =>
      CreateSubcategoryRequest(
        subcategoryName: json['subcategoryName']?.toString(),
        description: json['description']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'subcategoryName': subcategoryName,
    'description': description,
  };
}

class CustomerOrderHistoryRequest {
  const CustomerOrderHistoryRequest({
    required this.userId,
    required this.pageNumber,
    required this.pageSize,
  });

  final String userId;
  final int pageNumber;
  final int pageSize;

  factory CustomerOrderHistoryRequest.fromJson(Map<String, dynamic> json) =>
      CustomerOrderHistoryRequest(
        userId: (json['userId'] ?? '').toString(),
        pageNumber: (json['pageNumber'] ?? 0) as int,
        pageSize: (json['pageSize'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
  };
}

class SendOtpRequest {
  const SendOtpRequest({this.mobileNumber, this.purpose});

  final String? mobileNumber;
  final String? purpose;

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) => SendOtpRequest(
    mobileNumber: json['mobileNumber']?.toString(),
    purpose: json['purpose']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'purpose': purpose,
  };
}

class UpdateCartItemQuantityRequest {
  const UpdateCartItemQuantityRequest({
    required this.userId,
    required this.quantity,
  });

  final String userId;
  final int quantity;

  factory UpdateCartItemQuantityRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCartItemQuantityRequest(
        userId: (json['userId'] ?? '').toString(),
        quantity: (json['quantity'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {'userId': userId, 'quantity': quantity};
}

class UpdateInventoryRequest {
  const UpdateInventoryRequest({
    required this.totalStock,
    required this.reorderLevel,
  });

  final int totalStock;
  final int reorderLevel;

  factory UpdateInventoryRequest.fromJson(Map<String, dynamic> json) =>
      UpdateInventoryRequest(
        totalStock: (json['totalStock'] ?? 0) as int,
        reorderLevel: (json['reorderLevel'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
    'totalStock': totalStock,
    'reorderLevel': reorderLevel,
  };
}

class UpdateOrderStatusRequest {
  const UpdateOrderStatusRequest({this.status});

  final String? status;

  factory UpdateOrderStatusRequest.fromJson(Map<String, dynamic> json) =>
      UpdateOrderStatusRequest(status: json['status']?.toString());

  Map<String, dynamic> toJson() => {'status': status};
}

class VerifyOtpRequest {
  const VerifyOtpRequest({this.mobileNumber, this.otpCode});

  final String? mobileNumber;
  final String? otpCode;

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequest(
        mobileNumber: json['mobileNumber']?.toString(),
        otpCode: json['otpCode']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'otpCode': otpCode,
  };
}

class VerifyPaymentRequest {
  const VerifyPaymentRequest({
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
  });

  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;

  factory VerifyPaymentRequest.fromJson(Map<String, dynamic> json) =>
      VerifyPaymentRequest(
        razorpayOrderId: json['razorpayOrderId']?.toString(),
        razorpayPaymentId: json['razorpayPaymentId']?.toString(),
        razorpaySignature: json['razorpaySignature']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'razorpayOrderId': razorpayOrderId,
    'razorpayPaymentId': razorpayPaymentId,
    'razorpaySignature': razorpaySignature,
  };
}
