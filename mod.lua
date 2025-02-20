function Mod:postInit()
    Mod:doCutscene()
end

function Mod:doCutscene()
    Game.world:startCutscene("test/pace"):after(function ()
        Game.world:loadMap(Game.world.map.id)
        Mod:doCutscene()
    end)
end