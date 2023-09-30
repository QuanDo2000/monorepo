#include <iostream>

// Include the necessary headers for OS detection
#ifdef _WIN32
#include <windows.h>
#elif __linux__
#include <sys/utsname.h>
#elif __APPLE__
#include <sys/utsname.h>
#endif

int main() {
#ifdef _WIN32
  // Windows-specific code
  std::cout << "You are running a Windows operating system." << std::endl;
#elif __linux__
  // Linux-specific code
  struct utsname unameData;
  if (uname(&unameData) == 0) {
    std::cout << "You are running a Linux operating system: " << unameData.sysname << std::endl;
  } else {
    std::cerr << "Error while detecting Linux OS." << std::endl;
    return 1;
  }
#elif __APPLE__
  // macOS-specific code
  struct utsname unameData;
  if (uname(&unameData) == 0) {
    std::cout << "You are running macOS: " << unameData.sysname << std::endl;
  } else {
    std::cerr << "Error while detecting macOS." << std::endl;
    return 1;
  }
#else
  // Code for other operating systems
  std::cout << "Operating system not recognized." << std::endl;
#endif

  return 0;
}
