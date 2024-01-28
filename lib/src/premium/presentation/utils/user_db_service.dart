import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:memoircanvas/core/services/injection_container.dart';
import 'package:memoircanvas/src/premium/presentation/utils/stripe_data_util.dart';

class UserDbService {
  final String uid;
  final StripeData? stripeData;

  UserDbService({required this.uid, required this.stripeData});

  Stream<SubscriptionStatus> get checkSubscriptionIsActive {
    return sl<FirebaseFirestore>()
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .snapshots()
        .map((event) => checkUserHaveActiveSubscription(
              event,
            ));
  }

  SubscriptionStatus checkUserHaveActiveSubscription(
    QuerySnapshot qs,
  ) {
    for (var ds in qs.docs) {
      var data = ds.data() as Map<String, dynamic>;
      var status = data['status'];
      if (status == 'active') {
        DocumentReference priceDocRef = data['price'];
        String currentPriceId = '';

        if (priceDocRef.id.contains(stripeData!.sub2priceId)) {
          currentPriceId = stripeData!.sub2priceId;
        } else if (priceDocRef.id.contains(stripeData!.sub1priceId)) {
          currentPriceId = stripeData!.sub1priceId;
        }
        return SubscriptionStatus(
            subIsActive: true, status: status, activePriceId: currentPriceId);
      }
    }

    return SubscriptionStatus(
        subIsActive: false, status: '', activePriceId: '');
  }
}

class SubscriptionStatus {
  bool subIsActive;
  String status;
  String activePriceId;
  SubscriptionStatus({
    required this.subIsActive,
    required this.status,
    required this.activePriceId,
  });
}
