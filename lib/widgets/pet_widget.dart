import 'package:flutter/material.dart';
import 'package:nekotomo_app/core/constants/api_constants.dart';
import 'package:nekotomo_app/models/user.dart';

/// Animated pet widget that shows different states with smooth transitions
class PetWidget extends StatefulWidget {
  final PetState petState;
  final double size;
  final VoidCallback? onTap;

  const PetWidget({
    super.key,
    this.petState = PetState.idle,
    this.size = 250,
    this.onTap,
  });

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _bounceController;
  late AnimationController _excitedController;
  late Animation<double> _breathAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _excitedAnimation;

  PetState _currentDisplayState = PetState.idle;


  @override
  void initState() {
    super.initState();

    // Idle breathing animation
    _breathController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Bounce animation for eating/playing
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Excited pulse animation
    _excitedController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _excitedAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _excitedController, curve: Curves.easeInOut),
    );

    _currentDisplayState = widget.petState;
    _playStateAnimation(widget.petState);
  }

  @override
  void didUpdateWidget(PetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.petState != widget.petState) {
      _playStateAnimation(widget.petState);
    }
  }

  void _playStateAnimation(PetState state) {
    setState(() {
      _currentDisplayState = state;
    });

    switch (state) {
      case PetState.eating:
        _bounceController.repeat(reverse: true);
        _scheduleTransition(PetState.happy, const Duration(seconds: 2));
        break;
      case PetState.playing:
        _bounceController.repeat(reverse: true);
        _scheduleTransition(PetState.happy, const Duration(seconds: 2));
        break;
      case PetState.excited:
        _excitedController.repeat(reverse: true);
        _scheduleTransition(PetState.happy, const Duration(seconds: 3));
        break;
      case PetState.happy:
        _bounceController.stop();
        _excitedController.stop();
        _scheduleTransition(PetState.idle, const Duration(seconds: 2));
        break;
      default:
        _bounceController.stop();
        _excitedController.stop();
        break;
    }
  }

  void _scheduleTransition(PetState nextState, Duration delay) {
    Future.delayed(delay, () {
      if (mounted) {
        _playStateAnimation(nextState);
      }
    });
  }

  String _getAssetForState(PetState state) {
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

  @override
  void dispose() {
    _breathController.dispose();
    _bounceController.dispose();
    _excitedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _breathController,
          _bounceController,
          _excitedController,
        ]),
        builder: (context, child) {
          double scale = _breathAnimation.value;
          double translateY = 0;

          if (_currentDisplayState == PetState.eating ||
              _currentDisplayState == PetState.playing) {
            translateY = _bounceAnimation.value;
          }

          if (_currentDisplayState == PetState.excited) {
            scale = _excitedAnimation.value;
          }

          return Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: ClipRRect(
                  key: ValueKey(_currentDisplayState),
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    _getAssetForState(_currentDisplayState),
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
