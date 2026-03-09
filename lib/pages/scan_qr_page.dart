import 'package:flutter/material.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _isNavigating = false;
  bool _isValidating = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _openMenu() {
    if (_isNavigating) return;
    _isNavigating = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ControllerPage()),
    );
  }

  Future<void> _handleBarcodeCapture(BarcodeCapture capture) async {
    if (_isNavigating || _isValidating) return;
    final rawValue = capture.barcodes
        .map((e) => e.rawValue?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');

    if (rawValue.isEmpty) return;
    debugPrint('[QR][RAW] $rawValue');

    _isValidating = true;
    final tableProvider = context.read<TableOrderProvider>();
    final valid = await tableProvider.validateAndSetTableCode(rawValue);
    debugPrint(
      '[QR][VALIDATION] valid=$valid tableCode=${tableProvider.tableCode} '
      'tableName=${tableProvider.tableName} error=${tableProvider.errorMessage}',
    );
    _isValidating = false;
    if (!mounted) return;

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tableProvider.errorMessage ?? 'Invalid table QR code'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await _scannerController.stop();
    if (!mounted) return;
    _openMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _handleBarcodeCapture,
            ),
          ),
          Center(
            child: IgnorePointer(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Stack(
                  children: [
                    _FrameCorner(top: 0, left: 0),
                    _FrameCorner(top: 0, right: 0),
                    _FrameCorner(bottom: 0, left: 0),
                    _FrameCorner(bottom: 0, right: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _openMenu,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameCorner extends StatelessWidget {
  const _FrameCorner({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: SizedBox(
        width: 36,
        height: 36,
        child: CustomPaint(
          painter: _CornerPainter(
            drawTop: top != null,
            drawBottom: bottom != null,
            drawLeft: left != null,
            drawRight: right != null,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.drawTop,
    required this.drawBottom,
    required this.drawLeft,
    required this.drawRight,
  });

  final bool drawTop;
  final bool drawBottom;
  final bool drawLeft;
  final bool drawRight;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 3.2;
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (drawTop) {
      path.moveTo(0, stroke / 2);
      path.lineTo(size.width, stroke / 2);
    }
    if (drawBottom) {
      path.moveTo(0, size.height - stroke / 2);
      path.lineTo(size.width, size.height - stroke / 2);
    }
    if (drawLeft) {
      path.moveTo(stroke / 2, 0);
      path.lineTo(stroke / 2, size.height);
    }
    if (drawRight) {
      path.moveTo(size.width - stroke / 2, 0);
      path.lineTo(size.width - stroke / 2, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) {
    return drawTop != oldDelegate.drawTop ||
        drawBottom != oldDelegate.drawBottom ||
        drawLeft != oldDelegate.drawLeft ||
        drawRight != oldDelegate.drawRight;
  }
}
