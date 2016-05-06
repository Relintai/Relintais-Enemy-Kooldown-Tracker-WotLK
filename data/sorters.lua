
--["1"] = "Ascending (CD left)",
function Vect:ComparerAscendingCDLeft(a, b)
	if a.endTime < b.endTime then
		return true;
	else
		return false;
	end
end

--["2"] = "Descending (CD left)",
function Vect:ComparerDescendingCDLeft(a, b)
	if a.endTime < b.endTime then
		return false;
	else
		return true;
	end
end

--["3"] = "Ascending (CD total)",
function Vect:ComparerAscendingCDTotal(a, b)
	if a.cd < b.cd then
		return true;
	else
		return false;
	end
end

--["4"] = "Descending (CD total)",
function Vect:ComparerDescendingCDTotal(a, b)
	if a.cd < b.cd then
		return false;
	else
		return true;
	end
end

--["5"] = "Recent first",
function Vect:ComparerRecentFirst(a, b)
	if a.currentTime < b.currentTime then
		return false;
	else
		return true;
	end
end

--["6"] = "Recent Last",
function Vect:ComparerRecentLast(a, b)
	if a.currentTime < b.currentTime then
		return true;
	else
		return false;
	end
end

--CD Type sorters

--["1"] = "Ascending (CD left)",
function Vect:ComparerAscendingCDLeftT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.endTime < b.endTime then
			return true;
		else
			return false;
		end
	end
end

--["2"] = "Descending (CD left)",
function Vect:ComparerDescendingCDLeftT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.endTime < b.endTime then
			return false;
		else
			return true;
		end
	end
end

--["3"] = "Ascending (CD total)",
function Vect:ComparerAscendingCDTotalT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.cd < b.cd then
			return true;
		else
			return false;
		end
	end
end

--["4"] = "Descending (CD total)",
function Vect:ComparerDescendingCDTotalT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.cd < b.cd then
			return false;
		else
			return true;
		end
	end
end

--["5"] = "Recent first",
function Vect:ComparerRecentFirstT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.currentTime < b.currentTime then
			return false;
		else
			return true;
		end
	end
end

--["6"] = "Recent Last",
function Vect:ComparerRecentLastT(a, b)
	local db = Vect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.currentTime < b.currentTime then
			return true;
		else
			return false;
		end
	end
end
