return
---@param cutscene WorldCutscene
function(cutscene)
    local kris = cutscene:getCharacter("kris")
    Game:setFlag("balls", true)
    cutscene:detachCamera()
    kris:setPosition(990, 345)
    kris.layer = kris.layer + 25
    cutscene:panTo(950, 0, 0)

    cutscene:setAnimation(kris, "make_fountain/grab_knife")
    cutscene:wait(70/30)
    local kris_x, kris_y = kris:getRelativePos(0, 0)
    local knife_shine = Sprite("effects/make_fountain/knife_shine", kris_x + 12, kris_y + 48)
    knife_shine:setScale(2)
    knife_shine:setOriginExact(4, 4)
    knife_shine:setAnimation({"effects/make_fountain/knife_shine", 1/3.75, false, callback=function(sprite)
        sprite:remove()
    end})
    knife_shine:setLayer(kris.layer - 1)
    Game.world:addChild(knife_shine)
    cutscene:wait(2)

    local blaze_vfx = true
    local blaze_vfx_off_for_one_frame_for_some_reason = false
    local blaze_vfx_timer = 0
    cutscene:setAnimation(kris, "make_fountain/target")
    Game.world.timer:every(1/30, function()
        if blaze_vfx_off_for_one_frame_for_some_reason then
            blaze_vfx_off_for_one_frame_for_some_reason = false
        else
            cutscene:playSound("fountain_target")
            blaze_vfx_timer = blaze_vfx_timer + 1
            local blaze_shine = Sprite("effects/make_fountain/blaze_shine", kris_x - 40 + blaze_vfx_timer * 6, kris_y + 10 + Utils.random(20))
            blaze_shine:setScale(2)
            blaze_shine:setOriginExact(4, 4)
            blaze_shine:setAnimation({"effects/make_fountain/blaze_shine", 1/15, false, callback=function(sprite)
                sprite:remove()
            end})
            blaze_shine:setLayer(kris.layer - 1)
            Game.world:addChild(blaze_shine)
        end
        return blaze_vfx
    end)
    cutscene:wait(1/3)
    blaze_vfx_off_for_one_frame_for_some_reason = true
    cutscene:wait(1/30)
    cutscene:wait(1/3)
    blaze_vfx = false

    cutscene:playSound("fountain_make", 1, Game.world.timescale)
    local pillar = FMPillar(kris.x, kris.y)
    Game.world:spawnObject(pillar, kris.layer - 0.5)
    
    local white_house = Sprite("world/maps/tilesets/room1/spr_cutscene_32_room_black_white", 1, 1)
    white_house:setColor(0.9,0.9,0.9)
    white_house:setLayer(kris.layer - 1)
    white_house.alpha = 0
    white_house:fadeTo(1, 0.3)
    Game.world:addChild(white_house)
    cutscene:setAnimation(kris, "make_fountain/make")

    local center_x = kris_x + 18 * 2
    local center_y = kris_y + 57 * 2
    cutscene:wait(0.2)
    cutscene:setAnimation(kris, "make_fountain/make_loop")

    cutscene:wait(6)
    white_house:fadeOutAndRemove(.4)
    cutscene:setSprite(kris, "make_fountain/make_stop")
    local part_maker = Game.world.timer:every(1/30, function()
        local x, y = 1000, 350
            Game.world:spawnObject(FMBall(x, y), Game.world.player.layer - 2)
    end)
    Game.world:spawnObject(FMCeilingFog(), Game.world.player.layer + 3)
    cutscene:wait(3)
    

    --kris.layer = kris.layer - 25
    local ball_col_check = true
    cutscene:during(function()
        if not ball_col_check then return false end

        Object.startCache()
        for _,other in ipairs(Game.stage:getObjects(FMBall)) do
            ---@cast other FMBall
            if other:collidesWith(kris) then
                assert(other.type ~= FMBall.TYPES.back)
                local scale = 2
                other.physics.speed_x = other.physics.speed_x + (-4 + Utils.random(8)) * scale
                other.physics.speed_y = other.physics.speed_y - (Utils.random(3)) * scale
                other.back.physics.speed_x = other.physics.speed_x
                other.back.physics.speed_y = other.physics.speed_y
            end
        end
        Object.endCache()
    end)
    cutscene:setSprite(kris, "make_fountain/jump_off")
    kris.timescale = 2
    kris.physics.speed_y = -16/4
    kris.physics.speed_x = -2
    kris.physics.gravity = 1/2
    cutscene:wait(function() return kris.y >= 360 end)
    kris.timescale = 1
    kris.y = 360
    ball_col_check = false
    cutscene:setSprite(kris, "make_fountain/jump_off_landed")
    kris.physics.speed_y = 0
    kris.physics.speed_x = 0
    kris.physics.gravity = 0
    cutscene:wait(2)
    
    cutscene:wait(cutscene:setAnimation(kris, "make_fountain/stand_up"))
    cutscene:setSprite(kris, "make_fountain/walk_scare/left", 0)
    kris.sprite:stop()
    cutscene:wait(0.5)
    local function shakeStep(x, y)
        kris.sprite:stop()
        kris.sprite:setFrame(2)
        kris:move(x, y)
        cutscene:wait(0.5)
        kris.sprite:setFrame(1)
        cutscene:shakeCharacter(kris)
    end
    shakeStep(-20, 16)
    cutscene:wait(0.5)
    shakeStep(-8, 16)
    cutscene:wait(0.5)
    for _ = 1, 4 do
        shakeStep(-8, 0)
        cutscene:wait(0.5)
    end
end