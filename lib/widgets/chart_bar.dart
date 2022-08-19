import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  // for the week day
  final double spending;
  // for the amount on that week day

  final double spendingPercent;
  // this will provide the ratio of spending

  ChartBar(
      {required this.label,
      required this.spending,
      required this.spendingPercent});

  @override
  Widget build(BuildContext ctx) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          children: [
            Container(
              height: constraint.maxHeight * 0.15,
              // this was used, as when the text shrank, it took the bar up with it
              child: FittedBox(
                child: Text('Rs.${spending.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(height: constraint.maxHeight * 0.05),
            Container(
              height: constraint.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // in order to get the illusion of a box filling up,
                  // we can use a partially filled container over the above
                  //mentioned base container
                  FractionallySizedBox(
                    heightFactor: spendingPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // height factor takes value between 0,1
                  // this allows to be sized as a fraction of another value
                ],
              ),
            ),
            //container is the partially filled box, i.e. bar
            SizedBox(height: constraint.maxHeight * 0.05),
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
