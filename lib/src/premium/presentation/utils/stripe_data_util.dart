import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoircanvas/core/services/injection_container.dart';

class StripeDataUtils {
  const StripeDataUtils._();

  static Future<StripeData> fetchStripeData() async {
    var ds = await sl<FirebaseFirestore>()
        .collection('stripe_data')
        .doc('2srpddiqmi8GMA4CUTqA')
        .get();

    return StripeData(
      sub1priceId: ds.get(
        'sub1priceId',
      ),
      sub2priceId: ds.get(
        'sub2priceId',
      ),
    );
  }
}

class StripeData {
  String sub1priceId;
  String sub2priceId;

  StripeData({
    required this.sub1priceId,
    required this.sub2priceId,
  });
}
