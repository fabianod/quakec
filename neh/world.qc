
void () main =
{
	dprint ("main function\n");
	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");
	precache_file ("end1.bin");
	precache_file2 ("end2.bin");
	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");
	precache_file2 ("gfx/pop.lmp");
	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");
	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");
	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");
	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	precache_file ("gfx/mp_menu.lmp");
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	precache_file ("gfx/sell.lmp");
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");
	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");
	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");
	precache_file ("gfx/it/res1.lmp");
	precache_file ("gfx/it/res3.lmp");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");
	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");
	precache_file ("maps/start.bsp");
	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");
	precache_file2 ("gfx/pop.lmp");
	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");
	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");
	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");
	precache_file2 ("maps/end.bsp");
	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};

void () worldspawn =
{
	lastspawn = world;
	InitBodyQue ();
	if ((self.model == "maps/e1m8.bsp"))
	{
		cvar_set ("sv_gravity", "100");
	}
	else
	{
		cvar_set ("sv_gravity", "800");
	}
	W_Precache ();
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	precache_sound ("weapons/autos.wav");
	precache_sound ("demon/dland2.wav");
	precache_sound ("weapons/sprwall.wav");
	precache_sound ("misc/h2ohit1.wav");
	precache_sound ("items/itembk2.wav");
	precache_sound ("player/flight.wav");
	precache_sound ("player/plyrjmp8.wav");
	precache_sound ("player/land.wav");
	precache_sound ("player/land2.wav");
	precache_sound ("player/drown1.wav");
	precache_sound ("player/drown2.wav");
	precache_sound ("player/gasp1.wav");
	precache_sound ("player/gasp2.wav");
	precache_sound ("player/h2odeath.wav");
	precache_sound ("misc/talk.wav");
	precache_sound ("player/teledth1.wav");
	precache_sound ("misc/r_tele1.wav");
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");
	precache_sound ("weapons/pkup.wav");
	precache_sound ("items/armor1.wav");
	precache_sound ("weapons/lhit.wav");
	precache_sound ("weapons/lstart.wav");
	precache_sound ("items/damage3.wav");
	precache_sound ("misc/power.wav");
	precache_sound ("player/gib.wav");
	precache_sound ("player/udeath.wav");
	precache_sound ("player/tornoff2.wav");
	precache_sound ("player/foot1.wav");
	precache_sound ("player/foot2.wav");
	precache_sound ("player/foot3.wav");
	precache_sound ("player/foot4.wav");
	precache_sound ("player/foot5.wav");
	precache_sound ("player/foot6.wav");
	precache_sound ("player/foot7.wav");
	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");
	precache_sound ("player/dedrise.wav");
	precache_sound ("player/razd1.wav");
	precache_sound ("player/razd2.wav");
	precache_sound ("player/razh20.wav");
	precache_sound ("weapons/ax1.wav");
	precache_sound ("player/axhit1.wav");
	precache_sound ("player/axhit2.wav");
	precache_sound ("player/h2ojump.wav");
	precache_sound ("player/slimbrn2.wav");
	precache_sound ("player/inh2o.wav");
	precache_sound ("player/inlava.wav");
	precache_sound ("misc/outwater.wav");
	precache_sound ("player/lburn1.wav");
	precache_sound ("player/lburn2.wav");
	precache_sound ("misc/water1.wav");
	precache_sound ("misc/water2.wav");
	precache_sound ("ambience/windfly.wav");
	precache_sound ("ambience/amsizl.wav");
	precache_sound ("wall/statslid.wav");
	precache_sound ("wall/barslide.wav");
	precache_sound ("weapons/nailgun.wav");
	precache_model ("progs/player1.mdl");
	precache_model ("progs/player2.mdl");
	precache_model ("progs/player.mdl");
	precache_model ("progs/s_null.spr");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
	precache_model ("progs/fgib1.mdl");
	precache_model ("progs/fgib2.mdl");
	precache_model ("progs/fgib3.mdl");
	precache_model ("progs/s_bubble.spr");
	precache_model ("progs/s_explod.spr");
	precache_model ("progs/mv_nad.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/mv_rock2.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");
	precache_model ("progs/bolt.mdl");
	precache_model ("progs/bolt2.mdl");
	precache_model ("progs/bolt3.mdl");
	precache_model ("progs/beam.mdl");
	precache_model ("progs/lavaball.mdl");
	precache_model ("progs/flame2.mdl");
	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/sprocket.mdl");
	precache_model ("progs/mv_sh2.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");
	precache_model ("progs/backpack.mdl");
	precache_model ("progs/zom_gib.mdl");
	precache_model ("progs/v_light.mdl");
	precache_model ("progs/h_jack.mdl");

	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");

	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");

	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");

	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");

	if ((cvar ("nospr32") == 0))
	{
		precache_model ("sprites/explode1.spr32");
		precache_model ("sprites/explode3.spr32");
		precache_model ("sprites/explode4.spr32");
	}
	lightstyle (0, "m");
	lightstyle (1, "mmnmmommommnonmmonqnmmo");
	lightstyle (FL_SWIM, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle (MOVETYPE_WALK, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle (MOVETYPE_STEP, "mamamamamama");
	lightstyle (MOVETYPE_FLY, "jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle (MOVETYPE_TOSS, "nmonqnmomnmomomno");
	lightstyle (MOVETYPE_PUSH, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle (FL_CLIENT, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle (MOVETYPE_FLYMISSILE, "aaaaaaaazzzzzzzz");
	lightstyle (MOVETYPE_BOUNCE, "mmamammmmammamamaaamammma");
	lightstyle (MOVETYPE_BOUNCEMISSILE, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle (12, "aaaaaaaaaaaaaaazaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
	lightstyle (13, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaz");
	lightstyle (15, "zzzzzzzzzzzzzwwspljgdacfinrtvxzzzzzzzzzz");
	lightstyle (16, "mmmmmmmmmmmmnopqrqponmmmmmmmmmmnpqrqpnmmmmmmmortvwxyxwvtro");
	lightstyle (17, "nnnnnnnnnnnanananannnnnnnnnnn");
	lightstyle (18, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaz");
	lightstyle (19, "azazbycxdwevfugthsirjqkplolnmnlolpkqjrishtgufvewdxcyb");
	lightstyle (63, "a");

	SV_AddStat(STAT_QUADTIME, 8, super_damage_finished);
	SV_AddStat(STAT_PENTTIME, 8, invincible_finished);
	SV_AddStat(STAT_SUITTIME, 8, radsuit_finished);
	SV_AddStat(STAT_INVISTIME, 8, invisible_finished);
	SV_AddStat(STAT_FLIGHTTIME, 8, fly_finished);

};

void () StartFrame =
{
	teamplay = cvar ("teamplay");
	skill = cvar ("skill");
	framecount = framecount + 1;
};

void () bodyque =
{
};

/*
void () InitBodyQue =
{
//	local entity e;

	bodyque_head = spawn ();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn ();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn ();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn ();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};
*/

void() InitBodyQue = 

{
	local entity e, prev;
	local float numBodies, num;
	numBodies = 32; // how many player corpses to allow in the world at once
	
	num = 0;
	prev = world;
	bodyque_head = world;

 	while(num < numBodies) {
		// Spawn another body
		e = spawn();
		e.classname = "bodyque";

		// If this is the first, set the bodyque_head pointer (start of the list)
		if(bodyque_head == world)
			bodyque_head = e;
		// Link up to previous item to form the linked list
		if(prev != world)
			e.owner = prev;
		// Point prev to the new item
		prev = e;
	
		// Track how many we've made so we don't have an infinite loop
		num = num + 1;
	}

	// Now that all corpse entities are created, turn the linked list into a linked loop
	bodyque_head.owner = prev;
};


void (entity ent) CopyToBodyQue =
{
	bodyque_head.avelocity = VEC_ORIGIN;
	bodyque_head.angles = ent.angles;
	bodyque_head.skin = ent.skin;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};
