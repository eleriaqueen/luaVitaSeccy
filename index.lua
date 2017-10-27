-- Copyright (c) 2017 Clem

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local PSO_LEGACY_NAME_SIZE = 12
-- local PSOBB_NAME_SIZE = 10
local PSO_LEGACY_CLASSVAL = 5
local PSO_SECTIONID_TOTAL = 10
local keybTitle = "Enter \"Legacy\" PSO Name" 
local keybInitialText = ""
local ret = "Waiting for input..."
local ret_a
local ret_b
local ret_c

-- Initilize colours
local psoSectionidColourList = {
Color.new(43, 125, 7), 
Color.new(33, 234, 12), 
Color.new(18, 243, 230), 
Color.new(10, 100, 213), 
Color.new(127, 11, 201), 
Color.new(249, 11, 218), 
Color.new(243, 20, 20), 
Color.new(255, 169, 3), 
Color.new(255, 252, 3), 
Color.new(255, 255, 255)}

-- local psobb_classval = { 0, 1, 2, 9, 3, 11, 4, 5, 10, 6, 7, 8 }
-- local psobb_class = { "HUmar", "HUnewearl", "HUcast", "HUcaseal", "RAmar", "RAmarl", "RAcast", "RAcaseal", "FOmar", "FOmarl", "FOnewm", "FOnewearl" }
local psoSectionidList = { "Viridia", "Greenill", "Skyly", "Bluefull", "Purplenum", "Pinkal", "Redria", "Oran", "Yellowboze", "Whitill" }
local psoSectionidImageList = { Viridia, Greenill, Skyly, Bluefull, Purplenum, Pinkal, Redria, Oran, Yellowboze, Whitill }

local psoSectionidImageList = {}
for c = 1, PSO_SECTIONID_TOTAL, 1 do
	psoSectionidImageList[c] = Graphics.loadImage("app0:/res/img/" .. psoSectionidList[c] .. ".png")
end

-- Initialize font
local my_font = Font.load("app0:/res/font/RobotoCondensed-Regular.ttf")
Font.setPixelSizes(my_font, 22)

-- Initialize OSK
Keyboard.show(keybTitle, keybInitialText, PSO_LEGACY_NAME_SIZE, TYPE_LATIN)

-- Iterate through a string cumulating each character value
-- and a "magic" value.
-- Divide by 10 and keep the rest of the division
-- then add 1 (in LUA arrays start at 1).
local function psoStrcpt(inputStr, cval)
    local count = 0
	local sum = 0
    local flag = 0
	local currentCharacter

    for c = 1, string.len(inputStr), 1 do
		currentCharacter = string.byte(inputStr, c)
        sum = sum + currentCharacter
--      if ((currentCharacter >= 256) and (currentCharacter < 65377)) then
--          if (flag ~= 2) then
--              flag = 2
--              sum = sum + 83
--		end
--      elseif (currentCharacter <= 65425) then
--          if (flag ~= 1) then
--              flag = 1
--              sum = sum + 45
--          end
--      end
    end
	return ((sum + cval) % 10 + 1)
end

-- Main loop
while true do
	
	-- Initializing drawing phase
	Graphics.initBlend()
	Screen.clear()
	
	-- Font.print(my_font, 15, 5, "Hit [Triangle] to Exit app", Color.new(255,255,255))
	
	-- Checking for keyboard status
	status = Keyboard.getState()
	if status ~= RUNNING then
	
		-- Check if user is finished with, or canceled the keyboard
		if (status == FINISHED) then
			keyb_input = Keyboard.getInput()
			sectionidResult_val = psoStrcpt(keyb_input, PSO_LEGACY_CLASSVAL)
			ret_a = "You typed: " .. keyb_input
			ret_b = "Your Section ID is:"
			ret_c = psoSectionidList[sectionidResult_val]
			fin = 1
		end
		if (status == CANCELED) then
			ret = "Keyboard cancelled, please restart app"
		end
		
		-- Terminating keyboard
		Keyboard.clear()
		
	end
	
	-- Print text and draw image
	if not fin then
		Font.print(my_font, 15, 10, ret, Color.new(255,255,255))
	elseif fin then
		Graphics.drawImage(224, 16, psoSectionidImageList[sectionidResult_val])
	
		Font.print(my_font, 15, 10, ret_a, Color.new(255,255,255))
		Font.print(my_font, 15, 38, ret_b, Color.new(255,255,255))
		Font.print(my_font, 180, 38, ret_c, psoSectionidColourList[sectionidResult_val])
	end
	
	-- Terminating GPU rendering
	Graphics.termBlend()
	
	-- Updating screen
	Screen.waitVblankStart()
	Screen.flip()
	
	-- Check for input
	-- if (Controls.check(Controls.read(),SCE_CTRL_TRIANGLE)) then
	--	   End all the things...
	--	Font.unload(my_font)
	--	for c = 1, PSO_SECTIONID_TOTAL, 1 do
	--		Graphics.freeImage(psoSectionidImageList[c])
	--	end
	--	System.exit()
	-- end
end
