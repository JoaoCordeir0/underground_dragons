local wf = require 'libraries/windfield'

ClasseMap = {}

ClasseMap.new = function(world)
    local self = self or {}

    self.world = world
    
    local espinho
    local espinhos = {}
    local wall
    local walls = {}

    -- Renderizando o mapa
    self.RenderMap = function(fase, gameMapWoods, gameMapCave)
        -- Função que carrega as colisões do mapa
        if fase == 1 or fase == 0 then
            if gameMapWoods.layers['Chao'] then
                for i, obj in pairs(gameMapWoods.layers['Chao'].objects) do
                    wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                    wall:setType('static')
                    table.insert(walls, wall)
                end
            end

            if gameMapWoods.layers['Espinhos'] then
                for i, obj in pairs(gameMapWoods.layers['Espinhos'].objects) do
                    espinho = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                    espinho:setType('static')
                    table.insert(espinhos, espinho)
                end
            end
        elseif fase == 2 or fase == 0 then
            if gameMapCave.layers['Chao'] then
                for i, obj in pairs(gameMapCave.layers['Chao'].objects) do
                    wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                    wall:setType('static')
                    table.insert(walls, wall)
                end
            end
        end
    end
        
    return self
end