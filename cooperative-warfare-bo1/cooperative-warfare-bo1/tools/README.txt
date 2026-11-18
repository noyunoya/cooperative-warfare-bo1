BO1 Operation 40 (cuba) co-op v0.1.0
====================================
First test build. P1 = Mason (host, unchanged), P2 = Woods, P3 = Bowman, P4 = Carlos.

What it does
- A joining player wears the body of "their" hero (Woods/Bowman/Carlos) while that hero exists in the current section.
- The AI copy of that hero is hidden and set to ignore enemies.
- Cutscenes: whenever the AI hero plays a scripted animation of 1.5 s or longer, that player's own model/weapons are hidden
  and the camera is linked to the hero's eyes (tag_eye). Afterwards the player is placed where the hero ended up.

Install
1. Run install_cuba_coop.bat and drag your installed mod folder in (only mod.iwd is replaced; the old one is kept as mod.iwd.orig).
2. Start Operation 40 as host, join with the second player.
3. Debug lines "CUBACOOP v0.1.0 ..." are shown on screen and in the console.

Please report
- Does the mod still load? Does the level start?
- Does P2 wear Woods's body? (line "look copied")
- First cutscene (bar intro): does P2's camera follow Woods? (lines "cutscene camera on/off")
- Anything that gets stuck (hint/objective wait on an AI hero, frozen player, player left in the air).

Known limits of 0.1.0: Mason-only first-person scenes (hands model) are not touched; P2 plays normally during them.
The hook relies on mod.iwd overriding maps/_anim.gsc and maps/cuba.gsc; if the new lines never appear, tell me.
