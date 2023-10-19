local OTSecurityCore = {}

OTSecurityCore.Security = function()
    local _protect_core             = {};

    _protect_core.variable          = {};
    _protect_core.variable.checking = false;
    _protect_core.variable.configs  = OTCore.farmwork.Security;

    _protect_core.apis              = {};
    _protect_core.apis.url          = { 'https://api.ipify.org/', 'https://' };
    _protect_core.apis.fetch        = PerformHttpRequest;

    _protect_core.events            = {}
    _protect_core.events.AddEvent   = AddEventHandler;
    _protect_core.events.ResgisCL   = RegisterNetEvent
    _protect_core.events.ResgisSV   = RegisterServerEvent;
    _protect_core.events.RegisNUI   = RegisterNuiCallback;
    _protect_core.events.Sent       = TriggerEvent;
    _protect_core.events.SentServer = TriggerServerEvent;
    _protect_core.events.SentClient = TriggerClientEvent;
    _protect_core.events.SentNUI    = SendNUIMessage;

    _protect_core.blocked           = {};
    _protect_core.blocked[1]        = 'AddEventHandler';
    _protect_core.blocked[2]        = 'RegisterNetEvent';
    _protect_core.blocked[3]        = 'RegisterServerEvent';
    _protect_core.blocked[4]        = 'RegisterNUICallback';
    _protect_core.blocked[5]        = 'TriggerEvent';
    _protect_core.blocked[6]        = 'TriggerServerEvent';
    _protect_core.blocked[7]        = 'TriggerClientEvent';
    _protect_core.blocked[8]        = 'SendNUIMessage';
    _protect_core.blocked[9]        = 'print';
    _protect_core.blocked[10]       = 'PerformHttpRequest';

    _protect_core.functions         = {};
    _protect_core.functions.Name    = GetCurrentResourceName();
    _protect_core.functions.Site    = IsDuplicityVersion();
    _protect_core.functions.Format  = string.format;
    _protect_core.functions.Lower   = string.lower;
    _protect_core.functions.Find    = string.find;
    _protect_core.functions.Decode  = json.decode;
    _protect_core.functions.Timeout = SetTimeout;
    _protect_core.functions.Print   = print;

    _protect_core.functions.Connected = function()
        Sent        = _protect_core.events.Sent;
        GetName     = _protect_core.functions.GetName;
        Regis       = _protect_core.functions.Regis;
        if ( _protect_core.functions.Site ) then
            SentClient = _protect_core.events.SentClient;
            Server_Site_Script_Function();
            Server_Site_Script();
        else
            SentServer = _protect_core.events.SentServer;
            RegisNUI   = _protect_core.events.RegisNUI;
            SentNUI    = _protect_core.events.SentNUI;

            Client_Site_Script_Function();
            Client_Site_Script();
        end
    end

    _protect_core.functions.Strfloor= function(data)
        local b= 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' 
        return ((data:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=6,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b:sub(c+1,c+1)
        end)..({ '', '', '' })[#data%3+1])
    end;

    _protect_core.functions.GetName    = function(_event_name, _register)
        if ( _register or _register == nil ) then 
            return _protect_core.functions.Strfloor(_protect_core.functions.Format('%s:%s', _event_name, _protect_core.functions.Name))
        else
            return _event_name
        end
    end

    _protect_core.functions.Regis      = function(_register_site, _event_name, _callblack)
        if ( _register_site ) then
            if ( _protect_core.functions.Site ) then
                _protect_core.events.ResgisSV(_event_name)
            else
                _protect_core.events.ResgisCL(_event_name)
            end
        end
        _protect_core.events.AddEvent(_event_name, _callblack)
    end

    _protect_core.functions.event_empty_checking = function(value)
        return value == nil or value == ""
    end

    _protect_core.functions.event_checking = {
        isChecking              = false;
        StartChecked = function(_seft, _event, _native, _callblack, ...)
            _seft.isChecking = false

            local _data_res = _protect_core.variable.configs.resources;
            local _data_event = _protect_core.variable.configs.events;

            for i = 1, #_data_res, 1 do
                if not _protect_core.functions.event_empty_checking(_data_res[i]) and _protect_core.functions.Find(_event, _protect_core.functions.Format('%s%s', '__cfx_export_', _data_res[i])) then
                    _seft.isChecking = true
                end
            end

            for i = 1, #_data_event, 1 do
                if not _protect_core.functions.event_empty_checking(_data_event[i]) and _protect_core.functions.Find(_event, _data_event[i]) then
                    _seft.isChecking = true
                end
            end

            if not _seft.isChecking then
                _protect_core.functions.Print(_protect_core.functions.Format('[^1ERROR^7] Detected events that were blocked from being called or sent ( ^1%s ^7/ ^1"%s" ^7)', _native, _event))
            else
                _callblack(...)
            end
            
        end,
    };

    _protect_core.functions.event_throughs = function(_natives, ...)
        if ( _protect_core.functions.Find(tostring(_natives), _protect_core.blocked[5]) ) then
            _protect_core.events.Sent(...);
        elseif ( _protect_core.functions.Find(tostring(_natives), _protect_core.blocked[6]) ) then
            _protect_core.events.SentServer(...);
        elseif ( _protect_core.functions.Find(tostring(_natives), _protect_core.blocked[7]) ) then
            _protect_core.events.SentClient(...);
        end
    end;

    _protect_core.functions.event_blockings = function(_natives, ...)
        local _event_name = ...

        if ( _protect_core.functions.Find(_natives, _protect_core.blocked[5]) ) then
            _protect_core.functions.event_checking:StartChecked(_event_name, _natives, function(...)
                _protect_core.events.Sent(...)
            end, ...)
        elseif ( _protect_core.functions.Find(_natives, _protect_core.blocked[6]) ) then
            _protect_core.functions.event_checking:StartChecked(_event_name, _natives, function(...)
                _protect_core.events.SentServer(...)
            end, ...)
        elseif ( _protect_core.functions.Find(_natives, _protect_core.blocked[7]) ) then
            _protect_core.functions.event_checking:StartChecked(_event_name, _natives, function(...)
                _protect_core.events.SentClient(...)
            end, ...)
        else
            if ( _protect_core.functions.Find(_event_name, 'onServerResourceStart') ) then
                _protect_core.events.AddEvent(...)
            elseif ( _protect_core.functions.Find(_event_name, 'onServerResourceStop') ) then
                _protect_core.events.AddEvent(...)
            elseif ( _protect_core.functions.Find(_event_name, 'onClientResourceStart') ) then
                _protect_core.events.AddEvent(...)
            elseif ( _protect_core.functions.Find(_event_name, 'onClientResourceStop') ) then
                _protect_core.events.AddEvent(...)
            elseif ( _protect_core.functions.Find(_event_name, '__cfx_export_'.._protect_core.functions.Name) ) then
                _protect_core.events.AddEvent(...)
            else
                _protect_core.functions.Print(_protect_core.functions.Format('[^1ERROR^7] This function is disabled. ( ^1"%s" ^7- ^1"%s"^7 )', _natives, _event_name))
            end
        end

    end;

    -- [! Start Block Events.
    AddEventHandler     = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[1], ...) end;
    RegisterNetEvent    = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[2], ...) end;
    RegisterServerEvent = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[3], ...) end;
    RegisterNUICallback = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[4], ...) end;
    TriggerEvent        = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[5], ...) end;
    TriggerServerEvent  = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[6], ...) end;
    TriggerClientEvent  = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[7], ...) end;
    SendNUIMessage      = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[8], ...) end;
    -- print               = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[9], ...) end;
    PerformHttpRequest  = function(...) _protect_core.functions.event_blockings(_protect_core.blocked[10], ...) end;
    -- [! End Block Events.

    if ( _protect_core.functions.Site ) then

        -- _protect_core.apis.fetch(_protect_core.apis.url[1], function(status, data, headers, errorCallback)
        --     _protect_core.apis.datablock    = debug.getinfo(1);
        --     _protect_core.apis.calldata     = debug.getinfo(2);
        --     _protect_core.apis.termanal     = debug.getinfo(_protect_core.apis.fetch, "L");

        --     -- if ( _protect_core.functions.Find(status, 200) ) then
        --         _protect_core.functions.Print('[^2VERIFY^7] Request for verification ^2Successful^7.');
        --         _protect_core.variable.checking = true;
        --         SetTimeout(5000, function()
        --             _protect_core.functions.Connected();
        --         end)
        --     -- else
        --     --     _protect_core.functions.Print('[^1VERIFY^7] Request for verification ^1Not Successful^7.');
        --     --     _protect_core.variable.checking = false;
        --     -- end

        -- end)

        -- _protect_core.functions.Regis(true, _protect_core.functions.GetName('__protect_core_require_verify', true), function()
        --     _protect_core.events.SentClient(_protect_core.functions.GetName('__protect_core_server_verify', true), source, _protect_core.variable.checking)
        -- end)

        _protect_core.functions.Timeout(1000, function()
            _protect_core.functions.Connected();
        end)
    else
        -- _protect_core.functions.Regis(false, _protect_core.functions.GetName('onClientResourceStart', false), function(resource)
        --     if _protect_core.functions.Find(resource, _protect_core.functions.Name) then
        --         _protect_core.functions.Print('[^2VERIFY^7] Request for verification ^3Loading...^7')
        --         _protect_core.functions.Timeout(5000, function()
        --             return _protect_core.events.SentServer(_protect_core.functions.GetName('__protect_core_require_verify', true))
        --         end)
        --     end
        -- end)
        -- _protect_core.functions.Regis(true, _protect_core.functions.GetName('__protect_core_server_verify', true), function(_status)
        --     if _status then
        --         _protect_core.functions.Connected();
        --         return _protect_core.functions.Print('[^2VERIFY^7] Request for verification ^2Successful^7.')
        --     end
        --     return _protect_core.functions.Print('[^1VERIFY^7] Request for verification ^1Not Successful^7.')
        -- end)

        _protect_core.functions.Timeout(1000, function()
            _protect_core.functions.Connected();
        end)
    end
end

OTSecurityCore.Security()
