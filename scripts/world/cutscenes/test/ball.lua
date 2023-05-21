---@param cutscene WorldCutscene
return function(cutscene)
    cutscene:enableMovement()
    local part_maker = Game.world.timer:every(1/30, function()
        local x, y = Game.world.player:getRelativePos(Game.world.player.width/2, Game.world.player.height)
        Game.world:spawnObject(FMBall(x, y), Game.world.player.layer + 1)
    end)
end