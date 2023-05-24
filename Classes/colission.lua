ClasseColission = {}

ClasseColission.new = function()
    local self = self or {}    
    
    self.HaveColission = function(player, item)
        -- Calcular a distância centro a centro(Pitagoras)
        local distancia = math.sqrt((player.x - item.x) ^ 2 + (player.y - item.y) ^ 2)        
        -- Verificar a colisão
        return distancia < (player.size + item.size) / 2
    end

    return self
end