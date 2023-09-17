// included above every outputted c++ file.
#include <cmath>
#include <functional>
#include <iostream>
#include <random>
#include <stdio.h>
#include <string>
#if defined(WIN32) || defined(_WIN32) ||                                       \
    defined(__WIN32) && !defined(__CYGWIN__)
#define _COMMA_WIN32
#define _COMMA_OPENER "start"
#include <fcntl.h>
#include <io.h>
#endif
#ifdef __linux__
#define _COMMA_LINUX
#define _COMMA_OPENER "xdg-open"
#endif
#ifdef __APPLE__
#define _COMMA_APPLE
#define _COMMA_OPENER "open"
#endif

void comma_putsnoln_() {}
template <typename A, typename... T> void comma_putsnoln_(A thing, T... rest) {
  std::wcout << thing;
  comma_putsnoln_(rest...);
}

void comma_putswithaln_() {}
template <typename A, typename... T>
void comma_putswithaln_(A thing, T... rest) {
  std::wcout << thing << '\n';
  comma_putswithaln_(rest...);
}

namespace comma {
inline void premain(void) {
#ifdef _COMMA_WIN32
  _setmode(_fileno(stdout), _O_U16TEXT);
#else
  setlocale(LC_ALL, "");
#endif
}

void dee_dee_dee_dinky_dinky() {
  std::wcout << L":3 :3 :3" << std::endl;
#ifdef _COMMA_OPENER
  std::system(_COMMA_OPENER " https://youtu.be/nos_w39ayxg");
#else
  std::wcout << L"please open https://youtu.be/nos_w39ayxg ^_^" << std::endl;
#endif
  std::exit(3);
}

float mod(float a, float b) { return std::fmod(a, b); }
double mod(double a, double b) { return std::fmod(a, b); }
long double mod(long double a, long double b) { return std::fmod(a, b); }
// for integers
template <typename T> T mod(T a, T b) { return (a % b + b) % b; }

static std::random_device rd;
static std::mt19937 gen(rd());
static std::uniform_real_distribution<double> dis(0.0, 1.0);
struct Chance {
  double chance;

  constexpr Chance(double chance) : chance(chance) {}
  operator bool() { return dis(gen) < chance; }
  constexpr Chance operator/(Chance t) { return Chance{chance / t.chance}; }
  constexpr Chance operator*(Chance t) { return Chance{chance * t.chance}; }
  constexpr Chance operator+(Chance t) { return Chance{chance + t.chance}; }
  constexpr Chance operator-(Chance t) { return Chance{chance - t.chance}; }
  template <typename T> constexpr Chance operator/(T t) {
    return Chance{chance / t};
  }
  template <typename T> constexpr Chance operator*(T t) {
    return Chance{chance * t};
  }
  template <typename T> constexpr Chance operator+(T t) {
    return Chance{chance + t};
  }
  template <typename T> constexpr Chance operator-(T t) {
    return Chance{chance - t};
  }
};

// allows for \0 in strings
template <size_t length>
inline std::wstring string(const wchar_t (&literal)[length]) {
  return std::wstring(&literal[0], length - 1);
}
}
