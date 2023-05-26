local LG = love.graphics

ClasseMenu = {}

ClasseMenu.new = function()
    local self = self or {}    
    
    self.MenuButtons = function(suit)
        suit.layout:reset((LG.getWidth() / 2) - 250,(LG.getHeight() / 2) - 50)
        suit.layout:padding(10)
        suit.Label("Dragões do Submundo", (LG.getWidth() / 2) - 100,100, 200,30)
        
        if suit.Button("Iniciar História", {id=1}, suit.layout:row(500,50)).hit then            
            -- Refere-se a fase 1
            return 1
        end

        if suit.Button("Configurações", {id=3}, suit.layout:row(500,50)).hit then
            -- Refere-se as configurações
            return -2
        end
        
        if suit.Button("Sair", {id=2}, suit.layout:row()).hit then
            love.event.quit()
        end

        -- Refere-se a fase 0
        return 0
    end

    return self
end