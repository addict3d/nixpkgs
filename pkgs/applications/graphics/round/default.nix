{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "round";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
    sha256 = "09brjr3h4qnhlidxlki1by5anahxy16ai078zm4k7ryl579amzdw";
  };

  #vendorSha256 = "17v5nzswaaaabawxrvkza8a5d9aqyhb2gkncp3fqv6rszmkwwww6";  # there isn't any?
  vendorSha256 = null;  # there isn't any?

  subPackages = [ "." ];

  meta = with lib; {
    description = "Round image corners from CLI";
    homepage    = "https://github.com/mingrammer/round";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
