# Fix startup on wayland and crash on suspend
final: prev: {
  wezterm = prev.wezterm.overrideAttrs (old: rec {
    pname = "wezterm";
    version = "20240406-cce0706";
    src = prev.fetchFromGitHub {
      owner = "wez";
      repo = "${pname}";
      rev = "cce0706b1f2a9e2d1f02c57f2d1cd367c91df1ae";
      fetchSubmodules = true;
      hash = "sha256-BBPxidOpFrw/tIRTqMSREyJF3QEWOwlIoVRT3FD62sQ=";
    };
    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
      };
    };
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchpatch {
          # fix(wayland): ensure repaint event is sent in show
          url = "https://patch-diff.githubusercontent.com/raw/wez/wezterm/pull/5264.patch";
          hash = "sha256-c+frVaBEL0h3PJvNu3AW2iap+uUXBY8olbm7Wsxuh4Q=";
        })
        (prev.writeText
          "wezterm-remove_capabilities.patch"
          ''
            diff --git a/window/src/os/wayland/seat.rs b/window/src/os/wayland/seat.rs
            index 3798f4259..e91591130 100644
            --- a/window/src/os/wayland/seat.rs
            +++ b/window/src/os/wayland/seat.rs
            @@ -65,9 +65,15 @@ impl SeatHandler for WaylandState {
                     _conn: &Connection,
                     _qh: &QueueHandle<Self>,
                     _seat: WlSeat,
            -        _capability: smithay_client_toolkit::seat::Capability,
            +        capability: smithay_client_toolkit::seat::Capability,
                 ) {
            -        todo!()
            +        if capability == Capability::Keyboard && self.keyboard.is_some() {
            +            self.keyboard.take().unwrap().release();
            +        }
            +
            +        if capability == Capability::Pointer && self.pointer.is_some() {
            +            self.pointer = None;
            +        }
                 }

                 fn remove_seat(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _seat: WlSeat) {
          '')
      ];
  });
}
