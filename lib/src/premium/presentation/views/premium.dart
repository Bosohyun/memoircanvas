import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/services/injection_container.dart';
import 'package:memoircanvas/src/premium/presentation/utils/checkout_page.dart';
import 'package:memoircanvas/src/premium/presentation/utils/stripe_data_util.dart';
import 'package:memoircanvas/src/premium/presentation/utils/user_db_service.dart';
import 'package:memoircanvas/src/premium/presentation/views/customer_portal.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  static const routeName = '/premium';

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  late StripeData stripeData;
  late SubscriptionStatus subscriptionStatus;
  bool loadingPayment = false;
  loading(String msg) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StripeDataUtils.fetchStripeData(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return loading('Loading Stripe Data...');
        }

        stripeData = snapshot.data!;

        if (loadingPayment) return loading('Processing payment...');

        return StreamBuilder<SubscriptionStatus>(
            stream: UserDbService(
              uid: context.userProvider.user!.uid,
              stripeData: stripeData,
            ).checkSubscriptionIsActive,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return loading('Checking Subscription Data...');
              }

              subscriptionStatus = snapshot.data!;

              return Scaffold(
                backgroundColor: context.theme.colorScheme.background,
                appBar: AppBar(
                  title: Text(
                    'Premium',
                    style: context.theme.textTheme.displayLarge,
                  ),
                  leading: const NestedBackButton(),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (subscriptionStatus.subIsActive == false ||
                            (subscriptionStatus.subIsActive &&
                                subscriptionStatus.activePriceId ==
                                    stripeData.sub1priceId))
                          monthlySubTile(),
                        const SizedBox(
                          height: 15,
                        ),
                        if (subscriptionStatus.subIsActive == false ||
                            (subscriptionStatus.subIsActive &&
                                subscriptionStatus.activePriceId ==
                                    stripeData.sub2priceId))
                          yearlySubTile(),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  monthlySubTile() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 74, 109, 167),
        borderRadius: BorderRadius.circular(
          10,
        ),
        //shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        width: 330.0,
        height: 290.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Monthly Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '\$1.99/month',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'No commitment, cancel anytime.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Continuing A.I-Generated Image Journaling Access',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (subscriptionStatus.subIsActive == false)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 74, 109, 167),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    loadingPayment = true;
                  });

                  if (context.mounted) {
                    DocumentReference docRef = await sl<FirebaseFirestore>()
                        .collection('users')
                        .doc(context.userProvider.user!.uid)
                        .collection('checkout_sessions')
                        .add({
                      'price': stripeData.sub1priceId,
                      'success_url': 'https://success.com',
                      'cancel_url': 'https://cancel.com',
                    });

                    docRef.snapshots().listen(
                      (snapshot) async {
                        if (snapshot.data() != null) {
                          var data = snapshot.data() as Map<String, dynamic>;

                          var error;
                          try {
                            error = data['error'];
                          } catch (e) {
                            error = null;
                          }

                          if (error != null) {
                            setState(() {
                              loadingPayment = false;
                            });
                          } else {
                            var url = data['url'];

                            if (url != null) {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutPage(url: url)));
                              if (res == 'success') {
                                setState(() {
                                  loadingPayment = false;
                                });
                              } else {
                                setState(() {
                                  loadingPayment = false;
                                });
                              }
                            }
                          }
                        }
                      },
                    );
                  }
                },
                child: const Text(
                  'Choose Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (subscriptionStatus.subIsActive)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 74, 109, 167),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    customerPortal();
                  },
                  child: const Text(
                    'Manage Subscription',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '1 Month Auto Renewal Subscription Plan',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  yearlySubTile() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10,
        ),
        //shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        width: 330.0,
        height: 290.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Yearly Plan',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '\$20.00/year',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'No commitment, cancel anytime.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Continuing A.I-Generated Image Journaling Access',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (subscriptionStatus.subIsActive == false)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 74, 109, 167),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    loadingPayment = true;
                  });

                  if (context.mounted) {
                    DocumentReference docRef = await sl<FirebaseFirestore>()
                        .collection('users')
                        .doc(context.userProvider.user!.uid)
                        .collection('checkout_sessions')
                        .add({
                      'price': stripeData.sub2priceId,
                      'success_url': 'https://success.com',
                      'cancel_url': 'https://cancel.com',
                    });

                    docRef.snapshots().listen(
                      (snapshot) async {
                        if (snapshot.data() != null) {
                          var data = snapshot.data() as Map<String, dynamic>;

                          var error;
                          try {
                            error = data['error'];
                          } catch (e) {
                            error = null;
                          }

                          if (error != null) {
                            setState(() {
                              loadingPayment = false;
                            });
                          } else {
                            var url = data['url'];

                            if (url != null) {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutPage(url: url)));
                              if (res == 'success') {
                                setState(() {
                                  loadingPayment = false;
                                });
                              } else {
                                setState(() {
                                  loadingPayment = false;
                                });
                              }
                            }
                          }
                        }
                      },
                    );
                  }
                },
                child: const Text(
                  'Choose Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (subscriptionStatus.subIsActive)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 74, 109, 167),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    customerPortal();
                  },
                  child: const Text(
                    'Manage Subscription',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '1 Year Auto Renewal Subscription Plan',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  customerPortal() async {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('ext-firestore-stripe-payments-createPortalLink');

    HttpsCallableResult result =
        await callable.call({'returnUrl': 'https://cancel.com'});

    if (result.data != null) {
      var url = result.data['url'];

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerPortal(
              url: url,
            ),
          ),
        );
      }
    }
  }
}
