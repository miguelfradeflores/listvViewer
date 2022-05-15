local composer = require( "composer" )
 
local scene = composer.newScene()
local CW = display.contentWidth
local CH = display.contentHeight
local widget = require("widget")
local database = require('database')

local tittle_text,tittle_text_field
local popup_text, frame1,frame2
local button0,save_button,cancel_button,back_button, formGroup
local items = {}
local items_fields = {}
local scrollGroup,scrollView

local baseY = CH/6

function goToMenu( )
     composer.gotoScene( "menu", {"fade",1000} )
     return true
end

function show_formGroup( )

     formGroup.isVisible = true
     tittle_text_field.isVisible = true

     for i=1, #items do
        items[i].isVisible = true
     end

     for i=1, #items_fields do
        items_fields[i].isVisible = true
     end


     return true
 end


function save_list(  )
    
    print("Start saving")
    database.add_list(tittle_text_field.text)
    print("Finish saving")

    local items = {}
    for i=1, #items_fields do
        table.insert( items, items_fields[i].text )
        print("value to add " .. items_fields[i].text)
    end

    database.create_list_items( tittle_text_field.text ,items)

    return true
end

function create_item(  )
    local current_size = #items
    local index = current_size + 1
    items[index] = display.newText(formGroup, "-Item ".. index, CW/4, baseY+(index*40), "arial", 20)
    items_fields[index] = native.newTextField(items[index].x + 50, items[index].y, 100,30 )
    items_fields[index].isVisible = true
    items_fields[index].anchorX = 0
    formGroup:insert( items_fields[index] )
    scrollView:insert( items[index] )
    scrollView:insert( items_fields[index] )
--    scrollView:setScrollHeight() 
end


function add_item(  )
    create_item()
end

function hide_group( )
    formGroup.isVisible = false
    tittle_text_field.isVisible = false
    tittle_text_field.text = ""

     for i=1, #items_fields do
        items[i].isVisible = false
        items[i].text = ""
     end

     for i=1, #items_fields do
        items_fields[i].isVisible = false
        items_fields[i].text = ""

     end

    return true
end


function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( event.target.text )
 
    elseif ( event.phase == "editing" ) then
    --     print( event.newCharacters )
    --     print( event.oldText )
    --     print( event.startPosition )
    --     print( event.text )
        

    end
end

local scrollBarOpt = {
        top = 50,
        left = 10,
        width = CW*0.5,
        height = 300,
        scrollWidth = 500,
        scrollHeight = 300,
        listener = scrollListener,
        horizontalScrollDisabled = true,
        hideBackground = true
}


function scene:create( event )
 
    local sceneGroup = self.view

    formGroup = display.newGroup( )

    local background = display.newRect( sceneGroup, CW/2, CH/2, CW, CH )
    background:setFillColor( 0.15,0.24,0.65 )
    local titulo = display.newText( sceneGroup, "LIST MANAGER", CW/2,CH/7,"arial", 25 )

    scrollView = widget.newScrollView( scrollBarOpt  )


    button0 = widget.newButton{
        label="NEW",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=90, height=40,
        onRelease = show_formGroup    -- event listener function
    }
    button0.x = display.contentWidth - 50
    button0.y = 20
  
    back_button = widget.newButton{
        defaultFile="atras.png",
        overFile="atras_over.png",
        width=40, height=30,
        onRelease = goToMenu    -- event listener function
    }
    back_button.x = 30
    back_button.y = 10

    cancel_button = widget.newButton{
        label="cancel",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=70, height=20,
        onRelease = hide_group    -- event listener function
    }
    cancel_button.x = CW/4
    cancel_button.y = CH/10*8

    save_button = widget.newButton{
        label="save",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=70, height=20,
        onRelease = save_list    -- event listener function
    }
    save_button.x = CW/8*6
    save_button.y = CH/10*8

    add_button = widget.newButton{
        label="add",
        labelColor = { default={0}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        fontSize= 10,
        width=30, height=30,
        onRelease = add_item    -- event listener function
    }
    add_button.x = CW/8*6 + 20
    add_button.y = CH/10*2


    sceneGroup:insert(formGroup)
    sceneGroup:insert(button0)

    frame1 = display.newRect(formGroup, CW/2, CH/2, CH/2, CH/3*2)
    frame1:setFillColor( 0.12,0.17,0.86,0.8 )

    list_text = display.newText( formGroup, "List name", CW/4 +5 , CH/4, "arial", 20 )

    tittle_text_field = native.newTextField( list_text.x + list_text.contentWidth*0.75, list_text.y, 100, 30 )
    tittle_text_field.anchorX = 0
    tittle_text_field.isVisible = false
    formGroup:insert( tittle_text_field )
    tittle_text_field:addEventListener( "userInput", textListener )

    frame2 = display.newRect(formGroup, CW/2, CH/2, CH/2, CH/3*2)
    frame2:setFillColor( 0.12,0.17,0.86,0.8 )
    frame2.isVisible = false

    -- create_item()
    -- create_item()
    -- create_item()
    -- create_item()

    popup_text = display.newText( formGroup, "", CW/2, CH/3, "arial", 20 )

    formGroup:insert( save_button )
    formGroup:insert( cancel_button )
    formGroup:insert( add_button )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
        formGroup.isVisible=false

        for i = 1, #items_fields do
            items_fields[i].isVisible = false
        end

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
 
 
        formGroup.isVisible=false
        tittle_text_field.isVisible= false
        for i= #items_fields,1,-1 do
            items_fields[i].isVisible = false
            display.remove( items_fields[i] )
            items_fields[i] = nil
            display.remove( items[i] )
            items[i] = nil
        end

        table.remove( items )
        table.remove( items_fields )

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