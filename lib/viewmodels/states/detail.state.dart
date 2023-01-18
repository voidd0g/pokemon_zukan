class DetailState {
  final bool isSettingLike;
  final bool isInitialized;

  const DetailState({
    required this.isSettingLike,
    required this.isInitialized,
  });

  DetailState copyFrom({
    bool? newIsSettingLike,
    bool? newIsInitialized,
  }) {
    return DetailState(
      isSettingLike: newIsSettingLike ?? isSettingLike,
      isInitialized: newIsInitialized ?? isInitialized,
    );
  }
}
