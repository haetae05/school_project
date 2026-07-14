import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RippleState { calm, walking, busy, danger }

final rippleStateProvider = StateProvider<RippleState>((ref) => RippleState.calm);
