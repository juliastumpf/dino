local sti = require "sti"

function love.load()
    --screen size definitions
    screenSize = {x=love.graphics.getWidth(), y=love.graphics.getHeight()}
    screenSizeDefault = {x=240, y=160}
    screenScale = 1
    transX = 0.0 --transX, the most EXTREME trans
    transY = 0.0 --jeez its $CURRENT_YEAR you cant say transy anymore

    --letterbox stuff
    letterBoxX = (screenSize.x / 2) - (screenSizeDefault.x * screenScale / 2)
    letterBoxY = (screenSize.y / 2) - (screenSizeDefault.y * screenScale / 2)

    --set scaling/rotation/etc filter to nearest, to avoid blurry graphics
    love.graphics.setDefaultFilter("nearest")

    --load map file
    map = sti.new("assets/maps/test.lua")
    map:resize(screenWidth, screenHeight)

    --create new dynamic data layer called "entities" as the 4th layer
    local layer = map:addCustomLayer("entities", 4)

    -- Get player spawn object
    local player
    for k, object in pairs(map.objects) do
        if object.name == "player" then
            player = object
            break
        end
    end

    --create player object
    local sprite = love.graphics.newImage("assets/images/player.png")
    layer.player = {
        sprite = sprite,
        x      = player.x,
        y      = player.y,
    }

    --override player's draw function
    layer.draw = function(self)
        love.graphics.draw(
            self.player.sprite,
            math.floor(self.player.x),
            math.floor(self.player.y)
        )

        -- Temporarily draw a point at our location so we know
        -- that our sprite is offset properly
        love.graphics.setPointSize(1)
        love.graphics.setColor(0,128,0)
        love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
    end

    -- add controls to player
    layer.update = function(self, dt)
        -- 96 pixels per second
        local speed = 96

        -- Move player up
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            self.player.y = self.player.y - speed * dt
        end

        -- Move player down
        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            self.player.y = self.player.y + speed * dt
        end

        -- Move player left
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            self.player.x = self.player.x - speed * dt
        end

        -- Move player right
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            self.player.x = self.player.x + speed * dt
        end
    end
end

function love.update(dt)
	--update map
	map:update(dt)
end

function love.resize(w, h)
    --update screen size definition
    screenSize = {x=w, y=h}

    --figure out how to scale the screen
    local scaleX = w / screenSizeDefault.x
    local scaleY = h / screenSizeDefault.y
    screenScale  = math.min(scaleX, scaleY)
    screenScale2 = 1 / screenScale

    --resize map area so it all draws
    map:resize(w, h)

    --letterbox stuff
    letterBoxX = (screenSize.x / 2) - (screenSizeDefault.x * screenScale / 2)
    letterBoxY = (screenSize.y / 2) - (screenSizeDefault.y * screenScale / 2)
end

function love.draw()
    love.graphics.push()

    --centering on player
    local player = map.layers["entities"].player
    transX = (screenSize.x / 2) - (player.x * screenScale)
    transY = (screenSize.y / 2) - (player.y * screenScale)

    --translate the screen
    love.graphics.translate(transX, transY)

    --scale the screen
    love.graphics.scale(screenScale, screenScale)

    --draw world
    map:draw()

    --scale the screen pt.2
    love.graphics.scale(screenScale2, screenScale2)

    --set color to black
    love.graphics.setColor(0, 0, 0)

    --letterboxing
    if letterBoxX ~= 0 then
        love.graphics.rectangle("fill", -(transX-letterBoxX), 0, -0xffff, 0xffff)
        love.graphics.rectangle("fill", -(transX-letterBoxX-(screenSizeDefault.x*screenScale)), 0, 0xffff, 0xffff)
    elseif letterBoxY ~= 0 then
        love.graphics.rectangle("fill", 0, -(transY-letterBoxY), 0xffff, -0xffff)
        love.graphics.rectangle("fill", 0, -(transY-letterBoxY-(screenSizeDefault.y*screenScale)), 0xffff, 0xffff)
    end

    love.graphics.pop()

    --fps display
    love.graphics.setNewFont(10)
    love.graphics.setColor(128,128,128)
    love.graphics.print("fps: " .. love.timer.getFPS(), 0, 0)
end