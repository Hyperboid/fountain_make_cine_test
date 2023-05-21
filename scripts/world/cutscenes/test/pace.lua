return
---@param cutscene WorldCutscene
function(cutscene)
    local kris = cutscene:getCharacter("kris")

    cutscene:detachCamera()
    kris:setPosition(484*2 + kris.width + 2, 140*2 + kris.height*2)
    cutscene:panTo(950, 0, 0)
    cutscene:wait(1)

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
        if not blaze_vfx then return false end
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
    end)
    cutscene:wait(1/3)
    blaze_vfx_off_for_one_frame_for_some_reason = true
    cutscene:wait(1/30)
    cutscene:wait(1/3)
    blaze_vfx = false

    cutscene:playSound("fountain_make")
    cutscene:setAnimation(kris, "make_fountain/make")
end