import 'package:flutter/material.dart';

class SmoothStepper extends StatelessWidget {
  final int currentStep; // 0, 1, 2

  const SmoothStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStep(
          title: "Set Profile",
          isActive: currentStep >= 0,
          isCurrent: currentStep == 0,
        ),
        _buildLine(isActive: currentStep >= 1),
        _buildStep(
          title: "Health details",
          isActive: currentStep >= 1,
          isCurrent: currentStep == 1,
        ),
        _buildLine(isActive: currentStep >= 2),
        _buildStep(
          title: "Choose goal",
          isActive: currentStep >= 2,
          isCurrent: currentStep == 2,
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [Colors.purpleAccent, Colors.deepPurpleAccent]
                : [Colors.grey.shade300, Colors.grey.shade200],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required bool isActive,
    required bool isCurrent,
  }) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade200],
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: isCurrent
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black87 : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
