local composer = require( "composer" )
 
local scene = composer.newScene()
local CW = display.contentWidth
local CH = display.contentHeight
local widget = require("widget")
local database = require("database")

 function goToMenu( )
     composer.gotoScene( "menu", {"fade",1000} )
     return true
 end

local option_group, screen_group
local backButton, listButton, sortButton, confirmButton
local chosen_list

 local alumnos = {
    "MAURICIO A.",
    "PATRICK",
    "ROBERTO",
    "IGNACIO",
    "KEN",
    "CESAR",
    "PAOLO",
    "SERGIO",
    "JORGE",
    "ERICK",
    "FERNANDA",
    "NURIA",
    "RAISA",
    "WEIMAR",
    "MAURICIO V."
}

local animales = {
    "gatos",
    "perros",
    "peces",
    "zorros",
    "tigres",
    "lagartijas",
    "Camellos",
    "Conejos",
    "vacas",
    "asass",
    "sdsd"
}

local available_lists = {
    {name = "Animales", values = animales},
    {name = "Alumnos", values = alumnos}
}


 function clear_screen( group )
     for i=group.numChildren, 1,-1 do
         display.remove( group[i])
     end 
 end

function display_list_names( list, posx )

     for i =1, #list do
         local name = display.newText( screen_group, list[i], posx, CH/4 + (i*20), "arial",15 )
     end

 end

function sort_random_list(list)

 local sorted = {}
 local sorted_list = {}
 for i=1,#list do
     sorted[i] = false
 end


 local all_sorted = true
 repeat
     all_sorted = true
     local rand_num = math.random( 1, #list )
     if sorted[rand_num] == false then
         sorted[rand_num] = true
         table.insert( sorted_list, list[rand_num] )
     end 

     for i=1,#sorted do
         if sorted[i] == false then
             all_sorted=false
             break
         end
     end

 until all_sorted

 return sorted_list
    
end

function select_list( )

    option_group.isVisible = true
    clear_screen(screen_group)
    return true
end


function confirm_list(  )
    option_group.isVisible = false

    if chosen_list ~= nil then
        sortButton.isVisible = true
        clear_screen(screen_group)
        display_list_names(chosen_list, CW/4)
    end
    return true
end

function ordenar(  )

     clear_screen(screen_group)
     local result = sort_random_list(chosen_list)
     display_list_names(chosen_list, CW/4)   
     display_list_names(result, CW/4*3)
 
     return true
 end

function scene:create( event )
 
    local sceneGroup = self.view
    option_group = display.newGroup()
    screen_group = display.newGroup()

    local background = display.newRect(sceneGroup, CW/2, CH/2, CW, CH)
    background:setFillColor(0.15, 0.24, 0.65)
    local titulo = display.newText( sceneGroup, "Sort List", CW/2, CH/8, "arial", 30)
   
    backButton = widget.newButton{
        defaultFile="atras.png",
        overFile="atras_over.png",
        width=40, height=30,
        onRelease = goToMenu    -- event listener function
    }
    backButton.x = 30
    backButton.y = 10


    sortButton = widget.newButton{
        label = "Sort",
        labelColor = {default={0,0,0}, over={0.5,0.5,0.5}},
        defaultFile="button.png",
        overFile="button-over.png",
        width=60, height=30,
        onRelease = ordenar    -- event listener function
    }
    sortButton.x = CW/2
    sortButton.y = CH/8*7
    sortButton.isVisible = false



    local frame = display.newRect(option_group, CW/2, CH/2, CW/4*3, CH/4*3)
    frame:setFillColor( 0.5, 0.5, 0.8, 0.7 )
    local frame_text = display.newText( option_group, "Select a list", CW/2,CH/4, "arial", 20 )
    local selected_frame = display.newRect(option_group, 0,0,200,30)
    selected_frame.isVisible=false
    selected_frame.anchorX=0
    selected_frame:setFillColor(0.8, 0.3)

    function hover_element( self, e )
 
        if e.phase == "began" then
            print("Hello")
        elseif e.phase == "ended" or e.phase =="cancelled" then
            print("Hello World")
            selected_frame.y = self.y
            selected_frame.isVisible = true
            selected_frame.x = self.x - self.contentWidth/2
            items = database.get_list_items(self.id)
            chosen_list = items
            titulo.text = "Sort list ".. self.text
            print( chosen_list )
        end

        return true
    end

    local display_lists = {}

    available_lists = database.get_list_names()

    for i = 1,#available_lists do
        display_lists[i] = display.newText( option_group,"-".. available_lists[i].name, CW/3, CH/3 + (i*40), "arial", 18)
        display_lists[i].val = available_lists[i].values
        display_lists[i].id = available_lists[i].id_list
        display_lists[i]:setFillColor( 0.8, 0.8, 0)
        display_lists[i].touch = hover_element
        display_lists[i]:addEventListener( "touch", display_lists[i] )
    end

    confirmButton = widget.newButton{
        label = "Confirm list",
        labelColor = {default = {0,0,0}, over={1,1,1}},
        defaultFile="button.png",
        overFile="button-over.png",
        width=80, height=30,
        onRelease = confirm_list    -- event listener function
    }
    confirmButton.x = CW - 90
    confirmButton.y = frame.y + frame.contentHeight/2 - 40
    option_group:insert( confirmButton )

    listButton = widget.newButton{
        label = "Select list",
        labelColor = {default = {0,0,0}, over={1,1,1}},
        defaultFile="button.png",
        overFile="button-over.png",
        width=70, height=30,
        onRelease = select_list    -- event listener function
    }
    listButton.x = CW- 70
    listButton.y = 20


    sceneGroup:insert(backButton)
    sceneGroup:insert(listButton)
    sceneGroup:insert(option_group)
    sceneGroup:insert( screen_group )
    sceneGroup:insert(sortButton)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        option_group.isVisible = false

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        clear_screen(screen_group)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene