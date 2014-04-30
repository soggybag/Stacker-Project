----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Load physics
local physics = require( "physics" )
physics.setDrawMode( "hybrid" )			-- Set the draw mode to hybrid for testing

-- Some variables to run the program
local block_properties = {friction=0.5, denisty=10, bounce=0.1} 

-- 
local background
local midground
local foreground
local ground
local arm
local block_array = {}
local state
local block_sheet

local home_button


-- Some functions to run the program 

-- This functions makes boxes. 
local function make_block()
	-- local block = display.newRect( 0, 0, 64, 64 )
	-- Since the block are static you can use newImage( sheet, frame )
	-- For animated blocks use newSprite( sheet, options )
	local block = display.newImage( block_sheet, math.random(1,8) )
	block:setFillColor( math.random(), math.random(), math.random() )
	-- Add the block to the midground display group 
	midground:insert( block )
	
	-- make a physics body from the block
	physics.addBody( block, "dynamic", block_properties )
	-- Use this property to control the rotation of the block. 
	block.angularDamping = 1
	
	-- Add the block to block_array to keep track of the blocks
	block_array[#block_array+1] = block
	
	-- Move the block to the location of the arm
	block.x = arm.x
	block.y = arm.y + 40 + 25
	
	-- At this stage use a joint to attach the block to the arm. 
	-- Remove the joint to drop the block. 
	arm.joint = physics.newJoint( "weld", arm, block, 0, 100 )	
	
	-- Start the arm moving 
	arm.transition = transition.to( arm, {x=display.contentWidth + 50, time=4000} )
end 


local function on_touch( event )
	-- get the event phase
	local phase = event.phase 
	if event.phase == "began" then 
		-- Check the state
		if state == "ready" then -- Ready to move a block
			-- arm reset 
			arm.x = -50
			-- make block
			make_block()
			-- arm start 
			state = "moving"
		elseif state == "moving" then -- Drop a block
			display.remove( arm.joint )
			state = "ready"
		end 
	end 
end 


local function on_frame( event )
	for i = 1, #block_array do 
		local block = block_array[i]
		if block.isAwake == false then 
			
		end 
	end 
end 



-- This functions makes a cloud image
local function newCloud() 
	local cloud = display.newImageRect( "images/cloud.png", 159, 118 )
	
	return cloud
end 

-- This functions makes any number of clouds and starts them moving across the screen.
local function make_clouds( n )
	
	local cloud_array = {}
	for i = 1, n do 
		local cloud = newCloud()
		background:insert( cloud )
		cloud.x = -math.random( 100, 400 )
		cloud.y = math.random( 40, display.contentHeight - 80 )
		local speed = math.random( 10000, 20000 )
		cloud_array[#cloud_array+1] = cloud
		transition.to( cloud, {x=display.contentWidth+100, time=speed, iterations=9999} )
	end 
	
end 



local function touch_home( event )
	if event.phase == "began" then 
		storyboard.gotoScene( "scenes.home" )
	end 
	
	return true
end 



-- Storyboard handlers 

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	local back = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	group:insert( back )
	
	-- Load the sprite sheet 
	-- NOTE! I used Zwoptex to create the sprite sheet and the options file. You can use another method if you like. 
	block_sheet = graphics.newImageSheet( "images/stacker-sprites.png", require("lua.stacker-sprites").getSheetOptions() )
	
	background = display.newGroup()
	midground = display.newGroup()
	foreground = display.newGroup()
	
	group:insert( background )
	group:insert( midground )
	group:insert( foreground )
	
	make_clouds( 6 )
	
	home_button = display.newCircle( 0, 0, 20 )
	home_button:setFillColor( 200/255, 200/255, 200/255 )
	foreground:insert( home_button )
	home_button.x = display.contentWidth - 30
	home_button.y = 30
end




-- Called immediately Before scene has moved onscreen:
function scene:willEnterScene( event )
	local group = self.view
	physics.start()
	
	ground = display.newRect( 0, 0, 600, 20 )
	midground:insert( ground )
	ground.x = display.contentCenterX
	ground.y = display.contentHeight
	
	physics.addBody( ground, "static", {friction=0.5, bounce=0.1} )
	
	arm = display.newRect( 0, 0, 10, 80 )
	midground:insert( arm )
	physics.addBody( arm, "kinematic", {} )
	
	state = "ready"
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	home_button:addEventListener( "touch", touch_home )
	Runtime:addEventListener( "touch", on_touch )
	Runtime:addEventListener( "enterFrame", on_frame )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	print( "Exit scene -- "  )
	
	display.remove( arm.joint )
	
	for i = #block_array, 1, -1 do 
		print( "Removing block", block_array[i] )
		display.remove( table.remove( block_array, i ) )
	end 
	display.remove( arm )
	display.remove( floor )
	
	
	physics.stop()
	
	home_button:removeEventListener( "touch", touch_home )
	Runtime:removeEventListener( "touch", on_touch )
	Runtime:removeEventListener( "enterFrame", on_frame )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene