(define-module (low-standard-guix)
  #:use-module (ice-9 regex)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xorg))

(define-public font-cascadia-code
  (package
    (name "font-cascadia-code")
    (version "2009.22")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/microsoft/cascadia-code/releases/download/"
                                  "v" version "/CascadiaCode-" version ".zip"))
              (sha256
                (base32
                  "0ilqvy7hzw35w5mig6zp2lny30fm8kmpzh69fg2npr4snyacq6w0"))))
    (build-system font-build-system)
    (home-page "https://github.com/microsoft/cascadia-code/")
    (synopsis "Microsoft Cascadia Code")
    (description "This package provides Microsoft Cascadia Code fonts.")
    (license license:silofl1.1)))

