{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fast-float";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "fastfloat";
    repo = "fast_float";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lKEzRYKdpjsqixC9WBoILccqB2ZkUtPUzT4Q4+j0oac=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fast and exact implementation of the C++ from_chars functions for number types";
    homepage = "https://github.com/fastfloat/fast_float";
    license = with lib.licenses; [
      asl20
      boost
      mit
    ];
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
})
