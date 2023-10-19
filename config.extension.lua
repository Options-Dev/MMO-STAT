OTCore = {}

OTCore.DefaultPoint = 49

OTCore.RegisterDefaultMainStat = {
    ['STR_Strength']    = 1,
    ['INT_Integer']     = 1,
}

OTCore.RegisterDefaultSecondaryStat = {
    ['P_ATK'] = 0,
    ['M_ATK'] = 0,
}

OTCore.RegisterMainStat = {
    ['STR_Strength'] = {
        RequestPoint    = 2,
        OnUp            = {
            [1 --[[onUp]]]        = {
                Stats   = {
                    ['P_ATK'] = 1,
                    ['M_ATK'] = 1,
                    -- More Wait Update Next Vertion
                },
                StatsAction = function()

                end
            }
        }
    },
    ['INT_Integer'] = {
        RequestPoint    = 2,
        OnUp            = {
            [1]        = {
                Stats   = {
                    ['P_ATK'] = 1,
                    ['M_ATK'] = 1,
                },
                StatsAction = function()
                    
                end
            },
            [5]        = {
                Stats   = {
                    ['P_ATK'] = 5,
                    ['M_ATK'] = 5,
                },
                StatsAction = function()
                    
                end
            }
        }
    },
}