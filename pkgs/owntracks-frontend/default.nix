{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "owntracks-frontend";
  version = "cecf7e797de7f8bc736a66a94a41b208a0a9a02d";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "frontend";
    rev = version;
    hash = "sha256-n+Oqxe7uPHzB0IRdnp8ZWMo1NZtBWlJibXbHxNNke18=";
  };

  npmDepsHash = "sha256-4hsP5CNNJrpZ2gsrPjXriy22XLZjGVtbFZmqtjuh8rQ=";

  # upstream package-lock.json didn't work. This one is updated using
  # `npm update`.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist/* $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for OwnTracks";
    homepage = "https://github.com/owntracks/frontend";
    changelog = "https://github.com/owntracks/frontend/blob/master/Changelog";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ imincik ];
  };
}
