# modular_abel — ERP system (ported from Twilight-Axis)

Modular port of the Twilight-Axis ERP panel into Vanderlin.

## Layout

```
modular_abel/
  __includes.dm                      master include (the DME bridge points here)
  code/modules/erp_foundation/       Vanderlin-native sex layer the engine sits on
  code/modules/erp_system/           ERP engine (actions/actor/components/core/organs/ui)
  sound/                             Twilight-only SFX shipped as modular assets (FILE_DIR)
  _parked_twilight/                  Twilight-specific content, NOT included (see its README)
```

The React panel lives at `tgui/packages/tgui/interfaces/EroticRolePlayPanel.tsx`.
It must sit inside the tgui package because rspack resolves npm deps (react,
tgui-core) relative to file location; pure presentation, logic stays in DM
(`code/modules/erp_system/ui/`).

## Bridge points (only upstream touches)

1. `vanderlin.dme` — `#include "modular_abel\__includes.dm"` and `#define FILE_DIR "modular_abel"`.
2. `tgui/packages/tgui/interfaces/EroticRolePlayPanel.tsx` — the panel component.

## Build
- DM: `dm.exe vanderlin.dme`
- TGUI: `tgui/node_modules/.bin/rspack build`
