/*
	Vehicle weapon switch Filterscript (weaponswitch.inc)
	* This filterscript allows you to switch weapons while on a vehicle and shoot!

 	Author: (creator)
	* Gammix

	(c) Copyright 2015
  	* This file is provided as is (no warranties).
*/

#include <a_samp>

#define KEY_SWITCH_NEXT     	KEY_YES //define the key used to switch next weapon (set -1 to disable it)
#define KEY_SWITCH_PREVIOUS     KEY_NO //define the key used to switch previous weapon (set -1 to disable it)

//#define ONLY_PASSENGERS //comment this if you want driver and passenger both to switch weapons

new
	g_CurrentWeapon[MAX_PLAYERS]
;

GetWeaponSlot(weaponid)
{
	switch(weaponid)
	{
		case 0,1: 			return 0;
		case 2 .. 9: 		return 1;
		case 10 .. 15: 		return 10;
		case 16 .. 18, 39: 	return 8;
		case 22 .. 24:		return 2;
		case 25 .. 27: 		return 3;
		case 28, 29, 32: 	return 4;
		case 30, 31: 		return 5;
		case 33, 34: 		return 6;
		case 35 .. 38: 		return 7;
		case 40:	 		return 12;
		case 41 .. 43: 		return 9;
		case 44 .. 46: 		return 11;
	}
	return -1;
}

IsValidWeapon(weaponid)
{
	switch(weaponid)
	{
	    case 22 .. 34: return true;
	}
	return false;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    g_CurrentWeapon[playerid] = GetWeaponSlot(GetPlayerWeapon(playerid));
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new
		w[13],
		a[13]
	;

	for(new i = 0; i != 13; i++)
	{
 		GetPlayerWeaponData(playerid, i, w[i], a[i]);
	}

	#if defined ONLY_PASSENGERS
	if(	IsPlayerInAnyVehicle(playerid) &&
		GetPlayerState(playerid) == PLAYER_STATE_PASSENGER &&
		newkeys & KEY_SWITCH_NEXT)
	#else
	if( IsPlayerInAnyVehicle(playerid) &&
		newkeys & KEY_SWITCH_NEXT)
	#endif
	{
		for(new n = (g_CurrentWeapon[playerid] + 1); n < 12; n++)
		{
			if(	w[n] != 0 &&
				IsValidWeapon(w[n]))
			{
			    g_CurrentWeapon[playerid] = GetWeaponSlot(w[n]);
			    SetPlayerArmedWeapon(playerid, w[n]);
				return 1;
			}
			else if(n == 11)
			{
			    for(new p = 0; p < 12; p++)
			    {
			        if(	w[p] != 0 &&
						IsValidWeapon(w[p]))
					{
					    g_CurrentWeapon[playerid] = GetWeaponSlot(w[p]);
			    		SetPlayerArmedWeapon(playerid, w[p]);
						return 1;
					}
					else if(p == 11)
					{
					    return 1;
					}
			    }
			}
		}
	}

	#if defined ONLY_PASSENGERS
	if(	IsPlayerInAnyVehicle(playerid) &&
		GetPlayerState(playerid) == PLAYER_STATE_PASSENGER &&
		newkeys & KEY_SWITCH_PREVIOUS)
	#else
	if( IsPlayerInAnyVehicle(playerid) &&
		newkeys & KEY_SWITCH_PREVIOUS)
	#endif
	{
		for(new p = (g_CurrentWeapon[playerid] - 1); p > -1; p--)
		{
			if(	w[p] != 0 &&
				IsValidWeapon(w[p]))
			{
			    g_CurrentWeapon[playerid] = GetWeaponSlot(w[p]);
			    SetPlayerArmedWeapon(playerid, w[p]);
				return 1;
			}
			else if(p == 0)
			{
			    for(new n = 12; n > -1; n--)
			    {
			        if(	w[n] != 0 &&
						IsValidWeapon(w[n]))
					{
					    g_CurrentWeapon[playerid] = GetWeaponSlot(w[n]);
			    		SetPlayerArmedWeapon(playerid, w[n]);
						return 1;
					}
					else if(n == 0)
					{
					    return 1;
					}
			    }
			}
		}
	}
	return 1;
}
