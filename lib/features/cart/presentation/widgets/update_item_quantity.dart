import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class UpdateItemQuantityButton extends StatelessWidget {
  final String userId;
  final int productId;
  final int currentQty;
  final double totalPrice;

  const UpdateItemQuantityButton({
    super.key,
    required this.userId,
    required this.productId,
    required this.currentQty,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "\$${totalPrice.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () async {
            int tempQty = currentQty;
            final controller = TextEditingController(text: tempQty.toString());

            final newQty = await showDialog<int>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text("Edit Quantity"),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null && parsed > 0) {
                        tempQty = parsed;
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, tempQty),
                      child: const Text("Save"),
                    ),
                  ],
                );
              },
            );
            if (!context.mounted) {
              return;
            }
            if (newQty != null && newQty > 0) {
              context.read<CartBloc>().add(
                UpdateItemQuantity(userId, productId, newQty),
              );
            }
          },
        ),
      ],
    );
  }
}
