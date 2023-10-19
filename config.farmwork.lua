OTCore.farmwork     = {
    Core            = function()
        return exports["es_extended"]:getSharedObject();
    end,
    Security        = {
        resources   = {
            'es_extended',
            'mongodb',
            'option_stats'
        },
        events      = {
            'esx:getSharedObject',
        }
    }
}