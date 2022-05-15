local composer = require( "composer" )
local widget = require("widget")
local database = require("database")

local scene = composer.newScene()
local CW = display.contentWidth
local CH = display.contentHeight

local centerX, centerY = CW/2, CH/2
local roullete, frame, selected_frame, frame_text, titulo
local option_group, screen_group
local backButton, listButton, sortButton, confirmButton
local chosen_list

function goToMenu( )
     composer.gotoScene( "menu", {"fade",1000} )
     return true
end

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
    "gatos","perros","peces","zorros","tigres","lagartijas","Camellos","Conejos","vacas","asass","sdsd"
}

local available_lists = {
    -- {name = "Animales", values = animales},
    -- {name = "Alumnos", values = alumnos}
}

function clear_screen( group )
     for i=group.numChildren, 1,-1 do
         display.remove( group[i])
     end 
 end

function select_list( )

    option_group.isVisible = true
    clear_screen(screen_group)
    return true
end

function confirm_list( )
    option_group.isVisible = false

    if chosen_list ~= nil then
        clear_screen(screen_group)
        roullete = create_roullete(chosen_list)
        screen_group:insert(roullete)
    end
    return true
end

function create_roullete( list )
    local main_group = display.newGroup()
    local roulette_group = display.newGroup( )
    local gameGroup = display.newGroup( )
    main_group:insert( roulette_group)
    main_group:insert(gameGroup)

    local rombo = {-10,0,0,-20,10,0,0,30 }
    local split = #list
    local sp_angle = 360/ split 
    local radius = 120


    local dotX = {}
    local dotY = {}
    local nums = {}

--static functions
    function draw_dot( posx, posy )
        dot = display.newCircle( roulette_group, posx, posy, 4 )    
        dot:setFillColor( 0,0,1 )
    end

    function draw_triangle( px1,py1,px2,py2, i )

        pox = (px1+ px2) /2 
        poy = (py1+py2) /2
        aobx = px1/2
        aoby = py1/2
        nums[i] = display.newText( roulette_group, i, aobx, aoby , "arial", 15 )

        local base = display.newLine( roulette_group, px1, py1, px2, py2)
        draw_dot(pox,poy)
        local h_l = display.newLine(roulette_group,pox,poy, 0,0)

    end

-- static drawing
    local big_circle = display.newCircle( roulette_group, 0, 0, radius )
    big_circle.strokeWidth = 2
    big_circle:setFillColor( 1,0,0,0.5 )

    local in_circle = display.newCircle(roulette_group,0 , 0, 5 )
    in_circle:setFillColor( 1,1,0,0.8 )


    local winLabel = display.newText( gameGroup, "WINNER", centerX, 50,"arial",20 )
    winLabel:setFillColor( 1,1,0 )

    local target = display.newPolygon( gameGroup, centerX, centerY-radius-10, rombo )
    target:setFillColor( 1,1,0,0.9 )


--dynamic part
    for i = 1, split do
        new_angle = sp_angle*i 
        px = math.sin( new_angle* math.pi/180 ) * radius
        py = math.cos( new_angle* math.pi/180 ) * radius
        table.insert( dotX, px )
        table.insert( dotY, py )
    end 



    for i=1, split ,1 do
        if i == split then
            draw_triangle(dotX[i], dotY[i],  dotX[1], dotY[1], split )
        else
            draw_triangle(dotX[i], dotY[i],  dotX[i+1], dotY[i+1], i )
        end
    end

--animation part
    local rotation_offset = 0
    local ran = 1
    function fix_nums_rotation( )
        for i =1, #nums do
            nums[i].rotation = -rotation_offset
        end
        winLabel.text = list[ran]
    end

    function spin2( ... )
        transition.to( roulette_group, {time = 3000, rotation = (360*25),transition = easing.outQuad, onComplete = spin3 })
    end

    function spin3(  )
        roulette_group.rotation=0
        ran = math.random( 1, split )
        rotation_offset = sp_angle* ran +sp_angle/2
        transition.to( roulette_group, {time = 3000, rotation = rotation_offset,transition = easing.outCubic, onComplete=fix_nums_rotation })
        
    end

    function spin( ... )
        transition.to( roulette_group, {time = 2000, rotation = 360*20,transition = easing.inQuad, onComplete= spin2} )
        winLabel.alpha=0.2
        winLabel.size = 15
        transition.to(winLabel, {alpha= 1, time = 800, size=20, iterations=8} )
    end


    local button = display.newRect( gameGroup, CW/2, CH/8*7, 100, 50 )
    local button_text = display.newText( gameGroup, "SPIN", button.x, button.y,'arial',20 )
    button_text:setFillColor( 0 )
    function button:touch( e )
        if e.phase == "ended" or e.phase == "cancelled" then
        print("tocuhed")
            spin()
            winLabel.text = "WINNER"
        end
    end

    button:addEventListener( "touch", button )

    roulette_group.x = centerX
    roulette_group.y = centerY


    return main_group
end

function scene:create( event )
 
    local sceneGroup = self.view
    option_group = display.newGroup( )
    screen_group = display.newGroup( )

    local background = display.newRect( sceneGroup, CW/2, CH/2, CW, CH )
    background:setFillColor( 0.15,0.24,0.65 )

    titulo = display.newText( sceneGroup, "Pick a list", CW/2, CH/7 ,"arial",20 )
    titulo:setFillColor( 0.84,0.12,0.12 )

    backbutton = widget.newButton{
        defaultFile="atras.png",
        overFile="atras_over.png",
        width=40, height=30,
        onRelease = goToMenu    -- event listener function
    }
    backbutton.x = 30
    backbutton.y = 10


    frame = display.newRect(option_group, CW/2, CH/2, CW/4*3, CH/4*3)
    frame:setFillColor( 0.5, 0.5, 0.8, 0.7 )
    frame_text = display.newText( option_group, "Select a list", CW/2,CH/4, "arial", 20 )
    selected_frame = display.newRect(option_group, 0,0,200,30)
    selected_frame.isVisible=false
    selected_frame.anchorX=0
    selected_frame:setFillColor(0.8, 0.3)



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

    sceneGroup:insert(listButton)
    sceneGroup:insert(option_group) 
    sceneGroup:insert(backbutton)
end
 
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        option_group.isVisible = false

    table.remove( available_lists )

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
        --display_lists[i].val = available_lists[i].values
        display_lists[i].id = available_lists[i].id_list
        display_lists[i]:setFillColor( 0.8, 0.8, 0)
        display_lists[i].touch = hover_element
        display_lists[i]:addEventListener( "touch", display_lists[i] )
    end



    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 

    end
end
 
 function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
        display.remove( roullete )

    end
end
 
 
function scene:destroy( event )
 
    local sceneGroup = self.view
 
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