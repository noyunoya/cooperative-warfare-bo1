// CUBA CO-OP v0.1.0 - Operation 40: every player is one of the squad.
// P1 = Mason (host, unchanged), P2 = Woods, P3 = Bowman, P4 = Carlos.
// Gameplay: the player wears the hero's body, the AI hero is hidden.
// Cutscenes: whenever the AI hero plays a scripted animation, the player's camera is linked to the hero's eyes.
#include common_scripts\utility;
#include maps\_utility;

init()
{
	level.cc_version = "CUBACOOP v0.1.0";
	level.cc_roles = [];
	level.cc_roles[0] = "mason";
	level.cc_roles[1] = "woods";
	level.cc_roles[2] = "bowman";
	level.cc_roles[3] = "carlos";

	cc_print("init, roles Mason/Woods/Bowman/Carlos");
	level thread cc_watch_players();
}

cc_print(msg)
{
	println(level.cc_version + " " + msg);
	iprintln(level.cc_version + " " + msg);
}

cc_watch_players()
{
	level endon("end_game");
	while (1)
	{
		players = get_players();
		for (i = 1; i < players.size && i < level.cc_roles.size; i++)
		{
			if (!IsDefined(players[i].cc_bound))
			{
				players[i].cc_bound = true;
				players[i].cc_role = level.cc_roles[i];
				cc_print("player " + i + " is " + players[i].cc_role);
				players[i] thread cc_human_loop(level.cc_roles[i]);
			}
		}
		wait 1;
	}
}

// keeps one human player in sync with the AI hero of the same name
cc_human_loop(role)
{
	self endon("disconnect");
	while (1)
	{
		ai = undefined;
		if (IsDefined(level.heroes) && IsDefined(level.heroes[role]))
		{
			ai = level.heroes[role];
		}

		if (!IsDefined(ai) || !IsAlive(ai))
		{
			// this hero is not in the current section: the player is just a normal player
			self cc_show_self();
			wait 0.5;
			continue;
		}

		if (!IsDefined(ai.cc_human))
		{
			ai.cc_human = self;
			cc_print(role + ": AI hero bound to player");
		}

		if (!is_true(ai.cc_scene))
		{
			// gameplay: the human plays, the AI copy is hidden and harmless
			ai Hide();
			ai.ignoreme = true;
			ai.ignoreall = true;
			self cc_copy_look(ai);
			self Show();
		}

		wait 0.25;
	}
}

cc_show_self()
{
	if (IsDefined(self.cc_incutscene) && self.cc_incutscene)
	{
		return;
	}
	self Show();
}

// wear the same body (and attached head) as the AI hero
cc_copy_look(ai)
{
	if (IsDefined(self.cc_model) && self.cc_model == ai.model)
	{
		return;
	}

	self DetachAll();
	self SetModel(ai.model);
	n = ai GetAttachSize();
	for (i = 0; i < n; i++)
	{
		self Attach(ai GetAttachModelName(i), ai GetAttachTagName(i));
	}
	self.cc_model = ai.model;
	cc_print("look copied: " + ai.model);
}

// called from maps\_anim::anim_single_thread when the AI hero starts a scripted animation
scene_start(animation)
{
	p = self.cc_human;
	if (!IsDefined(p) || !IsAlive(p))
	{
		return;
	}

	len = GetAnimLength(animation);
	if (len < 1.5)
	{
		return;
	}

	self thread cc_scene_cam(p, len);
}

cc_scene_cam(p, len)
{
	self endon("death");
	p endon("disconnect");

	self notify("cc_scene_new");
	self endon("cc_scene_new");

	cc_print(self.name + ": cutscene camera on, " + len + "s");
	self.cc_scene = true;
	p.cc_incutscene = true;

	self Show();
	p DisableWeapons();
	p Hide();
	p PlayerLinkToAbsolute(self, "tag_eye");

	wait len;
	wait 0.1;

	p Unlink();
	p SetOrigin(self.origin);
	p Show();
	p EnableWeapons();
	p.cc_incutscene = false;
	self.cc_scene = false;
	self Hide();
	cc_print(self.name + ": cutscene camera off");
}
