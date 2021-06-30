abstract class FontSizeFactorEvent {}

class LoadFontSizeFactorEvent extends FontSizeFactorEvent {}

class ChangedFontSizeFactorEvent extends FontSizeFactorEvent {
  final double size;

  ChangedFontSizeFactorEvent(this.size);
}
