# low-standard-guix
Low Standard Guix packages; for those packages that would not be accepted by the real guix project without refinements.

I wanted to add Microsoft Cascadia Code fonts package to Guix but it was pointed out that the font would need to be compiled from source, rather than just simply be copied from Microsoft's releases.
I may (or someone else) may do that later - the original package that just copies the files is kept here.

# Usage:
Add to `channels.scm` as below (see the last section, low-standard-guix:
```schme
~/.config/guix$ cat /home/yasu/.config/guix/channels.scm
(cons*
  (channel
    (name 'guix)
    (url "https://github.com/guix-mirror/guix.git")
    )
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")

    ;; Enable signature verification:
    (introduction
      (make-channel-introduction
        "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
        (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
  (channel
    (name 'guix-chromium)
    (url "https://gitlab.com/mbakke/guix-chromium.git")
    (branch "master"))
  (channel
    (name 'low-standard-guix)
    (url "https://github.com/yugawara/low-standard-guix.git")
    (branch "master"))
  %default-channels)
```
execute `guix pull --disable-authentication`
```
~/.config/guix$ guix pull --disable-authentication
Updating channel 'guix' from Git repository at 'https://github.com/guix-mirror/guix.git'...
guix pull: warning: channel authentication disabled
Updating channel 'nonguix' from Git repository at 'https://gitlab.com/nonguix/nonguix'...
guix pull: warning: channel authentication disabled
Updating channel 'guix-chromium' from Git repository at 'https://gitlab.com/mbakke/guix-chromium.git'...
guix pull: warning: channel authentication disabled
Updating channel 'low-standard-guix' from Git repository at 'https://github.com/yugawara/low-standard-guix.git'...
guix pull: warning: channel authentication disabled
Building from these channels:
  low-standard-guixhttps://github.com/yugawara/low-standard-guix.git    658351a
  guix-chromiumhttps://gitlab.com/mbakke/guix-chromium.git      2de450b
  nonguix   https://gitlab.com/nonguix/nonguix  d12b4eb
  guix      https://github.com/guix-mirror/guix.git     267d594
Computing Guix derivation for 'x86_64-linux'... \
nothing to be done
```
execute: `sudo reboot`
exeute: `guix install font-cascadia-code`
execute: `sudo reboot`

Discalimer
==========
Probably, the `sudo reboot` part can be improved - there are probably better, less intrusive ways to achieve the same effect.

And just to be sure
===================
Here is my guix system configuration file.
I use this as: `sudo guix system reconfigure  ~/config.scm`
```
(use-modules
  (gnu)
  (gnu system nss)
  (gnu services sddm)
  (srfi srfi-1)

  (nongnu packages linux)
  (nongnu system linux-initrd)
  )

(use-service-modules desktop xorg)
(use-package-modules certs gnome)
(use-service-modules nix)
(use-package-modules package-management)

(operating-system

  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (host-name "guix")
  (timezone "Asia/Tokyo")
  (locale "en_US.utf8")

  (sudoers-file
    (plain-file "sudoers"
                (string-append (plain-file-content %sudoers-specification)
                               "yasu ALL = NOPASSWD: ALL\n")))

  (keyboard-layout (keyboard-layout "us"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")
                (keyboard-layout keyboard-layout)))

  (file-systems (append
                  (list (file-system
                          (device (file-system-label "my-root"))
                          (mount-point "/")
                          (type "ext4")
                          )
                        (file-system
                          (device (uuid "C2D0-0B91" 'fat))
                          (mount-point "/boot/efi")
                          (type "vfat")))
                  %base-file-systems))
  (swap-devices (list "/dev/nvme0n1p3"))

  (users (cons (user-account
                 (name "yasu")
                 (comment "yasu")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev"
                                         "audio" "video")))
               %base-user-accounts))

  (packages (append (list
                      ;;nix
                      ;; for HTTPS access
                      nss-certs
                      ;; for user mounts
                      gvfs)
                    %base-packages))

  (services (cons*
              (service gnome-desktop-service-type)
              ;(service mate-desktop-service-type)
              ;(service xfce-desktop-service-type)
              (service sddm-service-type
                       (sddm-configuration
                         (display-server "wayland")
                         (remember-last-user? #t)
                         ))
              ;(service nix-service-type)

              (modify-services
                (remove (lambda (service)
                                (member (service-kind service)
                                        (list gdm-service-type)))
                        %desktop-services) ;end of remove lambda services

                )	;;end of modify-services
              ))	;;end of services

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
```

