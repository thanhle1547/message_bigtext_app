abstract class FontSizeFactorState {
  final double size;

  FontSizeFactorState(this.size);
}

class FontSizeFactorInititalState extends FontSizeFactorState {
  FontSizeFactorInititalState(double size) : super(size);
}

class FontSizeFactorLoadedState extends FontSizeFactorState {
  FontSizeFactorLoadedState(double size) : super(size);
}

class FontSizeFactorChangedState extends FontSizeFactorState {
  FontSizeFactorChangedState(double size) : super(size);
}
