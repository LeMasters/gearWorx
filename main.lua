-- Simple demo:  Industrial Drop Clock

-- 2013 Garrison LeMasters
-- Georgetown University
-- Corona v2.0 ready

local physics = require( "physics" )
local base = display.newGroup()
local group = display.newGroup()
local _w, _h, _wT, _hT
local background
local rnd, sine
local numberOfGears
local gears = {}
local showTime
local block1,block2,block3,z1,z2,z3
local triggerClean = false
local tMod

rnd = math.random
sine = math.sin
_w = display.actualContentWidth
_h = display.actualContentHeight
_wT = display.actualContentWidth * 0.5
_hT = display.actualContentHeight * 0.5
tMod = ((_w / 400) * 0.5) + 1
numberOfGears = 5

-- nb This function ("setup()") will only run ONCE
local function setup()
    local xRange = _w / numberOfGears
    local yRange = _h / numberOfGears
    for n = 1, numberOfGears do
        local size = rnd( _hT / 2 ) + rnd( _wT / 2 ) + ( _wT / 2.25 )
        local xLow = ( n % 2 ) * _wT
        local xHi = xLow + _wT
        local xPos = ( rnd( xLow, xHi ) + rnd( xLow, xHi ) + rnd( xLow, xHi )) / 3
        local yPos = yRange * ( n - 1 )
        local rotSpeed = 1.75 - rnd( 3.5 )
        local rotPos = 0
        local alpha = rnd()
        if alpha < 0.2 then
            alpha = alpha + 0.2
        elseif alpha > 0.925 then
            alpha = alpha - 0.075
        end
        gears[n] = display.newImageRect( "cog" .. n .. ".png", size, size )
--        gears[n]:setFillColor( 5, 255, 32 )
        gears[n].alpha = 0.40
        gears[n].x = xPos
        gears[n].y = yPos
        gears[n].rotSpeed = rotSpeed
        gears[n].rotPos = rotPos
        group:insert( gears[n] )
    end
end

-- spin the gears; runs repeatedly
local function rotatorCuff()
    local spin = sine( system.getTimer() * 0.00014 )
    for n = 1, numberOfGears do
        gears[n].rotPos = gears[n].rotPos + ( gears[n].rotSpeed * spin )
        gears[n].rotation = gears[n].rotPos % 360
    end
end

-- prepare the screen.  Runs once only.  now corona v2.0 friendly!
-- this is where we create the box that will contain our
-- falling data...

local function screenPrep()
    display.setStatusBar( display.HiddenStatusBar )
    local backing = display.newImageRect( "industrialBackground.jpg", _w, _h )
    backing.x = _wT
    backing.y = _hT
    base:insert( backing )
    physics.start()
    z1 = display.newRect(_w/2,_h,_w,2) -- floor
    z2 = display.newRect(0,_h/2,-2,_h) -- left
    z3 = display.newRect(_w,_h/2,2,_h) -- right
    physics.addBody(z1, "static")
    physics.addBody(z2, "static")
    physics.addBody(z3, "static")
end

local function clockers()
    local function replaceFloor()
--        print("Replacing floor")
        if not (z1) then
            z1 = display.newRect(_w/2,_h,_w,2)
            physics.addBody(z1, "static")
        end
    end    
    if triggerClean == true then
        triggerClean = false
        replaceFloor()
    end
    local day = os.date("%A")
    local mon = os.date("%B")
    local tim = os.date("%R")
    block1 = display.newText(day,rnd(50,_w-75),-40,"Helvetica Bold",18*tMod)
    block2 = display.newText(mon,rnd(70,_w-110),-75,"Helvetica",25*tMod)
    block3 = display.newText(tim,rnd(90,_w-130),-110,"Helvetica",29*tMod)
    block1:setFillColor(245/255,22/255,44/255)
    block3:setFillColor(250/255,240/255,50/255)
    physics.addBody(block1, "dynamic")
    physics.addBody(block2, "dynamic")
    physics.addBody(block3, "dynamic")    
end

local function dumpster( e )
    print("Dumping most of the screen now.")
    triggerClean = true
    physics.removeBody(z1)
    z1 = nil
    -- nil means "nothing."  It is akin to what human beings
    -- typically mean when they say "zero."  But the computer
    -- understands an important difference between
    -- "1 minus 1" and "nothing at all."  Assiging the variable
    -- z1 the value of "nil", in this case,
    -- eradicates the variable, so that the computer
    -- can reclaim its memory, etc... as though it
    -- never existed.
end

-- even though this is the "end" of the program, this is the
-- code that really runs.  First, it calls the custom function
-- "setup()".  Then I call the custom function "screenPrep()".
-- The rest of the code, beginning with line 25 or so, is a collection
-- of custom functions that are repeatedly "called" (or "run")
-- by the 3 seperate timers listed below.

setup()
screenPrep()
-- performWithDelay typically gets at least three arguments:
-- 1.  when to run (every n milliseconds);
-- 2.  what to run (which function, e.g., rotatorCuff(), or clockers())
-- 3.  how often to run (in this case, "0" means "run forever."  But
    -- "2" would mean "run just 2 times.")
timer.performWithDelay( 32, rotatorCuff, 0 )
timer.performWithDelay( 7455, clockers, 0 )
timer.performWithDelay( 58101, dumpster, 0 )



