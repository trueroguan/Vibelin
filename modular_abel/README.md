# modular_abel

This module owns the Dun World map import pipeline.

- Source map: `Azure-Peak/Azure-Peak:_maps/map_files/dun_world/dun_world.dmm`
- Build output: `_maps/map_files/dun_world/dun_world_new.dmm`
- Extra source z-level: `Azure-Peak/Azure-Peak:_maps/map_files/otherz/wretch_coast.dmm`
- Extra build output: `_maps/map_files/otherz/wretch_coast_new.dmm`
- Replacement config: `modular_abel/config/dun_world_map.json`

Run `modular_abel/prepare_map.cmd` on Windows or `modular_abel/prepare_map.sh`
on Linux to download the raw upstream maps by URL and apply path replacements.
The normal path does not depend on a local `C:\Axis\Azure-Peak` checkout.

Run `modular_abel/build.cmd <target>` or `modular_abel/build.sh <target>` to
prepare the map and compile through a temporary downstream DME without modifying
the upstream `vanderlin.dme` or `tools/build/build.ts`. For example:
`modular_abel/build.cmd dm`.

For a root-level one-button build, use `BUILD_MODULAR_ABEL.cmd` on Windows or
`BUILD_MODULAR_ABEL.sh` on Linux. These launchers call the modular wrapper and
leave the upstream `BUILD.cmd` unchanged.

The modular wrapper injects `modular_abel/_module.dm`,
`_maps/map_files/dun_world/dun_world_new.dmm`, and
`_maps/map_files/otherz/wretch_coast_new.dmm` into
`vanderlin.modular_abel.dme`, compiles that temporary DME, and copies the
resulting build artifacts to the normal `vanderlin.dmb`/`vanderlin.rsc` names.
Targets `dm`, `build`, and `server` use the modular DME. Other upstream targets
are passed through without DME injection.

`_maps/dun_world.json` is the downstream map config for the generated map. It is
kept out of the upstream CI map matrix with `exclude_from_ci` until the remaining
fallback replacements are reviewed in-game.

Map rotation is integrated through `modular_abel/map_rotation.dm`, which
registers Dun World in `global.config.maplist` at startup without editing
`config/maps.txt`. `modular_abel/config/maps.dun_world.txt` is also appended to
the generated runtime config overlay for launch paths that rely on
`config-directory=tmp/modular_abel/config`. Targets `dm`, `build`, and `server`
refresh this runtime config overlay; `server` also passes it to DreamDaemon.

For CI, run `modular_abel/ci/pre_build.sh` or
`modular_abel/ci/pre_build.cmd` before modular compile steps. The script prepares
the generated map and the downstream runtime config overlay.

For TGS, point the instance `.tgs.yml` at the modular precompile scripts instead
of the upstream precompile scripts:

```yaml
linux_scripts:
  PreCompile.sh: modular_abel/tgs_scripts/PreCompile.sh
  WatchdogLaunch.sh: tools/tgs_scripts/WatchdogLaunch.sh
  InstallDeps.sh: tools/tgs_scripts/InstallDeps.sh
windows_scripts:
  PreCompile.bat: modular_abel/tgs_scripts/PreCompile.bat
```

The modular TGS precompile script runs `modular_abel/prepare_map.*`, runs the
upstream TGS build target, injects the module and generated map into the
disposable TGS `vanderlin.dme`, and appends the map rotation block to that
disposable checkout's `config/maps.txt`.

The replacement table is populated with Azure Peak path -> Vanderlin path pairs.
Some entries still intentionally fall back to broader parent types where no
local analogue has been confirmed yet.

TODO:
- Continue the fidelity pass for broad fallback replacements in
  `modular_abel/config/dun_world_map.json`. Current high-priority leftovers:
  `chimeric_calyx_spawner`, `littlebanners`, `dungeontool/mover`,
  `trimline/yellow`, `roguerune/god/psydon`, pillows, `mudcrab`,
  `standingbell`/`boatbell`, `flagpole`, `far_travel`, and Azure-only
  heart canisters. Wretch Coast also has broad fallbacks for vampire/inhumen
  areas, keys, ritual circles, Azure-only clothing variants, and old rogue
  tools/weapons.
- Remove `exclude_from_ci` from `_maps/dun_world.json` after the map survives
  the in-game validation pass.
