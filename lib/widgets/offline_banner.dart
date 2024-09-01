import 'package:flutter/material.dart';
import 'package:basic_app/services/connectivity_service.dart';
import 'package:provider/provider.dart' as provider;

class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: provider.Consumer<ConnectivityService>(
              builder: (context, connectivityService, _) {
                if (!connectivityService.isOffline) {
                  return SizedBox.shrink();
                }
                return Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Offline',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}