Client_Site_Script = function ()
    local ESX = OTCore.farmwork.Core()
    local onPlayerSpawned = false

    -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    -- ################################################################ LOAD DATA FORM DATABASE ###########################################################
    Regis(true, 'playerSpawned', function()
        if not onPlayerSpawned then
            onPlayerSpawned = true
            SentServer(GetName('RequestDatas'))
        end
    end)

    Regis(true, GetName('GetDatas'), function(_data)
        OTCore.Function.Client.Variable.StatData = _data
        print(ESX.DumpTable(OTCore.Function.Client.Variable.StatData))
    end)

    -- ############################################################## END LOAD DATA FORM DATABASE #########################################################
    -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    exports('GetStat', function(_stat_type)
        if OTCore.Function.Client.Variable.StatData.main[_stat_type]  then
            return true, OTCore.Function.Client.Variable.StatData.main[_stat_type]
        else
            return false, "NoStatData"
        end
    end)
    
    -- Up Stat From Type
    exports('UpStat', function(_stat_type)
        if OTCore.Function.Client.Variable.StatData.main[_stat_type]  then
            if OTCore.Function.Client.Variable.StatData.point >= OTCore.RegisterMainStat[_stat_type].RequestPoint then
                OTCore.Function.Client.Variable.StatData.point                 = OTCore.Function.Client.Variable.StatData.point - OTCore.RegisterMainStat[_stat_type].RequestPoint
                OTCore.Function.Client.Variable.StatData.main[_stat_type]      = OTCore.Function.Client.Variable.StatData.main[_stat_type] + 1
               
                SentServer(GetName('onUpdateStat'), _stat_type, OTCore.Function.Client.Variable.StatData.main[_stat_type])
                SentServer(GetName('onUpdatePoint'), OTCore.Function.Client.Variable.StatData.point)
                return true, ('%s +1 And Point -%s'):format(_stat_type, OTCore.RegisterMainStat[_stat_type].RequestPoint)
            else
                return false, 'Dont Have Points'
            end
        else
            return false, "NoStatData"
        end
    end)

    RegisterCommand('up', function ()
        print(exports[GetCurrentResourceName()]:UpStat('STR_Strength'))
        print(exports[GetCurrentResourceName()]:UpStat('INT_Integer'))
        -- print(exports[GetCurrentResourceName()]:GetStat('INT_Integer'))
    end, false)

    -- exports[GetCurrentResourceName()]:UpStat('STR_Strength')     --[! UpStat From Type ( STR_Strength, INT_Integer)]
    -- exports[GetCurrentResourceName()]:GetStat('STR_Strength')    --[! GetStat From Type ( STR_Strength, INT_Integer)]

    -- ####################################################################### Debug ######################################################################

    function DisplayText(text, x, y, z)
        SetTextFont(0)  -- 0 is the default font
        SetTextScale(0.3, 0.3)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextDropshadow(0, 0, 0, 0, 0)
        SetTextEdge(1, 0, 0, 0, 205)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
    end

    CreateThread(function()
        while true do
            Wait(1)
            if OTCore.Function.Client.Variable.StatData.main then
                DisplayText(("Point %s"):format(OTCore.Function.Client.Variable.StatData.point), 0.0, 0.01 + 0.1)
                DisplayText(("STR_Strength %s"):format(OTCore.Function.Client.Variable.StatData.main['STR_Strength']), 0.0, 0.03  + 0.1)
                DisplayText(("INT_Integer %s"):format(OTCore.Function.Client.Variable.StatData.main['INT_Integer']), 0.0, 0.05  + 0.1)
            end
        end
    end)

    ExecuteCommand('refresh_stat')
    -- ##################################################################### End Debug ####################################################################
    -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

end