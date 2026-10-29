import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/wave_background.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: WaveBackground(height: 190),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // ===== LOGO dari assets =====
                  Image.asset('assets/images/logo.png',
                      width: 84, height: 84),
                  const SizedBox(height: 16),
                  const Text('Hiyote',
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink)),
                  const SizedBox(height: 6),
                  const Text('Masuk untuk melanjutkan ke catatan pribadimu',
                      style: TextStyle(color: AppColors.muted, fontSize: 14)),
                  const SizedBox(height: 32),

                  // Email
                  _field(
                    controller: _email,
                    hint: 'email',
                    icon: Icons.mail_outline,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  // Password
                  _field(
                    controller: _password,
                    hint: 'kata sandi',
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.muted,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _remember = !_remember),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _remember
                                    ? AppColors.sage
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: _remember
                                        ? AppColors.sage
                                        : AppColors.border,
                                    width: 1.5),
                              ),
                              child: _remember
                                  ? const Icon(Icons.check,
                                      size: 15, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            const Text('Ingat saya',
                                style: TextStyle(color: AppColors.muted)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: const Text('Lupa kata sandi?',
                            style: TextStyle(
                                color: AppColors.forest,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tombol Masuk
                  _gradientButton('Masuk', _goHome),
                  const SizedBox(height: 22),

                  Row(
                    children: const [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('atau masuk dengan',
                            style: TextStyle(color: AppColors.muted)),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  _outlineButton(
                    onTap: _goHome,
                    leading: const _GoogleG(),
                    label: 'Masuk dengan Google',
                  ),
                  const SizedBox(height: 12),
                  _outlineButton(
                    onTap: _goHome,
                    leading: const Icon(Icons.person_outline,
                        color: AppColors.muted),
                    label: 'Masuk sebagai Tamu',
                  ),
                  const SizedBox(height: 150),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? ',
                          style: TextStyle(color: AppColors.muted)),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Daftar sekarang',
                            style: TextStyle(
                                color: AppColors.forest,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboard,
  }) {
    return Container(
      height: 58,
      decoration: fieldBox(),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.ink),
          prefixIcon: Icon(icon, color: AppColors.muted),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.sage, AppColors.sageLight]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.sage.withOpacity(.28),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _outlineButton({
    required VoidCallback onTap,
    required Widget leading,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: fieldBox(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 12),
            Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

/// Huruf "G" berwarna sederhana (tanpa perlu aset tambahan)
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (r) => const LinearGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
        ],
      ).createShader(r),
      child: const Text('G',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }
}
