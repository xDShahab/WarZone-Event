ESX = nil 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:xCooreShared", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local weapons = {
	'WEAPON_DAGGER',
	'WEAPON_BAT',
	'WEAPON_BOTTLE',
	'WEAPON_CROWBAR',
	'WEAPON_UNARMED',
	'WEAPON_FLASHLIGHT',
	'WEAPON_GOLFCLUB',
	'WEAPON_HAMMER',
	'WEAPON_HATCHET',
	'WEAPON_KNUCKLE',
	'WEAPON_KNIFE',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_WRENCH',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_STONE_HATCHET',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_STUNGUN',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_DOUBLEACTION',
	'WEAPON_RAYPISTOL',
	'WEAPON_CERAMICPISTOL',
	'WEAPON_NAVYREVOLVER',
	'WEAPON_GADGETPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_SMG_MK2',
	'WEAPON_ASSAULTSMG',
	'WEAPON_COMBATPDW',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_MINISMG',
	'WEAPON_RAYCARBINE',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_MUSKET',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMBATSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_ASSAULTRIFLE_MK2',
	'WEAPON_CARBINERIFLE',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_SPECIALCARBINE_MK2',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_BULLPUPRIFLE_MK2',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MILITARYRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_COMBATMG_MK2',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_HEAVYSNIPER_MK2',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_MARKSMANRIFLE_MK2'
}

local LastCoord = vector3(216.14, -816.73, 30.64)
local Health = 0 
local Distance = 0.0 
local Zone = 0 
local GlobalCoord = vector3(216.14, -816.73, 30.64)
local inheli,jump,InWarzone , PlayerDead = false,false,false , false
local Dlay = false 
local model = GetHashKey('titan')
local plane , pilot  = nil , nil  
local ped = PlayerPedId()
local Time = 0 
local MyKill = 0 
local startWZ = false 
local AllPlayers = 0
local inLobby = false 
local NZone = 0
local objLootBox = nil 
local AllLoots = {}
local parachute = nil 
local inmatch = false 
local LootNow = false

RegisterNetEvent("WarZone:StartMision")
AddEventHandler("WarZone:StartMision",function(start,Body,dis,Coord , Time)
	AllLoots = {}
	SetPedArmour(PlayerPedId(),0)
	TriggerEvent('es_admin:freezePlayer', false)
	inLobby = false 
	Wait(10)
	inmatch = true 
	startWZ = true 
	Health = Body 
	Distance = dis
	Zone = dis
	GlobalCoord = Coord
	Time = Time
	InWarzone = true 
	NZone = dis / 2 + 0.0
	TriggerServerEvent("Warzone:SetW",90)
	Wait(500)
	RequestCollisionAtCoord(GlobalCoord.x, GlobalCoord.y, GlobalCoord.z)
	Zone_WZ()
	WarZone()
	
	Wait(Time * 60000)
	ZoneRuning()
end)

RegisterNetEvent("WarZone:ExitMision")
AddEventHandler("WarZone:ExitMision",function()
	TriggerServerEvent("Warzone:SetW",0)
	InWarzone = false 
	inLobby = false 
	LootNow = false
	inmatch = false 
	local ped = GetPlayerPed(-1)
	TriggerServerEvent("WarZone:OnPlayerChange",true)
	DeleteVehicle(plane)
	DeleteEntity(pilot)
	startWZ = false 
	SetEntityVisible(GetPlayerPed(-1), true,true)
	FreezeEntityPosition(GetPlayerPed(-1),false)
    DetachEntity(PlayerPedId(), true, true)
    SetEntityCollision(GetPlayerPed(-1), true, true)
	RemoveZone()
	RequestCollisionAtCoord(LastCoord.x, LastCoord.y, LastCoord.z)
	SetEntityVisible(ped, false,false)
	TriggerEvent("xC_AmbulanceJob:revive")
	Wait(3000)
	ESX.ShowMissionText("")
	RemoveAllPedWeapons(PlayerPedId(),1)
	Wait(100)
	LoadWeapon()
	SetEntityCoords(PlayerPedId(),LastCoord.x,LastCoord.y,LastCoord.z + 2)
	Wait(1000)
	SetEntityVisible(GetPlayerPed(-1), true ,true)
	Wait(710)
	SetPedArmour(PlayerPedId(),0)
    LastCoord = vector3(216.14, -816.73, 30.64)
    Health = 0 
    Distance = 0.0 
    GlobalCoord = vector3(216.14, -816.73, 30.64)
    inheli,jump,InWarzone , PlayerDead = false,false,false , false
    model = GetHashKey('titan')
    plane , pilot  = nil , nil  
	Zone = 0
	MyKill = 0 
	TriggerEvent("xC_AmbulanceJob:revive")
	ESX.ShowMissionText("areeee")
	for k,v in pairs(AllLoots) do 
		DeleteObject(v.Box)
		DeleteObject(v.Chatr)
    end 
    ESX.ShowMissionText("~r~Shoma Mordi Va Az WarZone Kharej Shodi")
    Wait(710)   
end)

RegisterNetEvent("WarZone:DC")
AddEventHandler("WarZone:DC",function()
	RemoveAllPedWeapons(PlayerPedId(),1)
	LoadWeapon()
	inLobby  = false 
	AllLoots = {}
end)

RegisterNetEvent("WarZone:JoinLobbery")
AddEventHandler("WarZone:JoinLobbery",function()
	AllLoots = {}
	InWarzone = true 
	inmatch = false 
	SaveWeapons()
	TriggerServerEvent("WarZone:OnPlayerChange",false)
	ESX.UI.Menu.CloseAll()
	ClearPedBloodDamage(GetPlayerPed(-1))
	inLobby = true 
	SetEntityCoords(GetPlayerPed(-1),vector3(-2131.17,3262.66,34.81))
	Wait(50)
	TriggerEvent('es_admin:freezePlayer', true)
	Wait(3000)
	RemoveAllPedWeapons(PlayerPedId(),1)
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('xC_Status:setss', 'hunger', 1000000)
	TriggerEvent('xC_Status:setss', 'thirst', 1000000)	
	TriggerEvent("xC_AmbulanceJob:revive")
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
	ShowAllPlayers()
end) 

function WarZone()
	TriggerEvent("xC_AmbulanceJob:revive")
	TriggerEvent('xC_WarZone::ShowMessage', "~r~Shoma Vared WarZone Shodid", 300)
	for k,v in pairs(AllLoots) do 
		DeleteObject(v.Box)
		DeleteObject(v.Chatr)
    end 
	Wait(3000)
	AllLoots = {}
	Dlay = true 
	LootNow = false
    RequestModel(model)
    while not HasModelLoaded(model) do
		Wait(1)
	end

    DeleteVehicle(plane)
    Wait(710)
	plane = CreateVehicle(model,GlobalCoord.x, GlobalCoord.y - Zone, GlobalCoord.z + Zone, 10, false, true)
	while not HasModelLoaded(model) do
		Wait(1)
	end
	while not DoesEntityExist(plane) do
		plane = CreateVehicle(model,GlobalCoord.x, GlobalCoord.y - Zone, GlobalCoord.z + Zone, 10, false, true)
		Wait(0)
	end 
	Wait(710)
	jump =  false 
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
	RemoveAllPedWeapons(PlayerPedId(),1)
	SetEntityVisible(GetPlayerPed(-1), false,false)
	SetEntityDynamic(plane, true)
	ActivatePhysics(plane)
	SetVehicleForwardSpeed(plane, 100.0)
	SetHeliBladesFullSpeed(plane)
	SetVehicleEngineOn(plane, true, true, false)
	ControlLandingGear(plane, 1)
	OpenBombBayDoors(plane)
	SetEntityProofs(plane, true, false, true, false, false, false, false, false)
	pilot = CreatePedInsideVehicle(plane, 1, GetHashKey("mp_m_freemode_01"), -1, false, true)
	SetBlockingOfNonTemporaryEvents(pilot, true)
	SetPedKeepTask(pilot, true)
	SetPlaneMinHeightAboveTerrain(plane, 50)
	TaskVehicleDriveToCoord(pilot, plane,GlobalCoord.x, GlobalCoord.y + Zone, GlobalCoord.z+ Zone, 30.0, 30.0, model, 16777216, 1.0, 1)
	ClearPedTasksImmediately(PlayerPedId())
	FreezeEntityPosition(GetPlayerPed(-1),true)
	ClearPedTasksImmediately(PlayerPedId())
	SetPedArmour(PlayerPedId(),0)
	SetEntityCollision(GetPlayerPed(-1), false, false)
	AttachEntityToEntity(GetPlayerPed(-1), plane, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
	while not IsEntityAttached(PlayerPedId()) do
		Wait(0)
		AttachEntityToEntity(GetPlayerPed(-1), plane, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
	end
	Wait(7000)
	inheli = true 
	SetTimeout(30000 , function( )
		Dlay = false 
	   if inheli == true  then 
		TriggerEvent('xC_WarZone::ShowMessage', "~r~Time Jump Shoma Tamom Shod", 120)
		JumpNow()
	   end 
	end)
end 

function JumpNow()
	inheli = false
	jump = true
	local ped = GetPlayerPed(-1)
	SetEntityVisible(GetPlayerPed(-1), true,true)
	FreezeEntityPosition(GetPlayerPed(-1),false)
	GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776, 1, 0)
	TriggerEvent('esx:addWeapon', "WEAPON_SNSPISTOL", 250)
	DetachEntity(PlayerPedId(), true, true)
	local planecoords = GetEntityCoords(PlayerPedId())
	SetEntityCollision(GetPlayerPed(-1), true, true)
	SetEntityCoords(PlayerPedId(),planecoords.x,planecoords.y,planecoords.z - 20)
	TriggerEvent('xcontrol',false)
	Wait(5000)
	TriggerEvent('xcontrol',true)
	DeleteVehicle(plane)
	DeleteEntity(pilot)
	SetEntityVisible(GetPlayerPed(-1), true,true)
	Wait(1000)
	plane , pilot  = nil , nil
	Wait(5000)
	LootNow = true 
	StartDrop()
end

AddEventHandler('onKeyUP',function(key)
	if key == "e" then
		if inheli == true  then 
			PlayerDead = false 
			inheli = false
			jump = true
			JumpNow()
		end
	end
end)

local MyWeapon = {}
function SaveWeapons()
	for k , v in ipairs(weapons) do
		if HasPedGotWeapon(PlayerPedId(),GetHashKey(v)) then
			table.insert(MyWeapon,v)
		end
	end

end 
function LoadWeapon()
    for k,v in pairs(MyWeapon) do 
	    GiveWeaponToPed(GetPlayerPed(-1),GetHashKey(v),250,false ,false)
    end 
    Wait(710)
    MyWeapon = {}
end 

function Zone_WZ()
Citizen.CreateThread(function()
	while InWarzone == true  do
		Wait(3000)
		
	    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),GlobalCoord,false) > Distance   then 	
	        if PlayerDead == false and inheli == false and Dlay == false  then  
	            SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())- 5 )
	            TriggerEvent('xC_WarZone::ShowMessage', "~r~Out Of Zone", 120)
	            jump = false 
	        end
        else 
	        Wait(1000)
        end
    end 
  end)
end

function RemoveZone()
	exports.xC_Main:RemoveByTag("WzAreaZone")
end 

function ZoneRuning()
	if startWZ  == false then return end 
	    local ZoneRun = true  
	    SoundZoneMoved()
	    TriggerEvent('xC_WarZone::ShowMessage', "~r~Zone Moved", 120)
	    CreateThread(function()
        while InWarzone and ZoneRun do 
            Wait(1000)
            if NZone <= Distance then 
            Distance = Distance - 1
            elseif NZone > Distance then 
                Wait(60000)
	            Wait(Time * 60000)
	            SoundZoneMoved()
	            TriggerEvent('xC_WarZone::ShowMessage', "~r~Zone Moved", 120)
	            NZone = NZone / 2
            end 
        end 
    end)
end 

function SoundZoneMoved()
	soundID = GetSoundId()
    PlaySoundFromEntity(soundID, "Crate_Beeps", GetPlayerPed(-1), "MP_CRATE_DROP_SOUNDS", true, 0)
    SetTimeout(5000,function()
        StopSound(soundID)
        ReleaseSoundId(soundID) 
		
    end)
end 

RegisterNetEvent("WarZone:respwan")
AddEventHandler("WarZone:respwan",function(addkill)
	if addkill then MyKill = MyKill + 1 return end 
        if InWarzone then 
	        if Health > 0 then 
		        Health = Health -1
	            RemoveAllPedWeapons(PlayerPedId(),1)
	            SetEntityVisible(PlayerPedId(), false,false)
				TriggerEvent('xC_WarZone::ShowMessage', "~r~Shoma Mordid", 190)
                Wait(2000)
	            WarZone()
	        else 
                TriggerEvent("WarZone:ExitMision")
	    end
    end 
end)

function ShowAllPlayers()
	Citizen.CreateThread(function()
		while InWarzone do
			if inheli then 
             ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ Jahat Paridan")
			else 
			Draw('Alive Player : '.. AllPlayers,255,0,0,0.01,0.5)
			if Health > 0 then 
			Draw('Blood : '.. Health,255,0,0,0.01,0.45)
			end 
			if MyKill > 0 then 
			Draw('Kill : '.. MyKill,255,0,0,0.01,0.4)
			end 
		end
			if inmatch   then 
				DrawMarker(28, GlobalCoord, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Distance + 0.0, Distance +0.0, Distance +0.0, 255, 128, 0, 50, false, true, 2, nil, nil, false)
            end 
		
			Wait(5)
		end
	end)
end 
function Draw(text,r,g,b,x,y)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
	SetTextColour( r,g,b, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent("WarZone:UpdateMembers")
AddEventHandler("WarZone:UpdateMembers",function(ShahabxD)
	AllPlayers =  ShahabxD 
end)

local  requiredModels = {"p_cargo_chute_s","ex_prop_adv_case_sm","prop_box_ammo03a"}
function StartDrop()
	for i = 1, #requiredModels do
		RequestModel(GetHashKey(requiredModels[i]))
		while not HasModelLoaded(GetHashKey(requiredModels[i])) do
			Wait(0)
		end
	end
	Citizen.CreateThread(function()
		while InWarzone do 
			Wait(30000)
			if LootNow  then 
			CreateAirDrop()
			end 
		end 
	end)
end

local WeaponList2 = {
    'WEAPON_GUSENBERG' ,
    'WEAPON_PISTOL',
    'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SMG',
    'WEAPON_SMG_MK2',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_ASSAULTRIFLE_MK2',
    'WEAPON_CARBINERIFLE',
    'WEAPON_CARBINERIFLE_MK2',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_BULLPUPRIFLE_MK2',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_COMBATPDW',
    'WEAPON_ASSAULTSMG',
}

function CreateAirDrop()
	local WeaponForThisLoot 
	local heal = false 
	local vest = false 
	local we = math.random(1,25)
	for k,v in pairs(WeaponList2) do 
		if we == k then 
			WeaponForThisLoot  = v 
		end 
	end 
	if we < 13 then 
	heal = true 
	vest = false 
	else 
	heal = false 
	vest = true 
end

Citizen.CreateThread(function()
	local MyCoord = GetEntityCoords(GetPlayerPed(-1))
	local where =  math.random(1,2)
	local others = 1
	if where == 1 then 
		others = -1 
	end 
	local crateSpawn = vector3(MyCoord.x + math.random(1,200) * others + 0.0, MyCoord.y + math.random(1,200) * others + 0.0, 50 + 0.0) 
    local crateSpawn = vector3(MyCoord.x, MyCoord.y , 50 + 0.0) 
	local objLootBox = CreateObject(GetHashKey("prop_box_ammo03a"), crateSpawn, true, true, true) 
    SetEntityLodDist(objLootBox, 2000) 
    ActivatePhysics(objLootBox)
    SetDamping(objLootBox, 2, 0.1) 
    SetEntityVelocity(objLootBox, 0.0, 0.0, -0.2)
	local parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true) 
    SetEntityLodDist(parachute, 2000)
    SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
	AttachEntityToEntity(parachute, objLootBox, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) 
	table.insert(AllLoots,{Box = objLootBox ,  Chatr = parachute , weapon = WeaponForThisLoot , Heal = heal , Vest = vest })
	Wait(50000)
	while not IsEntityAttached(parachute) do
		Wait(0)
		AttachEntityToEntity(parachute, objLootBox, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
	end
	Wait(30000)
	PlaceObjectOnGroundProperly(objLootBox)
	FreezeEntityPosition(objLootBox,true)
	end)
end 

AddEventHandler('onKeyUP',function(key)
	if key == "e" then
		if InWarzone  == true then
			for k,v in pairs(AllLoots) do 
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(v.Box),false) <= 2  then
					DeleteObject(v.Box)
					DeleteObject(v.Chatr)
					TriggerEvent('esx:addWeapon',v.weapon, 250)
					ESX.ShowNotification('~y~Shoma Yek '..v.weapon.." Badrashtid")
						if v.Heal then 
							SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+25)
							ESX.ShowNotification('~g~Shoma 25% Heal Shodid')
						elseif v.Vest then 
							SetPedArmour(PlayerPedId(),GetPedArmour(PlayerPedId())+ 25)
							ESX.ShowNotification('~b~Shoma 25% Armour Gereftid')	
						end 
					PuckUP()
				end
			end 
		end
	end
end)

function PuckUP()
	PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
	local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
	RequestAnimDict(dictname)
		if not HasAnimDictLoaded(dictname) then
			RequestAnimDict(dictname) 
			while not HasAnimDictLoaded(dictname) do 
				Citizen.Wait(1)
			end
		end
	TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(850)
	Citizen.Wait(1000)
	ClearPedTasks(GetPlayerPed(-1))
end 

RegisterNetEvent('xC_WarZone::ShowMessage')
AddEventHandler('xC_WarZone::ShowMessage', function(MsgText, setCounter)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString(MsgText)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()	
	local counter = 0
	local maxCounter = (setCounter or 200)
	while counter < maxCounter do
		counter = counter + 1
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(0)
	end
end)