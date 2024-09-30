import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';

class CustomTextFormField extends StatefulWidget {
  final TextFormField textFormField;
  final List<File> images;
  final Widget? sendButton;
  final Widget? imageButton;

  CustomTextFormField({
    super.key,
    required this.textFormField,
    this.sendButton,
    this.imageButton,
    this.images = const [],
  }) : assert(
          textFormField.controller != null,
          'textFormField must have a controller',
        );

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.messageTextFieldColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display images if available
              if (widget.images.isNotEmpty) ...[
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                    return  Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.images[index] as File,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.images.removeAt(index);
                                });
                              },
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    border: InputBorder.none,
                    contentPadding: widget.sendButton != null
                        ? const EdgeInsets.only(right: 42)
                        : EdgeInsets.zero,
                  ),
                ),
                // The TextFormField wrapped with Focus to listen for backspace
                child: Focus(
                  onKeyEvent: (_, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace) {
                      final text = widget.textFormField.controller!.text.trim();

                      // Remove the last image when backspace is pressed and input is empty
                      if (text.isEmpty & widget.images.isNotEmpty) {
                        setState(() => widget.images.removeLast());
                      }
                    }

                    return KeyEventResult.ignored;
                  },
                  child: widget.textFormField,
                ),
              ),
            ],
          ),
        ),
        // Optional button (e.g., mic icon) if provided
        if (widget.sendButton != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  if (widget.imageButton != null) widget.imageButton!,
                  10.horizontalSpace,
                   widget.sendButton!,
              
              ],
            ),
          ),
      ],
    );
  }
}
