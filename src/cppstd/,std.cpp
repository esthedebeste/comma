// included above every outputted c++ file.
#include <iostream>
#include <random>
#include <string>

void comma_putsnoln_() {}
template <typename A, typename... T> void comma_putsnoln_(A thing, T... rest) {
  std::cout << thing;
  comma_putsnoln_(rest...);
}

void comma_putswithaln_() {}
template <typename A, typename... T>
void comma_putswithaln_(A thing, T... rest) {
  std::cout << thing << '\n';
  comma_putswithaln_(rest...);
}

static std::random_device rd;
static std::mt19937 gen(rd());
static std::uniform_real_distribution<double> dis(0.0, 1.0);
struct COMMA_CHANCE {
  double chance;

  constexpr COMMA_CHANCE(double chance) : chance(chance) {}
  operator bool() { return dis(gen) < chance; }
  template <typename T> constexpr COMMA_CHANCE operator/(T t) {
    return COMMA_CHANCE{chance / t};
  }
  template <typename T> constexpr COMMA_CHANCE operator*(T t) {
    return COMMA_CHANCE{chance * t};
  }
};