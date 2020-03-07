{ stdenv, pkgs
# Python deps
, cython, buildPythonPackage, isPy3k, fetchPypi
# Python libraries
, docutils, kivy-garden, gst-python, pillow, pycairo, pkgconfig, pygments, pysdl2, requests
# Common deps
, gcc
# Common libraries
, cairo, pango, gstreamer
, mtdev
, SDL2 #, sdl ? false
, SDL2_image
, SDL2_gfx
, SDL2_mixer
, SDL2_ttf
, xlibs
, xlibsWrapper
}:

buildPythonPackage rec {
    pname = "kivy";
    version = "1.11.1";

    # todo: build 2.0 rc from git master
    #version = "unstable-2020-03-06";
    #disabled = !isPy3k; # 2.0 (in alpha, not released yet) does not support python 2

    src = fetchPypi {
      inherit version;
      pname = "Kivy";
      sha256 = "112fk0i80bn7s7sykz44aivg9393vqfncxqzaldr07i7fipmj3jd";
    };

    KIVY_USE_SETUPTOOLS=1;
    USE_X11 = 1;
    USE_SDL2 = 1;
    USE_GSTREAMER = 1;

    nativeBuildInputs = [
      docutils
      
      #libGL
      #mesa
      #mesa_drivers
      #mesa_glu
      #mesa_noglu
      #libGL_driver
      pango

      kivy-garden
      pkgs.pkgconfig
      xlibsWrapper
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      mtdev
    ];

    #buildInputs = [ gstreamer.dev ];
      
    propogatedBuildInputs = [
      cairo
      gstreamer
      mtdev
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf

      pango
      cython

      xlibs.libXrender # if x11 true
      xlibs.libX11 # if x11 true
      gst-python  
      pillow
      pycairo
    ];

    postPatch = ''
      substituteInPlace kivy/lib/mtdev.py --replace "cdll.LoadLibrary('libmtdev.so.1')" "cdll.LoadLibrary('${mtdev.outPath}/lib/libmtdev.so.1')"
      substituteInPlace setup.py --replace "MAX_CYTHON_STRING = '0.29.10'" "MAX_CYTHON_STRING = '0.29.14'"
    '';

      #substituteInPlace setup.py --replace "'pkg-config --libs" "'${pkgconfig}/bin/pkg-config --libs"


    # postPatch for 2.0rc
    #postPatch = ''
      #substituteInPlace setup.cfg \
       #--replace "" ""
    #'';


    pythonPath = [
      cython
      gst-python
      kivy-garden
      pillow
      pycairo
      pygments
      pysdl2
      requests
    ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Cross platform UI framework with multi-touch capabilities.";
      homepage = http://kivy.org;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = with platforms; linux;
      #platforms = with platforms; linux ++ darwin;
    };
}

