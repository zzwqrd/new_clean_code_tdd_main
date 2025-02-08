import 'package:flutter/material.dart';

int getCrossAxisCount(double width) {
  if (width < 576) {
    return 1;
  } else if (width < 768) {
    return 2;
  } else if (width < 992) {
    return 2;
  } else if (width < 1200) {
    return 3;
  } else {
    return 4;
  }
}

double getChildAspectRatio(double width) {
  if (width < 576) {
    return 1;
  } else if (width < 768) {
    return 1.5;
  } else if (width < 992) {
    return 1.5;
  } else if (width < 1200) {
    return 1.5;
  } else {
    return 1.5;
  }
}

Color getItemColor(double width) {
  if (width < 576) {
    return Colors.blue[100]!;
  } else if (width < 768) {
    return Colors.green[100]!;
  } else if (width < 992) {
    return Colors.yellow[100]!;
  } else if (width < 1200) {
    return Colors.orange[100]!;
  } else {
    return Colors.red[100]!;
  }
}

IconData getItemIcon(double width) {
  if (width < 576) {
    return Icons.phone_iphone;
  } else if (width < 768) {
    return Icons.phone_android;
  } else if (width < 992) {
    return Icons.tablet;
  } else if (width < 1200) {
    return Icons.desktop_windows;
  } else {
    return Icons.desktop_mac;
  }
}

double getIconSize(double width) {
  if (width < 576) {
    return 24;
  } else if (width < 768) {
    return 28;
  } else if (width < 992) {
    return 32;
  } else if (width < 1200) {
    return 36;
  } else {
    return 40;
  }
}

double getTextSize(double width) {
  if (width < 576) {
    return 14;
  } else if (width < 768) {
    return 16;
  } else if (width < 992) {
    return 18;
  } else if (width < 1200) {
    return 20;
  } else {
    return 22;
  }
}

// this is example
class ResponsiveGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = getCrossAxisCount(constraints.maxWidth);
        double childAspectRatio = getChildAspectRatio(constraints.maxWidth);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getItemColor(constraints.maxWidth),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getItemIcon(constraints.maxWidth),
                    size: getIconSize(constraints.maxWidth),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Item $index',
                    style:
                        TextStyle(fontSize: getTextSize(constraints.maxWidth)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
