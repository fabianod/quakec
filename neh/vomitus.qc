
void () monster_vomitus =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
	precache_model ("progs/vomitus.mdl");
	precache_sound ("vomit/gf_sbig.wav");
	precache_sound ("vomit/gf_plop.wav");
	precache_sound ("vomit/gf_sprt1.wav");
	precache_sound ("vomit/groan.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/z_shot1.wav");
	self.brain = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 15;
	setmodel (self, "progs/vomitus.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!self.health)
	{
		self.health = 300;
	}
	if ((self.spawnflags & FL_MONSTER))
	{
		self.th_stand = vomit_flat;
		self.th_walk = vomit_rise;
		self.th_run = vomit_rise;
		self.th_missile = vomit_rise;
	}
	else
	{
		self.th_stand = vomit_idle;
		self.th_walk = vomit_motion;
		self.th_run = vomit_motion;
		self.th_missile = vomit_vomit;
	}
	self.th_die = vomit_die;
	self.th_pain = vomit_ouchie;
	walkmonster_start ();
};

void () vomit_ouchie =
{
	if ((self.pain_finished > time))
	{
		return;
	}
	self.pain_finished = (time + 2);
	sound (self, CHAN_WEAPON, "vomit/groan.wav", 1, ATTN_NORM);
	vomit_motion ();
};

void () vomit_flat = [ 63, vomit_flat ]
{
	ai_stand ();
};

void () vomit_dead =
{
	self.nextthink = (time + 20);
	self.think = corpse_think;
};

void () vomit_rise =
{
	self.pain_finished = (time + 1);
	self.walkframe = 0;
	sound (self, CHAN_WEAPON, "vomit/gf_sbig.wav", 1, ATTN_NORM);
	vomit_riseup ();
};

void () vomit_riseup =
{
	if ((self.walkframe >= 16))
	{
		self.walkframe = 0;
		self.th_stand = vomit_idle;
		self.th_walk = vomit_motion;
		self.th_run = vomit_motion;
		self.th_missile = vomit_vomit;
		vomit_motion ();
		return;
	}
	state [ 48, vomit_riseup ];
	self.frame = (63 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () vomit_idle =
{
	if ((self.walkframe >= 26))
	{
		self.walkframe = 0;
		sound (self, CHAN_WEAPON, "vomit/gf_plop.wav", 1, ATTN_NORM);
	}
	state [ 0, vomit_idle ];
	self.frame = self.walkframe;
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () vomit_motion =
{
	if ((self.walkframe >= 26))
	{
		self.walkframe = 0;
	}
	state [ 0, vomit_motion ];
	self.frame = self.walkframe;
	self.walkframe = (self.walkframe + 1);
	if ((self.enemy != world))
	{
		ai_run (0.5);
	}
	else
	{
		ai_walk (0.5);
	}
};

void () vomit_vomit =
{
	self.pain_finished = (time + 1);
	self.walkframe = 0;
	sound (self, CHAN_WEAPON, "vomit/gf_sprt1.wav", 1, ATTN_NORM);
	if ((random () < 0.5))
	{
		vomit_barf1 ();
	}
	else
	{
		vomit_barf2 ();
	}
};

void () vomit_barf1 =
{
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
		vomit_motion ();
		return;
	}
	state [ 27, vomit_barf1 ];
	self.frame = (27 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	if (((self.frame > 30) && (self.frame < 33)))
	{
		vomit_chunks ();
	}
};

void () vomit_barf2 =
{
	if ((self.walkframe >= 14))
	{
		self.walkframe = 0;
		vomit_motion ();
		return;
	}
	state [ 34, vomit_barf2 ];
	self.frame = (34 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	if (((self.frame > 41) && (self.frame < 44)))
	{
		vomit_chunks ();
	}
};

void () vomit_die =
{
	if ((self.health < -65))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	self.walkframe = 0;
	sound (self, CHAN_WEAPON, "vomit/groan.wav", 1, ATTN_NORM);
	vomit_deflate ();
};

void () vomit_deflate =
{
	if ((self.walkframe >= 16))
	{
		self.walkframe = 0;
		vomit_dead ();
		return;
	}
	state [ 48, vomit_deflate ];
	self.frame = (48 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe == 15))
	{
		self.solid = SOLID_NOT;
	}
};

void () vomit_chunks =
{
	blow_chunks ();
};

void () blow_chunks =
{
	local entity missile;
//	local entity mpuff;
	local vector org;
	local float num;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin + (v_forward * 20);
	if ((random () < 0.5))
	{
		org = org + (v_right * 3);
	}
	else
	{
		org = org + (v_right * -3);
	}
	makevectors (self.angles);
	missile.velocity = normalize ((self.enemy.origin - org));
	missile.velocity = (missile.velocity * 810);
	missile.velocity_z = (300 * random ());
	missile.avelocity = '2000 1500 1900';
	missile.touch = ZombieGrenadeTouch;
	missile.nextthink = (time + 2.5);
	missile.think = SUB_Remove;
	num = random ();
	if ((num < 0.2))
	{
		setmodel (missile, "progs/gib1.mdl");
	}
	else
	{
		if ((num < 0.7))
		{
			setmodel (missile, "progs/gib2.mdl");
		}
		else
		{
			setmodel (missile, "progs/gib3.mdl");
		}
	}
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, org);
};
