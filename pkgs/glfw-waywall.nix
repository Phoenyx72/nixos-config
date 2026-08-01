{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wayland
, wayland-scanner
, wayland-protocols
, libxkbcommon
, libx11
, libxrandr
, libxcursor
, libxi
, libxinerama
}:

stdenv.mkDerivation {
  pname = "glfw-waywall";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "glfw";
    rev = "3.4";
    hash = "sha256-FcnQPDeNHgov1Z07gjFze0VMz2diOrpbKZCsI96ngz0=";
  };

  patches = [
    ./glfw.patch
  ];

nativeBuildInputs = [
  cmake
  pkg-config
  wayland-scanner
  wayland-protocols
];

buildInputs = [
  wayland
  libxkbcommon
  libx11
  libxrandr
  libxcursor
  libxi
  libxinerama
];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DGLFW_BUILD_WAYLAND=ON"
    "-DGLFW_BUILD_X11=ON"
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp src/libglfw.so.3.4* $out/lib/libglfw.so
  '';
}