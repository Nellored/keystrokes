-- https://wiki.facepunch.com/gmod/Enums/KEY

surface.CreateFont("font", {
    font = "Roboto",
    size = 20,
    weight = 400,
    antialias = true
})
local def_h = 35

local animation_handler = {data = {}}

function animation_handler:lerp(start, end_pos, time, delta)
    time = time or 0.095
    time = FrameTime() * (time * 175)
    if time < 0 then
        time = 0.01
    elseif time > 1 then
        time = 1
    end
    if type(start) == "table" then
        local color_data = {0, 0, 0, 0}
        for v, k in ipairs({"r", "g", "b", "a"}) do
            color_data[v] = animation_handler:lerp(start[k], end_pos[k], time)
        end
        return Color(unpack(color_data))
    end
    if (math.abs(start - end_pos) < (delta or 0.01)) then return end_pos end
    return ((end_pos - start) * time + start)
end

animation_handler.new = function(name, value, time)
    time = time or 0.095
    if animation_handler.data[name] == nil then
        animation_handler.data[name] = value
    end
    animation_handler.data[name] = animation_handler:lerp(animation_handler.data[name], value, time)
    return animation_handler.data[name]
end

local AddKeyRectangle = function(text,key,x,y,size)
    local plus = (size == "medium" and 70) or (size == "big" and 105) or (size == "bigger" and 140) or (size == "small" and 35)
    surface.SetFont("font")
    local tw, th = surface.GetTextSize( text )
    local a, b = animation_handler.new(("on_%s_down"):format(text), input.IsKeyDown(key) and Color(255, 255, 255) or Color(30, 30, 30)), animation_handler.new(("on_%s_down_text"):format(text), input.IsKeyDown(key) and Color(30, 30, 30) or Color(255, 255, 255))
    surface.SetDrawColor(a)
    surface.DrawRect(x, y, plus, def_h)
    draw.SimpleText(text, "font", x+plus/2-tw/2, y+7, b)
end

local KeysX, KeysY = CreateClientConVar("KeyStrokesX", 0, true, false), CreateClientConVar("KeyStrokesY", 0, true, false)
local x, y = KeysX:GetInt(), KeysY:GetInt()
local keys, config_json
if file.Exists( "keystrokes/config.json", "DATA" ) then
    config_json = file.Read( "keystrokes/config.json", "DATA" )
    keys = util.JSONToTable( config_json )
else
    local default_keys = {
        {
            text = "W",
            key = 33,
            line = 1,
            pos = 1,
            size = "small"
        },
        {
            text = "D",
            key = 14,
            line = 2,
            pos = 2,
            size = "small"
        },
        {
            text = "S",
            key = 29,
            line = 2,
            pos = 1,
            size = "small"
        },
        {
            text = "A",
            key = 11,
            line = 2,
            pos = 0,
            size = "small"
        },
        {
            text = "SPACE",
            key = 65,
            line = 3,
            pos = 0,
            size = "big"
        },
    }
    local tab = util.TableToJSON( default_keys )
    file.CreateDir( "keystrokes" ) -- Create the directory
    file.Write( "keystrokes/config.json", tab) -- Write to .json
end
concommand.Add( "KeyStrokesNew", function(ply, cmd, args, argStr)
    if #args == 5 then
        keys[#keys+1] = {
            text = args[1],
            key  = args[2],
            line = args[3],
            pos  = args[4],
            size = args[5],
        }
        local tab = util.TableToJSON( keys ) -- Convert the player table to JSON
        file.CreateDir( "keystrokes" ) -- Create the directory
        file.Write( "keystrokes/config.json", tab) -- Write to .json
    end
end,
function(cmd, stringargs)
    return {
        "KeyStrokesNew text 30 1 0 small",
        "KeyStrokesNew text, keyID, line, pos, size",
        "KeyStrokesNew W 33 1 1 small",
        "KeyStrokesNew A 11 2 0 small",
        "KeyStrokesNew S 29 2 1 small",
        "KeyStrokesNew D 14 2 2 small",
    }  
end)

concommand.Add( "KeyStrokesDelete", function(ply, cmd, args, argStr)
    for i = 1, #keys do
        print(i, keys[i].text, keys[i].key)
        if args[1] == keys[i].text and args[2] == keys[i].key then
            table.remove(keys, i)
        end
    end
end)

local Elements = function(x,y)
    for k, v in ipairs(keys) do
        local plus = (v.size == "medium" and 70) or (v.size == "big" and 105) or (v.size == "bigger" and 140) or (v.size == "small" and 35)
        AddKeyRectangle(v.text, v.key, x+plus*v.pos, y+def_h*v.line, v.size)
    end
end


concommand.Add( "KeyStrokesEditor", function()
    local Frame = vgui.Create( "DFrame" )
    Frame:SetSize( 256, 256 )
    Frame:SetPos( x, y )
    Frame:MakePopup()
    Frame:SetTitle("KeyStrokes")
    Frame:ShowCloseButton(false)
    Frame:SetSizable(true)
    function Frame:Paint(w,h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        Elements(0,0)
    end
    local ButtonClose = vgui.Create( "DButton", Frame )
    ButtonClose:SetSize(16,16)
    ButtonClose:SetPos(0,0)
    ButtonClose:SetFont("font")
    ButtonClose:SetText("X")
    function ButtonClose:DoClick()
        KeysX:SetInt(Frame:GetX())
        KeysY:SetInt(Frame:GetY())
        Frame:Hide()
    end
    hook.Add("Think", "KeyStrokesThinking", function()
        if Frame:IsVisible() then
            ButtonClose:SetPos(Frame:GetWide()-ButtonClose:GetWide())
            hook.Remove("HUDPaint", "KeyStrokes")
        else
            hook.Add("HUDPaint","KeyStrokes", function()
                x, y = Frame:GetX(), Frame:GetY()
                Elements(x,y)
            end)
        end
    end)
end)

hook.Add("HUDPaint","KeyStrokes", function()
    Elements(x,y)
end)

MsgC( Color( 255, 98, 154 ), "[ ADDON LOADED ] ", Color(255, 255, 255), "KeyStrokes by ", Color(255, 98, 154), "Nellored\n" )