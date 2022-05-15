-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local database = require( "database" )
local composer = require( "composer" )
display.setStatusBar( display.HiddenStatusBar )

local CW = display.contentWidth
local CH = display.contentHeight

composer.gotoScene( "menu" ,{"fade", 500} )

local centerX, centerY = CW/2, CH/2

-- local testVec = Vec(45,12)


--create_roullete(animales)

-- function sort_random_list(list)

-- 	local sorted = {}
-- 	local sorted_list = {}
-- 	for i=1,#list do
-- 		sorted[i] = false
-- 	end


-- 	local all_sorted = true
-- 	repeat
-- 		all_sorted = true
-- 		local rand_num = math.random( 1, #list )
-- 		if sorted[rand_num] == false then
-- 			sorted[rand_num] = true
-- 			table.insert( sorted_list, list[rand_num] )
-- 		end 

-- 		for i=1,#sorted do
-- 			if sorted[i] == false then
-- 				all_sorted=false
-- 				break
-- 			end
-- 		end

-- 	until all_sorted

-- 	return sorted_list
	
-- end

-- 	local screen_group = display.newGroup( )

-- 	function clear_screen(  )
-- 		for i=screen_group.numChildren, 1,-1 do
-- 			display.remove( screen_group[i])
-- 		end	
-- 	end

-- 	function display_list_names( list, posx )

-- 		for i =1, #list do
-- 			local name = display.newText( screen_group, list[i], posx, 50 + (i*20), "arial",15 )
-- 		end

-- 	end


-- 	display_list_names(alumnos, CW/4)


-- 	local button = display.newRect(CW/2,CH/8*7,80,30)
-- 	local label = display.newText( "Ordenar",button.x, button.y, "arial" ,20 )
-- 	label:setFillColor( 0 )

-- 	function label:touch( e )


-- 		if e.phase == "ended" then
-- 			clear_screen()
-- 			local result = sort_random_list(alumnos)
-- 			display_list_names(alumnos, CW/4)	
-- 			display_list_names(result, CW/4*3)

-- 		end
-- 		return true
-- 	end

-- 	label:addEventListener( "touch", label )




