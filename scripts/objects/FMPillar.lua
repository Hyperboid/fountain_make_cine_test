---@class FMPillar: Object
---@overload fun(x?:number,y?:number, maker: Character)
local FMPillar, super = Class(Object)

function FMPillar:init(x, y, maker)
    super.init(self,x,y, 160,720)
    self:setOrigin(0.5,1)
    self.shader_params = {inversion = 0}
    ---@type Character
    self.maker = maker
    if self.maker then
        self.maker:addFX(ShaderFX("fm_invert", self.shader_params), "fm_invert")
    end
    self.draw_children_above = 0
    self.draw_children_below =-0.0001
    self.anim_timer = 0
end

function FMPillar:update()
    self.anim_timer = self.anim_timer + DT
    self.shader_params.inversion = Utils.clampMap(self.anim_timer, 3, 4, 0, 1)
    if self.anim_timer >= 7 then self:remove() end
end

function FMPillar:onRemove(parent)
    super.onRemove(self,parent)
    if self.maker then
        self.maker:removeFX("fm_invert")
    end
end

function FMPillar:drawCoolEllipse(height, base_width)
    love.graphics.ellipse("fill", 0,-height, Utils.clampMap(math.sin(self.anim_timer*math.pi*16),-1,1, base_width, base_width + 6), height, 32)
end

function FMPillar:draw()
    love.graphics.translate(80, 720)
    local height = Utils.clampMap(self.anim_timer, 0.2, 0.3, 3, 320)
    love.graphics.scale(Utils.clampMap(self.anim_timer, 0.1, 0.2, 2, 1),1)
    love.graphics.scale(Utils.clampMap(self.anim_timer, 6, 6.1, 1, 0),1)
    self:drawCoolEllipse(height, 100)
    local inner_luma = Utils.clampMap(self.anim_timer, 3,4,1,0)
    Draw.setColor(inner_luma, inner_luma, inner_luma)
    self:drawCoolEllipse(height, 96)
    if DEBUG_RENDER then
        Draw.setColor(COLORS.red)
        love.graphics.setFont(Assets.getFont("main_mono"))
        love.graphics.print("timer:" .. self.anim_timer)
    end
end

return FMPillar