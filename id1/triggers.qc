void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;	//SOLID_BSP;
	}
};

// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	local entity blinker;

	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;

		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);

		blinker = find(world, classname, "secret_blinker");
		while (blinker != world)
		{
			if (blinker.goalentity == self)
			{
				remove(blinker);
				break;
			}
			else
				blinker = find(blinker, classname, "secret_blinker");
		}
	}

/*	else
	{
//		RemoveBlinkers();

		while (blinker != world)
		{
//			print("removing ", etos(blinker), "\n");

			remove(blinker);
			blinker = find(world, classname, "secret_blinker");
		}



	}
*/

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;
	
	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
#ifdef HIPNOTIC
	if (self.cnt > 0)
	{
		self.cnt = self.cnt - 1;
		if (self.cnt == 0)
		{
			 self.touch = SUB_Null;
			 self.nextthink = time + 0.1;
			 self.think = SUB_Remove;
		}
	}
#endif
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;
	
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.
If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
"cnt" how many times it can be triggered (infinite default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_multiple =
{
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}
	
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");

		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;		//SOLID_BSP;

		setorigin (self, self.origin);	//0.5*(self.absmin + self.absmax)	// make sure it links into the world

//		if (self.dest1 != VEC_0 && self.dest2 != VEC_0)
//			setsize(self, self.dest1, self.dest2);
//		else
//			setsize(self, self.dest1, self.dest2);


	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
#ifdef HIPNOTIC
	if (self.cnt == 0)
		self.cnt = -1;
#endif
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void() trigger_secret =
{
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;
	
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple ();
};

//=============================================================================


void() counter_use =
{
//	local string junk;

	self.count = self.count - 1;
	if (self.count < 0)
		return;
	
	if (self.count != 0)
	{
		if ((activator.classname == "player") && !(self.spawnflags & SPAWNFLAG_NOMESSAGE))
		{
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
		}
		return;
	}
	
	if ((activator.classname == "player") && !(self.spawnflags & SPAWNFLAG_NOMESSAGE))
		centerprint(activator, "Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};


/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/
void() play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	local entity s;

	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	te_teleport(org);
};


void() tdeath_touch =
{
	if (other == self.owner)
		return;

//	print(etos(self), " ", etos(other), "\n");
//	eprint(self);
//	eprint(other);

	if (other.classname == "bodyque")
	if (other.aiment == self.owner)	
		return;

// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000, "telefrag");
			return;
		}

		if (other.invincible_finished > time)
		{	//player on spot has active pentagram
			if (self.owner.invincible_finished > time)
			{	// teleported player has active pentagram too
				// can happen often in deathmatch 4
				// and levels with more than one pentagram
				self.classname = "teledeath3";
				other.invincible_finished = 0;

				T_Damage (other, self, self, 50000, "telefrag");	// kill player on spot

				local entity other2;
				other2 = self.owner;
				self.owner = other;
				other2.invincible_finished = 0;

				T_Damage (other2, self, self, 50000, "telefrag");	// kill teleported player
			}
			else	
			{	
				self.classname = "teledeath2";
				T_Damage (self.owner, self, self, 50000, "telefrag");
			}
			return;
		}

		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000, "telefrag");
			return;
		}
		
	}

	if (other.health > 0)
	{
		T_Damage (other, self, self, 50000, "telefrag");
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
	local 	entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void() teleport_touch =
{
	local 	entity	t;
	local 	vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & SPAWNFLAG_PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath (t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);

	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = TRUE;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";

	self.origin = self.origin + '0 0 27';

	if (!self.targetname)
		objerror ("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SPAWNFLAG_SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
	}
};

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void() trigger_skill_touch =
{
	if (other.classname != "player")
		return;
		
	cvar_set ("skill", self.message);
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void() trigger_onlyregistered_touch =
{
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint (other, self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

#ifdef HIPNOTIC
void( entity ent, float amount ) hurt_setdamage =
{
	ent.dmg = amount;
	if (!amount)
		ent.solid = SOLID_NOT;
	else
		ent.solid = SOLID_TRIGGER;
	ent.nextthink = -1;
};
#endif

.float hurt_time; 

void() hurt_touch =
{
	if (other == self.owner)
		return;

	if (other.takedamage)
//	if (!(other.flags & FL_CORPSE))
	{
		//self.solid = SOLID_NOT;
//		if (time != self.hurt_together_time)
//		if (time < self.hurt_nextthink)
//				return;

		force_retouch = 3;

		if (other.hurt_time > time)
			return;

//		print("hurt other health=", ftos(other.health), " time=", ftos(time), "\n");

		T_Damage (other, self, self, self.dmg, "");

//		self.think = hurt_on;
//		self.nextthink = time + 1;

//		self.hurt_together_time = time + 0.01;
//		self.hurt_nextthink = time + 1;

		other.hurt_time = self.nextthink;

#ifdef HIPNOTIC
		if (self.cnt > 0)
		{
			self.cnt = self.cnt - 1;
			if (self.cnt == 0)
			{
				self.touch = SUB_Null;
				self.nextthink = time + 0.1;
				self.think = SUB_Remove;
			}
		}
#endif
	}
//	return;
};

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
//	self.touch = hurt_touch;
//	self.nextthink = -1;
	self.nextthink = time + self.delay;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
default dmg = 5
"cnt" default infinite, how many times to trigger
*/
void() trigger_hurt =
{
	local entity t;

	InitTrigger ();

	self.touch = hurt_touch;

	self.solid = SOLID_NOT;
	self.think = hurt_on;

	if (!self.delay)
		self.delay = 1;

	self.nextthink = time + self.delay;

	if (!self.dmg)
		self.dmg = 5;

//find some linked ent and setup it as an owner (for proper shub obituary)
	if (self.target != "")
	{
		t = world;
		do
		{
			t = find(t, targetname, self.target);
			if (!t)
				return;
			self.owner = t;
			return;
		} while (TRUE);
	}

#ifdef HIPNOTIC
	if (self.cnt == 0)
		self.cnt = -1;
#endif
};

//============================================================================

void() trigger_push_touch =
{
	if (self.targetname)
	if (self.nextthink < time)
		return;		// not fired yet

//	if (other.classname == "grenade")
//	if (other.movetype == MOVETYPE_BOUNCE || other.movetype == MOVETYPE_TOSS)
//		other.velocity = self.speed*self.movedir*10;

	if (other.movetype != MOVETYPE_NONE)
	if (other.movetype != MOVETYPE_NOCLIP)
	if (other.health > 0 || other.movetype == MOVETYPE_BOUNCE || other.movetype == MOVETYPE_TOSS)
	{
		SUB_UseTargets ();

//		if (self.spawnflags & SPAWNFLAG_PUSH_ORIGIN)
//			setorigin(other, 0.5*(self.absmin + self.absmax));

		other.velocity = self.speed*self.movedir*10;

		// launch target up in air if facing upwards		
		if (self.movedir_z > 0.25)	// approx. 15 deg
			other.flags = other.flags - (other.flags & FL_ONGROUND);

		if (other.classname == "player")
		if (other.health > 0)
		if (other.fly_sound < time)
		{
			other.fly_sound = time + 1.5;
			sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
		}

		if (self.spawnflags & SPAWNFLAG_PUSH_ONCE)
			remove(self);
	}
};

void() trigger_push_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE PUSH_DIRECTION
Pushes the player
*/
void() trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");

	self.touch = trigger_push_touch;

	if (self.targetname)
		self.use = trigger_push_use;

	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if (!(other.flags & FL_ONGROUND))
		return;
	
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;

#ifdef HIPNOTIC
	if (self.cnt > 0)
	{
		self.cnt = self.cnt - 1;
		if (self.cnt == 0)
		{
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
#endif

};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
"cnt" default infinite, how many times to trigger
*/
void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';

#ifdef HIPNOTIC
	if (self.cnt == 0)
		self.cnt = -1;
#endif

	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

