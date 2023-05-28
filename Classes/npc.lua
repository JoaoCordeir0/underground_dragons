local LG = love.graphics

ClasseNpc = {}

ClasseNpc.new = function(npc)
    local self = self or {}

    self.npc = npc

    -- Renderiza e executa animações do personagem
    self.RenderNpc = function()
        LG.draw(
            npc.spriteSheetIdle1[math.floor(npc.currentSpriteIdle1)],
            3660,
            535,
            0,
            1,
            1,
            npc.spriteSheetIdle1[1]:getWidth() / 2,
            npc.spriteSheetIdle1[1]:getHeight() / 2
        ) 
    end   

    self.LoadNpcImages = function()
        -- Animação de ficar Parado
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_00.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_01.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_02.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_03.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_04.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_05.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_06.png'))
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_07.png'))        
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_08.png'))        
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_09.png'))        
        table.insert(npc.spriteSheetIdle1, LG.newImage('Insumos/NpcEdwin/idle/npc_merchant_idle_10.png'))        

        -- Animação andando
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_00.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_01.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_02.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_03.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_04.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_05.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_06.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_07.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_08.png')) 
        table.insert(npc.spriteSheetRun1, LG.newImage('Insumos/NpcEdwin/run/npc_merchant_run_09.png')) 
    end

    self.RunThroughImagesNpcs = function(dt)
        -- Animação NPC        
        -- Animação Parado
        npc.currentSpriteIdle1 = npc.currentSpriteIdle1 + 10 * dt
        if npc.currentSpriteIdle1 >= 11 then
            npc.currentSpriteIdle1 = 1
        end   
         
        -- Animação de morte
        npc.currentSpriteRun1 = npc.currentSpriteRun1 + 10 * dt
        if npc.currentSpriteRun1 >= 10 then
            npc.currentSpriteRun1 = 1
        end        
    end
    
    return self
end
