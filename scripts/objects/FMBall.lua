---@class FMBall : Sprite
---@overload fun(...) : FMBall
local FMBall, super = Class(Sprite)

---@enum FMBall.types
-- I hate my life
FMBall.TYPES = {
	fore = 1,
    back = 2,
}

function FMBall:init(x, y, type)
    super.init(self, "world/cutscenes/fountain_make/ball", x, y, nil, nil, nil)

    self:setOriginExact(24, 24)
    --depth = 12

    self._create_back = false
    if type == nil then
        type = FMBall.TYPES.fore
        self._create_back = true
    end
    self.type = type
    local scale = 2
    if self.type == FMBall.TYPES.fore then
        self.scale_x = 0.05 * scale
        self.scale_y = 0.05 * scale
        self.color = COLORS["black"]
        self.physics.speed_x = (-1 + Utils.random(2)) * scale
        self.physics.speed_y = (-0.5 + Utils.random(-1)) * scale
        self.physics.gravity = (0.06 + Utils.random(0.02)) * scale
        self.physics.gravity_direction = math.rad((85 + Utils.random(10)) + 180)
        self.physics.friction = 0.05 * scale
    else
        self.scale_x = 0.1 * scale
        self.scale_y = 0.1 * scale
        self.color = COLORS["white"]
    end

    self.size = 0
    self.graphics.grow = 0.01 * scale
end

function FMBall:onAdd(parent)
    if self._create_back then
        local x, y = self:getRelativePos(self.width/2, self.height/2)
        local backball = FMBall(x, y, FMBall.TYPES.back)
        backball.layer = self.layer - 1
        backball.physics.gravity = self.physics.gravity
        backball.physics.gravity_direction = self.physics.gravity_direction
        backball.physics.friction = self.physics.friction
        backball.physics.speed_x = self.physics.speed_x
        backball.physics.speed_y = self.physics.speed_y
        parent:addChild(backball)
    end
end

function FMBall:update()
    super.update(self)

    self.size = self.size + 0.5 * DTMULT
    local _, y = self:getRelativePosFor(self.parent)
    if y <= -20 - self.size then
        self:remove()
        return
    end
end

return FMBall