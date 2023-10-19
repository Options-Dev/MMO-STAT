Server_Site_Script = function ()
    local ESX = OTCore.farmwork.Core()
 

    Regis(false, 'playerConnecting', function()
        pcall(function()
            local src   = source
            local iden  = GetPlayerIdentifier(src, 0)
            exports.mongodb:findOne({ collection="option.llo.stats", query = { identifier = iden } }, function (success, result)
                if not success then
                    return
                end
                if #result <= 0 then
    
                    local document = {}
                    document.identifier = iden

                    document.point = OTCore.DefaultPoint
    
                    document.main  = {}
                    document.secondary  = {}
    
                    for key, value in pairs(OTCore.RegisterDefaultMainStat) do
                        document.main[key] = value
                    end
    
                    for key, value in pairs(OTCore.RegisterDefaultSecondaryStat) do
                        document.secondary[key] = value
                    end
    
                    exports.mongodb:insertOne({ collection="option.llo.stats", document = document }, function (success, result, insertedIds)
                        if not success then
                            return
                        end
    
                        document._id = nil
                        document.identifier = nil
                        OTCore.Function.Server.Variable.StatData[iden] = document
                        print(('[%s] [ID: %s] Save data with variables'):format(GetCurrentResourceName(), iden))
                    end)
                else
                    result[1]._id = nil
                    result[1].identifier = nil
                    OTCore.Function.Server.Variable.StatData[iden] = result[1]
                    print(('[%s] [ID: %s] Save data with variables'):format(GetCurrentResourceName(), iden))
                end
            end)
        end)
    end)

    Regis(false, 'playerDropped', function()
        local src   = source
        local iden  = GetPlayerIdentifier(src, 0)
        if OTCore.Function.Server.Variable.StatData[iden] then
            pcall(function()
                exports.mongodb:updateOne({
                    collection  = "option.llo.stats",
                    query       = { identifier = iden },
                    update      = {
                        ["$set"] = OTCore.Function.Server.Variable.StatData[iden]
                    }
                })
                print(ESX.DumpTable(OTCore.Function.Server.Variable.StatData[iden]))
                OTCore.Function.Server.Variable.StatData[iden] = nil
            end)
            print(('[%s] [ID: %s] Exit and delete data saved with variables'):format(GetCurrentResourceName(),iden))
        end
    end)

    Regis(true, GetName('RequestDatas'), function()
        local src   = source
        local iden  = GetPlayerIdentifier(src, 0)
        if OTCore.Function.Server.Variable.StatData[iden] then
            SentClient(GetName('GetDatas'), src, OTCore.Function.Server.Variable.StatData[iden])
        end
    end)

    Regis(true, GetName('onUpdateStat'), function(_stat_type, _count)
        local src   = source
        local iden  = GetPlayerIdentifier(src, 0)
        if OTCore.Function.Server.Variable.StatData[iden] then
            OTCore.Function.Server.Variable.StatData[iden].main[_stat_type] = _count
        end
    end)

    Regis(true, GetName('onUpdatePoint'), function(_count)
        local src   = source
        local iden  = GetPlayerIdentifier(src, 0)
        if OTCore.Function.Server.Variable.StatData[iden] then
            OTCore.Function.Server.Variable.StatData[iden].point = _count
        end
    end)

    RegisterCommand('refresh_stat', function ()
        local _allPed = ESX.GetPlayers()
        for i = 1, #_allPed, 1 do
            local xPlayer = ESX.GetPlayerFromId(_allPed[i])
            local src   = xPlayer.source
            local iden  = GetPlayerIdentifier(src, 0)
            pcall(function()
                exports.mongodb:findOne({ collection="option.llo.stats", query = { identifier = iden } }, function (success, result)
                    if not success then
                        return
                    end
                    if #result <= 0 then
        
                        local document = {}
                        document.identifier = iden
    
                        document.point = OTCore.DefaultPoint
        
                        document.main  = {}
                        document.secondary  = {}
        
                        for key, value in pairs(OTCore.RegisterDefaultMainStat) do
                            document.main[key] = value
                        end
        
                        for key, value in pairs(OTCore.RegisterDefaultSecondaryStat) do
                            document.secondary[key] = value
                        end
        
                        exports.mongodb:insertOne({ collection="option.llo.stats", document = document }, function (success, result, insertedIds)
                            if not success then
                                return
                            end
        
                            document._id = nil
                            document.identifier = nil
                            OTCore.Function.Server.Variable.StatData[iden] = document
                            print(('[%s] [ID: %s] Save data with variables'):format(GetCurrentResourceName(), iden))
                        end)
                    else
                        result[1]._id = nil
                        result[1].identifier = nil
                        OTCore.Function.Server.Variable.StatData[iden] = result[1]
                        print(('[%s] [ID: %s] Save data with variables'):format(GetCurrentResourceName(), iden))
                    end
                end)
            end)

            Wait(100)
            if OTCore.Function.Server.Variable.StatData[iden] then
                SentClient(GetName('GetDatas'), src, OTCore.Function.Server.Variable.StatData[iden])
            end
        end
    end, false)

end