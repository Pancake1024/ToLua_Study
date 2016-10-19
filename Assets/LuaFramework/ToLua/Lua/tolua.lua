--------------------------------------------------------------------------------
--      Copyright (c) 2015 - 2016 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------
require "common/functions"

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;
--object			= System.Object
--Type			= System.Type
--Object          = UnityEngine.Object
--GameObject 		= UnityEngine.GameObject
--Transform 		= UnityEngine.Transform
--MonoBehaviour 	= UnityEngine.MonoBehaviour
--Component		= UnityEngine.Component
--Application		= UnityEngine.Application
--SystemInfo		= UnityEngine.SystemInfo
--Screen			= UnityEngine.Screen
--Camera			= UnityEngine.Camera
--Material 		= UnityEngine.Material
--Renderer 		= UnityEngine.Renderer
--AsyncOperation	= UnityEngine.AsyncOperation

--CharacterController = UnityEngine.CharacterController
--SkinnedMeshRenderer = UnityEngine.SkinnedMeshRenderer
--Animation		= UnityEngine.Animation
--AnimationClip	= UnityEngine.AnimationClip
--AnimationEvent	= UnityEngine.AnimationEvent
--AnimationState	= UnityEngine.AnimationState
--Input			= UnityEngine.Input
--KeyCode			= UnityEngine.KeyCode
--AudioClip		= UnityEngine.AudioClip
--AudioSource		= UnityEngine.AudioSource
--Physics			= UnityEngine.Physics
--Light			= UnityEngine.Light
--LightType		= UnityEngine.LightType
--ParticleEmitter	= UnityEngine.ParticleEmitter
--Space			= UnityEngine.Space
--CameraClearFlags= UnityEngine.CameraClearFlags
--RenderSettings  = UnityEngine.RenderSettings
--MeshRenderer	= UnityEngine.MeshRenderer
--WrapMode		= UnityEngine.WrapMode
--QueueMode		= UnityEngine.QueueMode
--PlayMode		= UnityEngine.PlayMode
--ParticleAnimator= UnityEngine.ParticleAnimator
--TouchPhase 		= UnityEngine.TouchPhase
--AnimationBlendMode = UnityEngine.AnimationBlendMode
--Application = UnityEngine.Application
--Resources = UnityEngine.Resources
--RuntimePlatform = UnityEngine.RuntimePlatform

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();


if jit then		
	if jit.opt then
		jit.opt.start(3)			
	end
	print("jit", jit.status())
	print(string.format("os: %s, arch: %s", jit.os, jit.arch))
end

--mobdebug 会调整jit
if DebugServerIp then  
  require("mobdebug").start(DebugServerIp)
end

Mathf		= require "UnityEngine.Mathf"
Vector3 	= require "UnityEngine.Vector3"
Quaternion	= require "UnityEngine.Quaternion"
Vector2		= require "UnityEngine.Vector2"
Vector4		= require "UnityEngine.Vector4"
Color		= require "UnityEngine.Color"
Ray			= require "UnityEngine.Ray"
Bounds		= require "UnityEngine.Bounds"
RaycastHit	= require "UnityEngine.RaycastHit"
Touch		= require "UnityEngine.Touch"
LayerMask	= require "UnityEngine.LayerMask"
Plane		= require "UnityEngine.Plane"
Time		= require "UnityEngine.Time"

list		= require "list"
utf8		= require "misc.utf8"

require "event"
require "typeof"
require "slot"
require "System.Timer"
require "System.coroutine"
require "System.ValueType"
require "System.Reflection.BindingFlags"

--require "misc.strict"



function print(...)
	local str = ""	
	local arg = {...}
	local n = select('#', ...)

	for i = 1, n do
		str = string.format("%s%s", str, tostring(arg[i]))
	end
	
	log(str)
end

function printf(format, ...)
	log(string.format(format, ...))
end


--unity 对象判断为空, 如果你有些对象是在c#删掉了，lua 不知道
--判断这种对象为空时可以用下面这个函数。
function IsNil(uobj)
	return uobj == nil or uobj:Equals(nil)
end

-- isnan
function isnan(number)
	return not (number == number)
end

--[[function FindNode(transform, name)
	if transform == nil then
		error("invalide arguments to FindNode transform is nil")
		return nil
	elseif name == nil then
		error("invalide arguments to FindNode name is nil")
		return nil
	end
	
	local node = UnGfx.FindNode(transform, name)
	
	if node == nil then
		error(string.format("transform %s does not have child %s", transform.name, name))
	end
	
	return node
end--]]


function string:split(sep)
	local sep, fields = sep or ",", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) table.insert(fields, c) end)
	return fields
end

function GetDir(path)
	return string.match(fullpath, ".*/")
end

function GetFileName(path)
	return string.match(fullpath, ".*/(.*)")
end

-- Courtesy of lua-users.org
--[[function string:split(pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = string.find(str, fpat, 1)

   while s do
      if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
      last_end = e+1
      s, e, cap = string.find(str, fpat, last_end)
   end

   if last_end <= string.len(str) then
      cap = string.sub(str, last_end)
      table.insert(t, cap)
   end

   return t
end]]

function table.contains(table, element)
  if table == nil then
        return false
  end

  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function table.getCount(self)
	local count = 0
	
	for k, v in pairs(self) do
		count = count + 1	
	end
	
	return count
end

function DumpTable(t)
	for k,v in pairs(t) do
		if v ~= nil then
			log("Key: {0}, Value: {1}", tostring(k), tostring(v))
		else
			log("Key: {0}, Value nil", tostring(k))
		end
	end
end

 function PrintTable(tab)
    local str = {}

    local function internal(tab, str, indent)
        for k,v in pairs(tab) do
            if type(v) == "table" then
                table.insert(str, indent..tostring(k)..":\n")
                internal(v, str, indent..' ')
            else
                table.insert(str, indent..tostring(k)..": "..tostring(v).."\n")
            end
        end
    end

    internal(tab, str, '')
    return table.concat(str, '')
end

function PrintLua(name, lib)
	local m
	lib = lib or _G

	for w in string.gmatch(name, "%w+") do
       lib = lib[w]
     end

	 m = lib

	if (m == nil) then
		log("Lua Module {0} not exists", name)
		return
	end

	log("-----------------Dump Table {0}-----------------",name)
	if (type(m) == "table") then
		for k,v in pairs(m) do
			log("Key: {0}, Value: {1}", k, tostring(v))
		end
	end

	local meta = getmetatable(m)
	log("-----------------Dump meta {0}-----------------",name)

	while meta ~= nil and meta ~= m do
		for k,v in pairs(meta) do
			if k ~= nil then
			log("Key: {0}, Value: {1}", tostring(k), tostring(v))
			end

		end

		meta = getmetatable(meta)
	end

	log("-----------------Dump meta Over-----------------")
	log("-----------------Dump Table Over-----------------")
end

function stringToTable(str)
   local ret = loadstring("return "..str)()
   return ret
end
--[[
function VoidDelegate(type, func)
    local voicePath = nil
    if type == UICtlType.Button then 
        print("this is a button") 
        voicePath = "Assets/Music/ogg/yx-ty0001.ogg"
    end
    local modifyFunc = function()
        func()
        ioo.audioManager:Play2D(voicePath)
    end
    return LuaHelper.VoidDelegate(modifyFunc)
end
--]]
function TEXT(text, ...)
	if id_string then
		return id_string[text] or text
	else
		return text
	end
end

-- local old_traceback = debug.traceback

local GetInfo = function (info)
    if info.what == "C" then
        return string.format("\t%s %s\n", "C function", info.name)
    else
        return string.format("\t[%s]:%d in function \'%s\'\n", info.source, info.currentline, info.name or info.source)
    end
end

debug.traceback = function (thread, message, level)
    if type(thread) ~= "thread" then
        -- shift parameters left
        thread, message, level = nil, thread, message
    end

    level = level or 1

    local tracebackString = "" .. tostring(message) .. "\n"
    while true do
        local info = debug.getinfo(level, "Slfn")
        if not info then break end
        if info.what == "C" then   -- is a C function?
            tracebackString = tracebackString .. GetInfo(info)
        else   -- a Lua function
            tracebackString = tracebackString .. GetInfo(info)
        end
        level = level + 1
    end
    return tracebackString
end
