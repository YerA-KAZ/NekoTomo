import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nekotomo_app/core/constants/api_constants.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/user.dart';

/// Interactive game character display with breathing, shadows, and particle reactions
class PetDisplay extends StatefulWidget {
  final PetState petState;
  final double size;
  final VoidCallback? onTap;
  final String? speechBubbleText;
  final bool showShadow;
  final bool showSpeechBubble;

  const PetDisplay({
    super.key,
    this.petState = PetState.idle,
    this.size = 260,
    this.onTap,
    this.speechBubbleText,
    this.showShadow = true,
    this.showSpeechBubble = true,
  });

  @override
  State<PetDisplay> createState() => _PetDisplayState();
}

class _PetDisplayState extends State<PetDisplay> with TickerProviderStateMixin {
  late AnimationController _idleFloatController;
  late AnimationController _actionBounceController;
  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shadowScaleAnimation;

  final List<_HeartParticle> _particles = [];
  PetState _displayState = PetState.idle;

  @override
  void initState() {
    super.initState();

    // Subtle gentle breathing / floating
    _idleFloatController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _idleFloatController, curve: Curves.easeInOut),
    );

    _shadowScaleAnimation = Tween<double>(begin: 1.0, end: 0.82).animate(
      CurvedAnimation(parent: _idleFloatController, curve: Curves.easeInOut),
    );

    // Dynamic bounce for actions (eat, play, tap)
    _actionBounceController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -28.0).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -28.0, end: 4.0).chain(CurveTween(curve: Curves.easeIn)), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 25),
    ]).animate(_actionBounceController);

    _displayState = widget.petState;
    _handleStateAnimation(widget.petState);
  }

  @override
  void didUpdateWidget(PetDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.petState != widget.petState) {
      _handleStateAnimation(widget.petState);
    }
  }

  void _handleStateAnimation(PetState state) {
    setState(() {
      _displayState = state;
    });

    if (state == PetState.eating || state == PetState.playing || state == PetState.excited) {
      _actionBounceController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _actionBounceController.stop();
          _actionBounceController.reset();
          setState(() {
            _displayState = PetState.happy;
          });
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _displayState = widget.petState == state ? PetState.idle : widget.petState;
              });
            }
          });
        }
      });
    } else {
      _actionBounceController.stop();
      _actionBounceController.reset();
    }
  }

  void _onPetTapped() {
    // Spawn playful heart particles
    final random = math.Random();
    for (int i = 0; i < 4; i++) {
      _particles.add(
        _HeartParticle(
          dx: (random.nextDouble() - 0.5) * widget.size * 0.7,
          dy: -20 - random.nextDouble() * 30,
          emoji: ['💖', '✨', '🐾', '🌸'][random.nextInt(4)],
        ),
      );
    }

    _actionBounceController.forward(from: 0.0);
    setState(() {});

    widget.onTap?.call();
  }

  String _getAssetPath(PetState state) {
    switch (state) {
      case PetState.idle:
        return PetAssets.idle;
      case PetState.happy:
        return PetAssets.happy;
      case PetState.sad:
        return PetAssets.sad;
      case PetState.hungry:
        return PetAssets.hungry;
      case PetState.eating:
        return PetAssets.eating;
      case PetState.playing:
        return PetAssets.playing;
      case PetState.sleeping:
        return PetAssets.sleeping;
      case PetState.excited:
        return PetAssets.excited;
    }
  }

  String _getDefaultSpeech(PetState state) {
    switch (state) {
      case PetState.idle:
        return 'Nya~ Pet me! 🐾';
      case PetState.happy:
        return 'Ureshii! So happy! 💕';
      case PetState.sad:
        return 'Samishii... I miss you 😿';
      case PetState.hungry:
        return 'Onaka suita! Feed me 🍙';
      case PetState.eating:
        return 'Mogumogu... Delicious! 🍱';
      case PetState.playing:
        return 'Tanoshii! Yay! 🎮';
      case PetState.sleeping:
        return 'Kuu-kuu... Zzz 💤';
      case PetState.excited:
        return 'Waku-waku! Sugoi! ⭐';
    }
  }

  @override
  void dispose() {
    _idleFloatController.dispose();
    _actionBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speechText = widget.speechBubbleText ?? _getDefaultSpeech(_displayState);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Kawaii Speech / Mood Bubble
        if (widget.showSpeechBubble)
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryLight, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💭', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    speechText,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Pet with shadow and interaction
        GestureDetector(
          onTap: _onPetTapped,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.size,
            height: widget.size * 1.05,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Ground 3D room shadow
                if (widget.showShadow)
                  AnimatedBuilder(
                    animation: Listenable.merge([_idleFloatController, _actionBounceController]),
                    builder: (context, _) {
                      final scale = _shadowScaleAnimation.value *
                          (1.0 - (_bounceAnimation.value.abs() / 80).clamp(0.0, 0.4));
                      return Positioned(
                        bottom: 8,
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: widget.size * 0.65,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(widget.size * 0.65, 22),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Pet Character Sprite
                AnimatedBuilder(
                  animation: Listenable.merge([_idleFloatController, _actionBounceController]),
                  builder: (context, _) {
                    final floatY = _floatAnimation.value + _bounceAnimation.value;
                    return Positioned(
                      bottom: 16 - floatY,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(scale: animation, child: child),
                          );
                        },
                        child: Image.asset(
                          _getAssetPath(_displayState),
                          key: ValueKey(_displayState),
                          width: widget.size,
                          height: widget.size,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    );
                  },
                ),

                // Floating Hearts / Sparkles particles
                ..._particles.map((p) {
                  return _ParticleWidget(
                    particle: p,
                    onFinished: () {
                      _particles.remove(p);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeartParticle {
  final double dx;
  final double dy;
  final String emoji;

  _HeartParticle({required this.dx, required this.dy, required this.emoji});
}

class _ParticleWidget extends StatefulWidget {
  final _HeartParticle particle;
  final VoidCallback onFinished;

  const _ParticleWidget({required this.particle, required this.onFinished});

  @override
  State<_ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<_ParticleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _translateY = Tween<double>(begin: 0.0, end: -70.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) => widget.onFinished());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: (130 + widget.particle.dx),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Opacity(
            opacity: _opacity.value,
            child: Transform.translate(
              offset: Offset(0, _translateY.value + widget.particle.dy),
              child: Text(
                widget.particle.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          );
        },
      ),
    );
  }
}
