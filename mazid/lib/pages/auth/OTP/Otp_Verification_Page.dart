// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_state.dart';
import 'package:mazid/pages/home/ui/home_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = otpController.text.trim();
      context.read<AuthCubit>().verifyPhoneOtp(phone: widget.phone, otp: otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter the OTP sent to ${widget.phone}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "OTP Code",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter OTP" : null,
                  ),
                  const SizedBox(height: 20),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _verifyOtp,
                          child: const Text("Verify OTP"),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
