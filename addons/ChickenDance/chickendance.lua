--[[
---MIT License---
Copyright 2022 Banggugyangu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--


addon.name = 'ChickenDance';
addon.author = 'Banggugyangu';
addon.desc = "Shuffle your mounts!!";
addon.version = '0.1';

local settings = require('settings');
local imgui = require('imgui');
local chat = require('chat');

local default_settings = T{
    SetMounts = {}
}

ChickenDance = T{
    settings = settings.load(default_settings);
}

local possibleMounts = {}

local MountEnum = {
    [3072] = 'Chocobo',
    [3073] = 'Raptor',
    [3074] = 'Tiger',
    [3075] = 'Crab',
    [3076] = 'Red Crab',
    [3077] = 'Bomb',
    [3078] = 'Sheep',
    [3079] = 'Morbol',
    [3080] = 'Crawler',
    [3081] = 'Fenrir',
    [3082] = 'Beetle',
    [3083] = 'Moogle',
    [3084] = 'Magic Pot',
    [3085] = 'Tulfaire',
    [3086] = 'Warmachine',
    [3087] = 'Xzomit',
    [3088] = 'Hippogryph',
    [3089] = 'Spectral Chair',
    [3090] = 'Spheroid',
    [3091] = 'Omega',
    [3092] = 'Coeurl',
    [3093] = 'Goobbue',
    [3094] = 'Raaz',
    [3095] = 'Levitus',
    [3096] = 'Adamantoise',
    [3097] = 'Dhalmel',
    [3098] = 'Doll',
    [3099] = 'Golden Bomb',
    [3100] = 'Buffalo',
    [3101] = 'Wivre',
    [3102] = 'Red Raptor',
    [3103] = 'Iron Giant',
    [3104] = 'Byakko',
    [3105] = 'Noble Chocobo',
    [3106] = 'Ixion'
}

ashita.events.register('settings', 'settings_update', function(s)
    if( s ~= nil)then
        ChickenDance.settings = s;
    end
    settings.save();
end)

local BuildMounts = function()
    local MountTable = {}
    for k,_ in pairs(MountEnum) do
        local KI = AshitaCore:GetMemoryManager():GetPlayer():HasKeyItem(k);
        if(KI)then
            table.insert(MountTable, k);
        end
    end
    possibleMounts = MountTable;
end

ashita.events.register('d3d_present', 'present_cb', function()
    --[[if(imgui.Begin('Test Window', true))then
        if(possibleMounts[1] ~= nil)then
            for i = 1, #possibleMounts do
                local mount = possibleMounts[i];
                imgui.Text(tostring(i) .. ':  ' .. MountEnum[mount]);
            end
        end
        imgui.End();
    end]]
end)

ashita.events.register('packet_in', 'packet_in_cb', function(e)
        BuildMounts();
end)

ashita.events.register('command', 'command_cb', function(e)
    local args = e.command:args();
    if(#args == 1 and args[1] == '/mount')then
        e.blocked = true;
        math.randomseed(os.time())
        math.random(); math.random(); math.random()
        local rand = math.random(#possibleMounts);
        local mountIndex = possibleMounts[rand];
        local mountName = MountEnum[mountIndex];
        if(mountName ~= nil)then
            local mountStr = '/mount ' .. mountName;
            print(chat.message(tostring(mountStr)));
            AshitaCore:GetChatManager():QueueCommand(-1, mountStr);
        end
    end
end)