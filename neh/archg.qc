
void () GauntLightning =
{
	local vector org;
	local vector dir;

	if ((self.classname == self.enemy.classname))
	{
		return;
	}
	self.effects = (self.effects | EF_MUZZLEFLASH);
	ai_face ();
	if (((self.classname == "monster_gaunt") || (self.classname == "the_mister")))
	{
		org = self.origin + '0 0 20';
	}
	else
	{
		if ((random () < 0.4))
		{
			org = self.origin + (v_right * 5);
		}
		else
		{
			org = self.origin + (v_right * -5);
		}
		org = org + (v_forward * -10);
		org = org + '0 0 30';
	}
	dir = (self.enemy.origin + '0 0 16') - org;
	dir = normalize (dir);
	traceline (org, (self.origin + (dir * 600)), 1, self);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_BEAM);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	LightningDamage (org, trace_endpos, self, MOVETYPE_TOSS);
};

void (entity missile) TossBackGrenade =
{
	local vector megadeth;

	if ((random () < 0.1))
	{
		sound (self.enemy, CHAN_AUTO, "archg/lift.wav", 1, ATTN_NORM);
	}
	megadeth = missile.origin - missile.owner.origin;
	if ((vlen (megadeth) > 175))
	{
		missile.owner = self;
	}
	missile.velocity = normalize ((self.enemy.origin - self.origin));
	missile.velocity = (missile.velocity * 600);
	missile.velocity_z = 300;
	missile.angles = vectoangles (missile.velocity);
	if ((missile.aflag != 6066))
	{
		missile.aflag = 6066;
		return;
	}
	missile.nextthink = (time + 2.5);
	missile.think = GrenadeExplode;
};

void () Handle_Threats =
{
	local entity tthreat;
	local vector dave;
	local float num;

	tthreat = find (world, event, "thrett");
	while (tthreat)
	{
		dave = tthreat.origin - self.origin;
		if ((vlen (dave) < 250))
		{
			if ((tthreat.classname != "player"))
			{
				if ((tthreat.classname == "grenade"))
				{
					TossBackGrenade (tthreat);
				}
				else
				{
					if ((self.flags & FL_ONGROUND))
					{
						self.flags = (self.flags - FL_ONGROUND);
					}
					num = self.origin_z + 30;
					if ((tthreat.origin_z < num))
					{
						self.velocity_x = 0;
						self.velocity_y = 0;
						self.velocity_z = 250;
						tthreat.angles = (tthreat.angles - '0 0 50');
						tthreat.velocity_z = (tthreat.velocity_z - 700);
					}
					else
					{
						tthreat.angles = (tthreat.angles + '0 0 50');
						tthreat.velocity_z = (tthreat.velocity_z + 600);
					}
					if ((random () < 0.05))
					{
						sound (self.enemy, CHAN_AUTO, "archg/lift3.wav", 1, ATTN_NORM);
					}
				}
			}
		}
		tthreat = find (tthreat, event, "thrett");
	}
};

void () ThrashEnemy =
{
	local entity thrashed;

	thrashed = self.enemy;
	if ((thrashed.flags & FL_ONGROUND))
	{
		thrashed.flags = (thrashed.flags - FL_ONGROUND);
		thrashed.velocity_z = (800 * random ());
	}
	else
	{
		if ((random () < 0.5))
		{
			thrashed.velocity_z = (400 * random ());
		}
	}
	if ((random () < 0.5))
	{
		thrashed.velocity_x = (500 * random ());
	}
	else
	{
		thrashed.velocity_x = (-500 * random ());
	}
	if ((random () < 0.5))
	{
		thrashed.velocity_y = (500 * random ());
	}
	else
	{
		thrashed.velocity_y = (-500 * random ());
	}
};

void () archgaunt_funeral =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setsize (self, VEC_HULL_MIN, '12 12 48');
	self.health = 500;
	archgaunt_funeral2 ();
};

void () archgaunt_funeral2 = [ 113, archgaunt_funeral2 ]
{
};

void () monster_archgaunt =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
	precache_model2 ("progs/archg.mdl");
	precache_model2 ("progs/h_archg.mdl");
	precache_model2 ("progs/gntspke.mdl");
	precache_model2 ("progs/rubble1.mdl");
	precache_model2 ("progs/rubble2.mdl");
	precache_model2 ("progs/rubble3.mdl");
	precache_model2 ("progs/rubble4.mdl");
	precache_model2 ("progs/rubble5.mdl");
	precache_model2 ("progs/rubble6.mdl");
	precache_model2 ("progs/book.mdl");
	precache_model2 ("progs/gring.mdl");
	precache_sound2 ("weapons/lhit.wav");
	precache_sound2 ("gaunt/spkhit.wav");
	precache_sound2 ("gaunt/elekt.wav");
	precache_sound2 ("gaunt/gspike.wav");
	precache_sound2 ("gaunt/boom.wav");
	precache_sound2 ("archg/lift.wav");
	precache_sound2 ("archg/lift3.wav");
	precache_sound2 ("archg/fire2.wav");
	precache_sound2 ("wall/wall01.wav");
	precache_sound2 ("archg/petrify.wav");
	precache_sound2 ("archg/pain.wav");
	precache_sound2 ("archg/melt.wav");
	precache_sound2 ("boss3/nehdie4.wav");
	if (!(self.brain & NAVLOGIC))
	{
		self.brain = (self.brain | NAVLOGIC);
	}
	self.cnt = 0;
	self.aflag = 0;
	if ((self.spawnflags & FL_GODMODE))
	{
		self.movetype = MOVETYPE_STEP;
		self.takedamage = DAMAGE_YES;
		self.th_die = gaunt_gibs;
		setmodel (self, "progs/archg.mdl");
		setsize (self, VEC_HULL_MIN, '12 12 6');
		archgaunt_funeral ();
		return;
	}
	self.th_stand = archg_stand;
	self.th_walk = archg_motion;
	self.th_run = archg_motion;
	self.th_missile = archg_control;
	self.th_pain = archg_pain;
	self.th_die = archg_die;
	self.th_wins = archg_bow1;
	self.th_greet = archg_bow1;
	if ((self.brain & TRIGGER_SPAWN))
	{
		self.use = archgaunt_start;
		return;
	}
	carnify_archgaunt ();
};

void () archgaunt_start =
{
	trigger_spawnmonster ();
	carnify_archgaunt ();
};

void () carnify_archgaunt =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/archg.mdl");
	setsize (self, VEC_HULL_MIN, '12 12 90');
	if (!self.health)
	{
		self.health = 500;
	}
	walkmonster_start ();
};

void () archg_die =
{
	if ((self.health < -35))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_archg.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	self.skin = 1;
	self.think = gotostone;
	self.nextthink = (time + 0.1);
};

void () gotostone =
{
	sound (self, CHAN_VOICE, "archg/petrify.wav", 1, ATTN_NORM);
	self.event = "stone";
	go_tostone ();
};

void () go_tostone =
{
	self.skin = (self.skin + 1);
	if ((self.skin > 5))
	{
		becomestatue ();
		return;
	}
	self.nextthink = (time + 0.2);
	self.think = go_tostone;
};

void () becomestatue =
{
	self.flags = FL_BLOODLESS;
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_BBOX;
	self.health = 60;
	self.touch = player_push;
	self.th_die = statue_blown;
	self.th_pain = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;
};

void () statue_blown =
{
	self.dmg = 11;
	sound (self, CHAN_BODY, "wall/wall01.wav", 1, ATTN_NORM);
	self.dmg = 1;
	ThrowRubble ("progs/rubble2.mdl", self.health);
	ThrowRubble ("progs/rubble3.mdl", self.health);
	ThrowRubble ("progs/rubble4.mdl", self.health);
	ThrowRubble ("progs/h_archg.mdl", self.health);
	remove (self);
};

void () archg_motion =
{
	if ((self.walkframe >= 13))
	{
		self.walkframe = 0;
		if ((random () < 0.1))
		{
			if (((self.relations > 2) && (self.enemy == world)))
			{
				if (scan_for_goodies ())
				{
					archg_ai3 ();
					return;
				}
			}
		}
		state [ 67, archg_control ];
		return;
	}
	state [ 54, archg_motion ];
	self.frame = (54 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_run (4);
		if (visible (self.enemy))
		{
			ai_face ();
		}
		return;
	}
	ai_walk (4);
};

void () archg_stand =
{
	if ((self.walkframe >= 7))
	{
		self.walkframe = 0;
		state [ 8, archg_control ];
		return;
	}
	state [ 0, archg_stand ];
	self.frame = (0 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_face ();
	}
	else
	{
		ai_stand ();
	}
};

void () archg_look =
{
	if ((self.walkframe >= 18))
	{
		self.walkframe = 0;
		state [ 27, archg_control ];
		return;
	}
	state [ 9, archg_motion ];
	self.frame = (0 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_face ();
	}
	else
	{
		ai_stand ();
	}
};

void () archg_bow1 =
{
	if ((self.walkframe >= 14))
	{
		self.walkframe = 0;
		state [ 42, archg_bow2 ];
		return;
	}
	state [ 28, archg_bow1 ];
	self.frame = (28 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_face ();
	}
	else
	{
		if ((self.objekt != world))
		{
			ai_face_objekt ();
		}
		else
		{
			ai_stand ();
		}
	}
};

void () archg_bow2 =
{
	if ((self.walkframe >= 14))
	{
		self.walkframe = 0;
		state [ 28, archg_control ];
		return;
	}
	state [ 28, archg_bow2 ];
	self.frame = (42 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_face ();
	}
	else
	{
		if ((self.objekt != world))
		{
			ai_face_objekt ();
		}
		else
		{
			ai_stand ();
		}
	}
};

void () archg_up =
{
	if ((self.walkframe >= 10))
	{
		self.walkframe = 0;
		state [ 43, archg_control ];
		return;
	}
	state [ 43, archg_up ];
	self.frame = (43 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe == 4))
	{
		if ((random () < 0.5))
		{
			sound (self.enemy, CHAN_BODY, "archg/lift3.wav", 1, ATTN_NORM);
		}
		else
		{
			sound (self.enemy, CHAN_BODY, "archg/lift.wav", 1, ATTN_NORM);
		}
	}
	if ((((self.walkframe > 4) && (self.walkframe < 9)) && (self.enemy != world)))
	{
		ThrashEnemy ();
	}
	ai_face ();
	Handle_Threats ();
};

void () archg_pain =
{
	if ((self.pain_finished > time))
	{
		return;
	}
	self.pain_finished = (time + 1.2);
	sound (self.enemy, CHAN_AUTO, "archg/pain.wav", 1, ATTN_NORM);
	if ((random () < 0.4))
	{
		archg_up ();
		return;
	}
	if ((random () < 0.5))
	{
		state [ 73, archg_pain1 ];
	}
	else
	{
		state [ 76, archg_painb2 ];
	}
};

void () archg_pain1 = [ 74, archg_pain2 ]
{
};

void () archg_pain2 = [ 75, archg_pain3 ]
{
};

void () archg_pain3 = [ 76, archg_pain4 ]
{
};

void () archg_pain4 = [ 75, archg_pain5 ]
{
};

void () archg_pain5 = [ 74, archg_pain6 ]
{
};

void () archg_pain6 = [ 73, archg_pain7 ]
{
};

void () archg_pain7 = [ 72, archg_pain8 ]
{
};

void () archg_pain8 = [ 71, archg_pain9 ]
{
};

void () archg_pain9 = [ 70, archg_pain10 ]
{
};

void () archg_pain10 = [ 69, archg_pain11 ]
{
};

void () archg_pain11 = [ 68, archg_control ]
{
};

void () archg_painb2 = [ 75, archg_painb3 ]
{
};

void () archg_painb3 = [ 74, archg_painb4 ]
{
};

void () archg_painb4 = [ 71, archg_painb5 ]
{
};

void () archg_painb5 = [ 70, archg_painb6 ]
{
};

void () archg_painb6 = [ 69, archg_control ]
{
};

void () archg_att = [ 68, archg_att1 ]
{
	ai_face ();
};

void () archg_att1 = [ 69, archg_att2 ]
{
	ai_face ();
};

void () archg_att2 = [ 70, archg_att3 ]
{
	ai_face ();
};

void () archg_att3 = [ 71, archg_att4 ]
{
	ai_face ();
	sound (self, CHAN_VOICE, "gaunt/boom.wav", 1, ATTN_NORM);
};

void () archg_att4 = [ 72, archg_att5 ]
{
	ai_face ();
	GauntMissile ();
	sound (self, CHAN_BAL, "gaunt/elekt.wav", 1, ATTN_NORM);
};

void () archg_att5 = [ 73, archg_att6 ]
{
	ai_face ();
};

void () archg_att6 = [ 72, archg_att7 ]
{
	ai_face ();
	GauntMissile ();
};

void () archg_att7 = [ 70, archg_att8 ]
{
	ai_face ();
};

void () archg_att8 = [ 69, archg_att9 ]
{
	ai_face ();
};

void () archg_att9 = [ 68, archg_control ]
{
	ai_face ();
};

void () archg_attack =
{
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
		state [ 76, archg_attack2 ];
		return;
	}
	state [ 68, archg_attack ];
	self.frame = (68 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe > 5))
	{
		gaunt_ring (1);
		gaunt_ring (2);
	}
	ai_face ();
};

void () archg_attack2 =
{
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
		archg_control ();
		return;
	}
	state [ 68, archg_attack2 ];
	self.frame = (76 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe < 3))
	{
		if ((random () < 0.4))
		{
			gaunt_ring (1);
		}
		else
		{
			gaunt_ring (2);
		}
	}
	ai_face ();
};

void () archg_control =
{
	local float a;

	if (borkfactor1 ())
	{
		return;
	}
	self.walkframe = 0;
	if ((self.enemy == world))
	{
		if ((self.goalentity == world))
		{
			archg_stand ();
			return;
		}
		archg_motion ();
		return;
	}
	if (((self.relations < 2) && (self.enemy.classname == "monster_gaunt")))
	{
		self.threat = self.enemy;
		archg_ai3 ();
		return;
	}
	if ((!visible (self.enemy) || (self.enemy.health < 1)))
	{
		archg_motion ();
		return;
	}
	a = random ();
	if ((a < 0.5))
	{
		archg_up ();
		return;
	}
	if ((a < 0.7))
	{
		archg_attack ();
		return;
	}
	state [ 68, archg_att ];
};

void () archg_ai3 =
{
	if (self.enemy)
	{
		self.pain_finished = (time + 1);
	}
	self.walkframe = 0;
	self.threat = self.enemy;
	self.enemy = world;
	archg_point ();
};

void () archg_point =
{
	if ((self.walkframe >= 5))
	{
		self.walkframe = 0;
		if ((self.threat.flags & FL_MONSTER))
		{
			if ((self.threat.enemy == self))
			{
				if ((((random () < 0.5) && (self.threat.classname == "monster_gaunt")) && (self.threat.health > 20)))
				{
					self.threat.think = self.threat.th_mourn;
				}
				self.enemy = find (world, classname, "player");
				self.threat.enemy = self.enemy;
				archg_no ();
				return;
			}
		}
		archg_hold ();
		return;
	}
	state [ 90, archg_point ];
	self.frame = (90 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai2_face (self.threat);
};

void () archg_no =
{
	if ((self.walkframe >= 12))
	{
		self.walkframe = 0;
		self.threat = world;
		archg_nofinger ();
		return;
	}
	state [ 101, archg_no ];
	self.frame = (101 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai2_face (self.threat);
};

void () archg_nofinger =
{
	if ((self.walkframe >= 5))
	{
		self.walkframe = 0;
		self.threat = world;
		if (self.enemy)
		{
			self.th_run ();
		}
		else
		{
			self.th_stand ();
		}
		return;
	}
	state [ 90, archg_nofinger ];
	self.frame = (94 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () archg_hold =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		if ((random () < 0.2))
		{
			self.threat = world;
			archg_nofinger ();
			return;
		}
	}
	state [ 95, archg_hold ];
	self.frame = (95 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai2_face (self.threat);
};

float () scan_for_goodies =
{
	local entity head;
	local entity selected;
	local float dist;

	dist = 500;
	selected = world;
	head = findradius (self.origin, 500);
	while (head)
	{
		if ((trace_plane_dist < 500))
		{
			if ((head.event == "relic"))
			{
				selected = head;
				dist = trace_plane_dist;
			}
		}
		head = head.chain;
	}
	if ((selected == world))
	{
		return (0);
	}
	else
	{
		self.threat = selected;
		return (1);
	}
};
