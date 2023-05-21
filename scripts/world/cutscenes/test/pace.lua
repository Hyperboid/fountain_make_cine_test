return
---@param cutscene WorldCutscene
function(cutscene)
    local kris = cutscene:getCharacter("kris")

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

    cutscene:playSound("fountain_make")
    cutscene:setAnimation(kris, "make_fountain/make")

    local center_x = kris_x + 18 * 2
    local center_y = kris_y + 57 * 2

    cutscene:setSprite(kris, "make_fountain/make_stop")
    cutscene:wait(3)

    kris.layer = kris.layer - 25
    cutscene:setSprite(kris, "make_fountain/jump_off")
    kris.physics.speed_y = -16
    kris.physics.speed_x = -2
    kris.physics.gravity = 1
    --[[
        ballcheck = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_fountainball, 0, 1)
        if (ballcheck != noone)
        {
            with (ballcheck)
            {
                if (back == false)
                {
                    hspeed += (-4 + random(8))
                    vspeed -= random(3)
                    backball.hspeed = hspeed
                    backball.vspeed = vspeed
                }
            }
        }
    ]]
    cutscene:wait(function() return kris.y >= 360 end)
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
    for _ = 1, 8 do
        shakeStep(-8, 0)
        cutscene:wait(0.5)
    end
end