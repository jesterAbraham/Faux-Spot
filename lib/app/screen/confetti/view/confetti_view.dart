import 'package:confetti/confetti.dart';
import 'package:faux_spot/app/core/colors.dart';
import 'package:faux_spot/app/screen/confetti/view_model/confetti_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfettiView extends StatelessWidget {
  const ConfettiView({super.key});

  @override
  Widget build(BuildContext context) {
    ConfettiProvider provider = context.read<ConfettiProvider>();
    provider.controller.play();
    return
        // Scaffold(
        //   backgroundColor: primaryColor,
        //   body: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         const Text(
        //           'Payment Processing...',
        //           style: TextStyle(
        //             color: whiteColor,
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold,
        //             letterSpacing: 1.5,
        //           ),
        //         ),
        //         Lottie.asset(
        //           loadingAnimation,
        //           height: 130,
        //           width: 200,
        //         ),
        //       ],
        //     ),
        //   ),
        // );

      ColoredBox(
      color: primaryColor,
      child: ConfettiWidget(
        strokeColor: primaryColor,
        blastDirectionality: BlastDirectionality.directional,
        shouldLoop: true,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          whiteColor,
        ],
        confettiController: provider.controller,
      ),
    );
  }
}