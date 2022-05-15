local composer = require( "composer" )
 
local scene = composer.newScene()
local CW = display.contentWidth
local CH = display.contentHeight
local widget = require("widget")

 function goRoullete( )
     composer.gotoScene( "rullete", {"fade",1000} )
     return true
 end

 function goToSorter( )
     composer.gotoScene( "sort_view", {"fade",1000} )
     return true
 end

 function goToListCreator( )
     composer.gotoScene( "list_view", {"fade",1000} )
     return true
 end



local button1, button2

function scene:create( event )
 
    local sceneGroup = self.view

    local background = display.newRect( sceneGroup, CW/2, CH/2, CW, CH )
    background:setFillColor( 0.15,0.24,0.65 )
    local titulo = display.newText( sceneGroup, "LIST OPTIONS", CW/2,CH/5,"arial", 30 )


    button0 = widget.newButton{
        label="Create list",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=130, height=40,
        onRelease = goToListCreator    -- event listener function
    }
    button0.x = display.contentCenterX
    button0.y = CH/3
   
    button1 = widget.newButton{
        label="Random player",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=130, height=40,
        onRelease = goRoullete    -- event listener function
    }
    button1.x = display.contentCenterX
    button1.y = CH/2

    button2 = widget.newButton{
        label="Random order",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=130, height=40,
        onRelease = goToSorter
    }
    button2.x = display.contentCenterX
    button2.y = CH/2 + 100

    sceneGroup:insert(button0)
    sceneGroup:insert(button1)
    sceneGroup:insert(button2)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
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