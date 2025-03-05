import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/core/utils/email_sender.dart'; // Import EmailSender
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/payment_success_view.dart';

class RoomDetailView extends StatefulWidget {
  final RoomEntity room;

  const RoomDetailView({super.key, required this.room});

  @override
  State<RoomDetailView> createState() => _RoomDetailViewState();
}

class _RoomDetailViewState extends State<RoomDetailView> {
  late String imageUrl;
  bool? isDarkMode;
  final TextEditingController _enquiryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imageUrl = widget.room.roomImage != null && widget.room.roomImage!.isNotEmpty
        ? '${ApiEndpoints.imageUrl}${widget.room.roomImage!.split(RegExp(r'[\\/]')).last}'
        : '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  void _initiatePayment() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
          secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
        ),
        esewaPayment: EsewaPayment(
          productId: widget.room.id!,
          productName: widget.room.roomDescription,
          productPrice: widget.room.rentPrice.toString(),
          callbackUrl: 'https://your-callback-url.com',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          _handlePaymentSuccess(result);
        },
        onPaymentFailure: (data) {
          _handlePaymentFailure(data);
        },
        onPaymentCancellation: (data) {
          _handlePaymentCancellation(data);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Error: $e')),
      );
    }
  }

  void _handlePaymentSuccess(EsewaPaymentSuccessResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessView(room: widget.room),
      ),
    );
  }

  void _handlePaymentFailure(dynamic data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: $data'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handlePaymentCancellation(dynamic data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Cancelled: $data'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _showEnquiryDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Make an Enquiry'),
          content: TextField(
            controller: _enquiryController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter your enquiry here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () async {
                if (_enquiryController.text.isNotEmpty) {
                  try {
                    await _sendEnquiryEmail();
                    Navigator.pop(dialogContext);
                    _showSnackBar(
                      message: 'Enquiry sent successfully!',
                      color: Colors.green,
                    );
                  } catch (e) {
                    _showSnackBar(
                      message: 'Failed to send enquiry: $e',
                      color: Colors.red,
                    );
                  }
                } else {
                  _showSnackBar(
                    message: 'Please enter your enquiry',
                    color: Colors.red,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendEnquiryEmail() async {
    final String enquiryText = _enquiryController.text;
    final String subject = 'Enquiry for Room: ${widget.room.roomDescription}';
    final String content = '''
Room Details:
Name: ${widget.room.roomDescription}
Price: Rs. ${widget.room.rentPrice}
Description: ${widget.room.roomDescription}
Floor: ${widget.room.floor}
Address: ${widget.room.address}
Parking: ${widget.room.parking}
Contact No: ${widget.room.contactNo}
Bathrooms: ${widget.room.bathroom}

User Enquiry:
$enquiryText
''';

    await sendEmail(
      content: content,
      subject: subject,
    );
    _enquiryController.clear();
  }

  void _showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode ??= Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Room Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
              background: imageUrl.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDarkMode! ? Colors.grey[800] : Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: isDarkMode! ? Colors.grey[400] : Colors.grey,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(color: isDarkMode! ? Colors.grey[800] : Colors.grey[300]),
            ),
            backgroundColor: isDarkMode! ? Colors.black : const Color(0xFF4DBB75),
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode!
                      ? [Colors.black, Colors.black87]
                      : [const Color(0xFF4DBB75).withOpacity(0.1), Colors.white],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 6,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: isDarkMode! ? Colors.grey[850] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                              icon: Icons.description,
                              title: 'Description',
                              value: widget.room.roomDescription,
                              isBold: true,
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.layers,
                              title: 'Floor',
                              value: widget.room.floor.toString(),
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.location_on,
                              title: 'Address',
                              value: widget.room.address,
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.money_rounded,
                              title: 'Rent Price',
                              value: 'Rs. ${widget.room.rentPrice}',
                              isBold: true,
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.local_parking,
                              title: 'Parking',
                              value: widget.room.parking,
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.phone,
                              title: 'Contact No',
                              value: widget.room.contactNo,
                              isDarkMode: isDarkMode!,
                            ),
                            _buildDivider(isDarkMode!),
                            _buildDetailRow(
                              icon: Icons.bathroom,
                              title: 'Bathrooms',
                              value: widget.room.bathroom.toString(),
                              isDarkMode: isDarkMode!,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _showEnquiryDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black26,
                          ),
                          child: const Text(
                            'Enquiry',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _initiatePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 123, 199, 125),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black26,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/esewa.png',
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pay',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isBold = false,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF4DBB75),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 20,
      thickness: 1,
      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
    );
  }

  @override
  void dispose() {
    _enquiryController.dispose();
    super.dispose();
  }
}