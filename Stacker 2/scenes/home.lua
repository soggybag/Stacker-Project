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

local physics = require( "physics" )

local block
local floor


local function on_tap( event )
	storyboard.gotoScene( "scenes.play" )
end 


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
	block = display.newRect( 0, 0, 64, 64 )
	group:insert( block )
	block.x = display.contentCenterX
	block.y = -60
	physics.addBody( block, "dynamic", {density=10, friction=0.3, bounce=0.3} )
	
	floor = display.newRect( 0, 0, display.contentWidth, 10 )
	group:insert( floor )
	floor.x = display.contentCenterX
	floor.y = display.contentWidth + 60
	physics.addBody( floor, "static", {density=10, friction=0.3, bounce=0.3} )
	
	block:addEventListener( "tap", on_tap )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	display.remove( block )
	display.remove( floor )
	
	physics.pause()
	
	block:removeEventListener( "tap", on_tap )
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
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene