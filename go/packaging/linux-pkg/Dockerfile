FROM archlinux
RUN pacman -Sy fakeroot base-devel --noconfirm
RUN useradd --no-create-home --shell=/bin/false build && usermod -L build
USER build
