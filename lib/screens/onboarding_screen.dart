import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  static const int _total = 8;

  static const List<_PageData> _pages = [
    _PageData(
      color: AppTheme.primary,
      icon: Icons.handyman,
      titleEs: 'Bienvenido a SkillFix',
      titleEn: 'Welcome to SkillFix',
      descEs: 'Tu asistente inteligente para reparaciones y mantenimiento del hogar.',
      descEn: 'Your smart assistant for home repairs and maintenance.',
    ),
    _PageData(
      color: Color(0xFFE65100),
      icon: Icons.language,
      titleEs: 'Elige tu idioma',
      titleEn: 'Choose your language',
      isLanguagePicker: true,
    ),
    _PageData(
      color: Color(0xFF2E7D32),
      icon: Icons.menu_book,
      titleEs: 'Guías paso a paso',
      titleEn: 'Step-by-step guides',
      descEs: 'Explora 23 oficios con instrucciones claras, herramientas necesarias y lista de materiales.',
      descEn: 'Explore 23 trades with clear instructions, required tools, and a materials list.',
    ),
    _PageData(
      color: Color(0xFF6A1B9A),
      icon: Icons.manage_search,
      titleEs: 'Diagnóstica tu problema',
      titleEn: 'Diagnose your problem',
      descEs: 'Responde preguntas simples y encuentra la causa exacta del fallo en minutos.',
      descEn: 'Answer simple questions and pinpoint the exact cause of any issue.',
    ),
    _PageData(
      color: Color(0xFF00695C),
      icon: Icons.calculate,
      titleEs: '15 calculadoras de materiales',
      titleEn: '15 materials calculators',
      descEs: 'Calcula pintura, concreto, madera, techo, cable eléctrico y mucho más.',
      descEn: 'Calculate paint, concrete, lumber, roofing, wire gauge, and much more.',
    ),
    _PageData(
      color: Color(0xFFC62828),
      icon: Icons.local_fire_department,
      titleEs: 'Protocolos de emergencia',
      titleEn: 'Emergency protocols',
      descEs: 'Pasos claros para fuga de gas, incendio, CO, inundación y 7 emergencias más.',
      descEn: 'Clear steps for gas leaks, fires, CO alarms, flooding, and 7 more emergencies.',
    ),
    _PageData(
      color: Color(0xFF283593),
      icon: Icons.notifications_active,
      titleEs: 'Recordatorios de mantenimiento',
      titleEn: 'Maintenance reminders',
      descEs: 'Programa revisiones estacionales y nunca olvides el mantenimiento preventivo.',
      descEn: 'Schedule seasonal checkups and never miss preventive maintenance.',
    ),
    _PageData(
      color: AppTheme.primary,
      icon: Icons.rocket_launch,
      titleEs: '¡Todo listo!',
      titleEn: 'All set!',
      descEs: 'Más de 100 guías, 15 calculadoras y 11 protocolos de emergencia en tu bolsillo.',
      descEn: '100+ guides, 15 calculators and 11 emergency protocols in your pocket.',
    ),
  ];

  void _next() {
    if (_page < _total - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await Provider.of<LanguageService>(context, listen: false).completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, a, b) => const MainShell(),
        transitionsBuilder: (context, anim, b, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context).locale.languageCode;
    final isLast = _page == _total - 1;
    final pageColor = _pages[_page].color;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip / spacer row
            SizedBox(
              height: 48,
              child: isLast
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: _complete,
                          child: Text(
                            lang == 'en' ? 'Skip' : 'Saltar',
                            style: const TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                    ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _total,
                itemBuilder: (context, index) => _buildPage(index, lang),
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_total, (i) => _buildDot(i, pageColor)),
              ),
            ),

            // Next / Done button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pageColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast
                        ? (lang == 'en' ? 'Get Started' : 'Comenzar')
                        : (lang == 'en' ? 'Next' : 'Siguiente'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index, String lang) {
    final page = _pages[index];
    final title = lang == 'en' ? page.titleEn : page.titleEs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: page.color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 80, color: page.color),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Description or language picker
          if (page.isLanguagePicker)
            _buildLanguagePicker(page.color)
          else
            Text(
              lang == 'en' ? (page.descEn ?? '') : (page.descEs ?? ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguagePicker(Color accentColor) {
    final langService = Provider.of<LanguageService>(context);
    final current = langService.locale.languageCode;

    return Column(
      children: [
        _LangButton(
          label: 'Español',
          flag: '🇪🇸',
          isSelected: current == 'es',
          accentColor: accentColor,
          onTap: () => langService.setLocale(const Locale('es')),
        ),
        const SizedBox(height: 12),
        _LangButton(
          label: 'English',
          flag: '🇺🇸',
          isSelected: current == 'en',
          accentColor: accentColor,
          onTap: () => langService.setLocale(const Locale('en')),
        ),
      ],
    );
  }

  Widget _buildDot(int index, Color activeColor) {
    final isActive = index == _page;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withAlpha(18) : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? accentColor : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1 : 0,
              child: Icon(Icons.check_circle, color: accentColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final Color color;
  final IconData icon;
  final String titleEs;
  final String titleEn;
  final String? descEs;
  final String? descEn;
  final bool isLanguagePicker;

  const _PageData({
    required this.color,
    required this.icon,
    required this.titleEs,
    required this.titleEn,
    this.descEs,
    this.descEn,
    this.isLanguagePicker = false,
  });
}
