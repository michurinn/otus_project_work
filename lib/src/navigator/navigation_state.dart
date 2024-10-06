class NavigationState {
  Tabs tab;

  NavigationState({required this.tab});

  void goToApi() {
    tab = Tabs.third;
  }

  void goToSse() {
    tab = Tabs.second;
  }

  void goToMain() {
    tab = Tabs.firest;
  }
}

enum Tabs { firest, second, third }
