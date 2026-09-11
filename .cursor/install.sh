#!/usr/bin/env bash
#
# Idempotent Cloud Agent install for the babysteps2git R package.
# Installs the R toolchain and the R package-development toolkit using
# Ubuntu's ABI-consistent r-cran-* binaries (fast, no source compilation).
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# The default archive.ubuntu.com / security.ubuntu.com mirrors are only
# reachable over HTTPS in this environment (plain HTTP times out). Rewrite the
# apt sources to HTTPS so `apt-get update` succeeds. Safe to run repeatedly.
if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
  sudo sed -i \
    -e 's|http://archive.ubuntu.com/ubuntu/|https://archive.ubuntu.com/ubuntu/|g' \
    -e 's|http://security.ubuntu.com/ubuntu/|https://security.ubuntu.com/ubuntu/|g' \
    /etc/apt/sources.list.d/ubuntu.sources
fi

sudo apt-get update -qq

# R interpreter, build toolchain, and system libraries needed to build R
# packages that contain compiled code, plus the r-cran-* development toolkit.
sudo apt-get install -y --no-install-recommends \
  r-base r-base-dev r-recommended \
  build-essential gfortran \
  libcurl4-openssl-dev libssl-dev libxml2-dev libgit2-dev \
  libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
  pandoc qpdf \
  r-cran-devtools r-cran-roxygen2 r-cran-testthat r-cran-rcmdcheck \
  r-cran-knitr r-cran-rmarkdown r-cran-usethis

# Site-wide R options: a reachable CRAN mirror for any source installs and
# parallel compilation. Written every run so it stays consistent.
R_HOME_ETC="$(R RHOME)/etc"
sudo tee "${R_HOME_ETC}/Rprofile.site" >/dev/null <<'PROFILE'
## Site-wide R options for the Cloud Agent environment.
local({
  options(
    repos = c(CRAN = "https://cloud.r-project.org"),
    Ncpus = max(1L, parallel::detectCores())
  )
})
PROFILE

# Install this package's hard dependencies (Depends/Imports/LinkingTo) declared
# in DESCRIPTION into a writable user library, in case the package grows deps
# not already provided by the apt toolkit above. This is a no-op today (the
# package has no hard deps). Suggests such as testthat come from the apt
# toolkit. Non-fatal so a transient CRAN issue never breaks environment setup.
if [ -f DESCRIPTION ]; then
  USER_LIB="$(Rscript -e 'cat(Sys.getenv("R_LIBS_USER"))')"
  mkdir -p "${USER_LIB}"
  Rscript -e 'if (requireNamespace("remotes", quietly = TRUE)) {
    tryCatch(
      remotes::install_deps(dependencies = NA, upgrade = "never",
                            lib = Sys.getenv("R_LIBS_USER")),
      error = function(e) message("install_deps skipped: ", conditionMessage(e))
    )
  }' || true
fi

echo "babysteps2git environment ready: $(R --version | head -1)"
