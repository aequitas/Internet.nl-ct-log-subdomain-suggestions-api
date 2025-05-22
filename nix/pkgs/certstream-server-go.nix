{ pkgs, ...}: with pkgs; buildGoModule rec {
  pname = "certstream-server-go";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "d-Rickyy-b";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ashuwJjWrKjVtjPzBLmXX7EMFX0nlxs4B53pBP2G3Bo=";
  };

  vendorHash = "sha256-+7wL6JA5sNRNJQKelVkEVCZ5pqOlmn8o7Um2g6rsIlc=";

  meta = with lib; {
    description = "This project aims to be a drop-in replacement for the certstream server by Calidog.";
    homepage = "https://github.com/d-Rickyy-b/certstream-server-go";
    license = licenses.mit;
  };
}
