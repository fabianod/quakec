/* Miscelanneous QuickC program
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

void() play_sound_use =
{
	if (self.spawnflags & SOUND_TOGGLE)
	{
		if (self.state == 0)
		{
			self.state = 1;
			sound (self, self.impulse, self.noise, self.volume, self.speed);
		}
		else
		{
			self.state = 0;
			sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
		}
	}
	else
		sound (self, self.impulse, self.noise, self.volume, self.speed);
};

void() play_sound_think =
{
	local float t;
	t = self.wait*random();

	if (t < self.delay)
		t = self.delay;

	self.nextthink = time + t;
	play_sound_use();
};

/*QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
play a sound when it is used
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"noise" sound to play
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound_triggered =
{
	precache_sound (self.noise);
	precache_sound ("misc/null.wav");

	if (self.volume == 0)
		self.volume = 1;
	if (self.speed == 0)
		self.speed = 1;
	if (self.speed == -1)
		self.speed = 0;

	if (self.spawnflags & SOUND_TOGGLE)
	if (self.impulse == 0)
	 	self.impulse = 7;

	self.use = play_sound_use;
};

/*QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
play a sound on a periodic basis
"volume" how loud (1 default full volume)
"noise" sound to play
"wait" random time between sounds (default 20)
"delay" minimum delay between sounds (default 2)
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound =
{
	local float t;
	
	play_sound_triggered();
	if (self.wait == 0)
		self.wait = 20;
	if (self.delay == 0)
		self.delay = 2;

	self.think = play_sound_think;

	t = self.wait*random();

	if (t < self.delay)
		t = self.delay;

	self.nextthink = time + t;
};

/*QUAKED random_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
"wait" random time between strikes (default 20)
"delay" minimum delay between strikes (default 2)
"volume" how loud (1 default full volume)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() random_thunder =
{
	self.noise = "ambience/thunder1.wav";
	play_sound();
	self.impulse = 6;
};

/*QUAKED random_thunder_triggered (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) toggle
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() random_thunder_triggered =
{
	self.noise = "ambience/thunder1.wav";
	play_sound_triggered();
	self.impulse = 6;
};

/*QUAKED ambient_humming (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_humming =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/humming.wav");
	ambientsound (self.origin, "ambient/humming.wav", self.volume, ATTN_STATIC);
};

/*QUAKED ambient_rushing (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_rushing =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/rushing.wav");
	ambientsound (self.origin, "ambient/rushing.wav", self.volume, ATTN_STATIC);
};

/*QUAKED ambient_running_water (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_running_water =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/runwater.wav");
	ambientsound (self.origin, "ambient/runwater.wav", self.volume, ATTN_STATIC);
};

/*QUAKED ambient_fan_blowing (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_fan_blowing =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/fanblow.wav");
	ambientsound (self.origin, "ambient/fanblow.wav", self.volume, ATTN_STATIC);
};

/*QUAKED ambient_waterfall (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_waterfall =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/waterfal.wav");
	ambientsound (self.origin, "ambient/waterfal.wav", self.volume, ATTN_STATIC);
};

/*QUAKED ambient_riftpower (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
  "volume" how loud it should be (0.5 is default)
*/
void() ambient_riftpower =
{
	if (self.volume == 0)
		self.volume = 0.5;

	precache_sound ("ambient/riftpowr.wav");
	ambientsound (self.origin, "ambient/riftpowr.wav", self.volume, ATTN_STATIC);
};


/*QUAKED info_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
 Stuffs a command into the console to allow map designers
 to set server variables.

 "message" is the command to send to the console.
*/
void() info_command =
{
	if (self.message)
		localcmd(self.message);
};

void() effect_teleport_use =
{
	te_teleport(self.origin);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/	
	sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
};

/*QUAKED effect_teleport (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
 Create a teleport effect when triggered
*/
void() effect_teleport =
{
	precache_sound("misc/r_tele1.wav");
	self.use = effect_teleport_use;
};
