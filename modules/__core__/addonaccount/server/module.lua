-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

self.Ready          = false
self.AccountsIndex  = {}
self.Accounts       = {}
self.SharedAccounts = {}

self.GetAccount = function(name, owner)
	for i=1, #self.Accounts[name], 1 do
		if self.Accounts[name][i].owner == owner then
			return self.Accounts[name][i]
		end
	end
end

self.GetSharedAccount = function(name)
	return self.SharedAccounts[name]
end

self.CreateAddonAccount = function(name, owner, money)

  local _self = {}

	_self.name  = name
	_self.owner = owner
	_self.money = money

	_self.getMoney = function()
    return _self.money
	end

	_self.addMoney = function(m)
		_self.money = _self.money + m
		_self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, _self.name, _self.money)
	end

	_self.removeMoney = function(m)
		_self.money = _self.money - m
		_self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, _self.name, _self.money)
	end

	_self.setMoney = function(m)
		_self.money = m
		_self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, _self.name, _self.money)
	end

	_self.save = function()
		if _self.owner == nil then
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name', {
				['@account_name'] = _self.name,
				['@money']        = _self.money
			})
		else
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner', {
				['@account_name'] = _self.name,
				['@money']        = _self.money,
				['@owner']        = _self.owner
			})
		end
	end

  return _self

end
