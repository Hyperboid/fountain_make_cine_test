return function(cutscene)
    local x, y = Game.world.player:getRelativePos(Game.world.player.width/2, Game.world.player.height)
    local part_maker = Game.world.timer:every(1/30, function()
        Game.world:spawnObject(FMBall(x, y), Game.world.player.layer + 1)
    end)
    cutscene:wait(30)
    Game.world.timer:cancel(part_maker)
end