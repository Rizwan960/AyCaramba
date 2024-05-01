import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ay_caramba/Model/user_model.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionPayWallPage extends StatefulWidget {
  final bool showAppBar;
  const SubscriptionPayWallPage({super.key, required this.showAppBar});

  @override
  State<SubscriptionPayWallPage> createState() =>
      _SubscriptionPayWallPageState();
}

class _SubscriptionPayWallPageState extends State<SubscriptionPayWallPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool initialLoadig = false;
  bool upgrading = false;
  bool isClicked = false;

  bool gotYearly = false;

  ProductDetailsResponse yearlyProductDetail =
      ProductDetailsResponse(productDetails: [], notFoundIDs: []);
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<PurchaseDetails> _purchases = [];

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    handlePurchase();
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
      _purchases.addAll(purchaseDetailsList);
      //  _iap.restorePurchases();
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (mounted) {
          CommonData.showCustomSnackbar(context, 'Please wait');
        }
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (mounted) {
            CommonData.showCustomSnackbar(
                context, 'Un-expected error occurred');
          }
          setState(() {
            upgrading = false;
          });
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          if (mounted) {
            CommonData.showCustomSnackbar(context, 'Subscription is canceled');
          }
          setState(() {
            upgrading = false;
          });
          _purchases.removeWhere(
              (element) => element.productID == purchaseDetails.productID);
        } else if (purchaseDetails.productID == "monthly_subscription" &&
            purchaseDetails.status == PurchaseStatus.purchased) {
          await _verifyPurchase(purchaseDetails);
          return;
        }
      }
    }
  }

  User parseUser(dynamic jsonString) {
    return User.fromJson(jsonString);
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      Map<String, dynamic> data = {
        "purchase_token":
            purchaseDetails.verificationData.serverVerificationData,
        "purchase_id": Platform.isAndroid
            ? purchaseDetails.productID
            : purchaseDetails.purchaseID,
        "is_subscribed": purchaseDetails.productID == "monthly_subscription"
            ? "monthly"
            : "",
        "channel": Platform.isAndroid ? "play_store" : "app_store"
      };
      log(data.toString());
      Dio dio = await CommonData.createDioWithAuthHeader();
      Response response = await dio.post(AppApi.getSubscription, data: data);
      if (response.statusCode == 200) {
        log(response.data.toString());
        if (mounted) {
          final data = response.data["data"];
          User user = parseUser(data);
          User currentUser = User.instance;
          await AppSharefPrefHelper.setUserTocker(response.data["token"]);
          await AppSharefPrefHelper.saveUser(currentUser);
          currentUser = await AppSharefPrefHelper.getUser();
          CommonData.showCustomSnackbar(context, "Upgraded to pro");

          // showUpgradeDialog(context);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        setState(() {
          upgrading = false;
        });
        if (mounted) {
          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        log(e.response!.data['message'].toString());
        if (mounted) {
          setState(() {
            upgrading = false;
          });
          CommonData.sshowDialog('Error', e.response!.data['message'], context);
        }
      }
    }
    if (mounted) {
      setState(() {
        upgrading = false;
      });
    }
  }

  Future<void> fetchProductsForYearly() async {
    _purchases.clear();
    if (_isPurchased(yearlyProductDetail.productDetails.first.id)) {
      CommonData.showCustomSnackbar(context, 'Already Purchased');
      setState(() {
        upgrading = false;
      });
    } else {
      purchaseProduct(
        yearlyProductDetail.productDetails.first,
      );
    }
  }

  Future<void> purchaseProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    final purchaseDetailss = await _iap.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
    if (purchaseDetailss) {
    } else {
      if (mounted) {
        CommonData.showCustomSnackbar(context, "Transaction failed");
      }
    }
  }

  Future<void> handlePurchase() async {
    setState(() {
      initialLoadig = true;
    });
    yearlyProductDetail = await _iap.queryProductDetails({
      'monthly_subscription',
    });
    log(yearlyProductDetail.productDetails.toString());
    if (yearlyProductDetail.productDetails.isEmpty) {
      if (mounted) {
        CommonData.showCustomSnackbar(context, 'Error while fetching details');
        setState(() {
          upgrading = false;
          initialLoadig = false;
        });
      }
      return;
    } else if (yearlyProductDetail.productDetails.isNotEmpty) {
      setState(() {
        gotYearly = true;
      });
    }
    setState(() {
      initialLoadig = false;
      upgrading = false;
    });
  }

  bool _isPurchased(String productId) {
    return _purchases.any((purchase) =>
        purchase.productID == productId &&
            purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop("yes");
                },
                icon: const Icon(CupertinoIcons.back)),
            backgroundColor: AppColors.backgroundColor,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SvgPicture.asset("Assets/Svg/subscribe_to_monthly.svg"),
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        "Assets/Svg/subscription_box.svg",
                        height: 350,
                        width: double.infinity,
                      ),
                      const Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Icon(
                          CupertinoIcons.paperplane_fill,
                          color: AppColors.callToActionColor,
                          size: 60,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.callToActionColor,
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: () {
                        setState(() {
                          upgrading = true;
                        });
                        fetchProductsForYearly();
                      },
                      child: const Text(
                        "Pay Now",
                        style: AppFonts.normalWhite18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (initialLoadig || upgrading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SizedBox(
                height: 50,
                child: SpinKitFoldingCube(
                  color: AppColors.callToActionColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
