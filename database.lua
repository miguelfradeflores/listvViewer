module(..., package.seeall)

local _W = display.contentWidth
local _H = display.contentHeight
local sqlite3 = require ("sqlite3")

--Path to store the db file
local pathsql="recursos.sqlite"
local path = system.pathForFile(pathsql, system.DocumentsDirectory)

local table_list_names = "table_list_names"
local table_list_items = "table_list_items"

function init_db(  )
	
	db = sqlite3.open( path ) 

	local table1 = "create table if not exists " .. table_list_names .. "(id_list integer PRIMARY KEY AUTOINCREMENT, list_name VARCHAR(40) );"
	local table2 = "create table if not exists " .. table_list_items .. "(id_list_item integer PRIMARY KEY AUTOINCREMENT,id_list integer,  list_value VARCHAR(40) );"

	db:exec(table1)
	db:exec(table2)

	db:close()
end

-- local alumnos = {
--     {name="MAURICIO A.", score=0, avatar = 'default.jpg' },
-- 	{name="PATRICK", score=0, avatar = 'default.jpg' },
-- 	{name="ROBERTO", score=0, avatar = 'default.jpg' },
-- 	{name="IGNACIO", score=0, avatar = 'default.jpg' },
-- 	{name="KEN", score=0, avatar = 'default.jpg' },
-- 	{name="CESAR", score=0, avatar = 'default.jpg' },
-- 	{name="PAOLO", score=0, avatar = 'default.jpg' },
-- 	{name="SERGIO", score=0, avatar = 'default.jpg' },
-- 	{name="JORGE", score=0, avatar = 'default.jpg' },
-- 	{name="ERICK", score=0, avatar = 'default.jpg' },
-- 	{name="FERNANDA", score=0, avatar = 'default.jpg' },
-- 	{name="NURIA", score=0, avatar = 'default.jpg' },
-- 	{name="RAISA", score=0, avatar = 'default.jpg' },
-- 	{name="WEIMAR", score=0, avatar = 'default.jpg' },
-- 	{name="MAURICIO V.", score=0, avatar = 'default.jpg' }
-- }


local alumnos = {
{name="Alejandra Chirinos",score=0, avatar = 'default.jpg'},
{name="Ignacio del Rio",score=0, avatar = 'default.jpg'},
{name="Nicole Gongora",score=0, avatar = 'default.jpg'},
{name="Joel Jarro",score=0, avatar = 'default.jpg'},
{name="Fabian Machicado",score=0, avatar = 'default.jpg'},
{name="Cristian Paz",score=0, avatar = 'default.jpg'},
{name="Fabian Segurondo",score=0, avatar = 'default.jpg'},
{name="Ian Terceros",score=0, avatar = 'default.jpg'},
{name="Juan Tordoya",score=0, avatar = 'default.jpg'},
{name="Santiago Vargas",score=0, avatar = 'default.jpg'},			
{name="Lizzeth Vazques",score=0, avatar = 'default.jpg'},
{name="Rodrigo Villadegut",score=0, avatar = 'default.jpg'}
}


function loadData(  )
	db = sqlite3.open( path ) 
	local list_id = 1
	local list_name = "Alumnos"
	local query = "insert into " .. table_list_names .. " (list_name) values ('" .. list_name .. "');"

	db:exec(query)

	for i=1,#alumnos do
		local query = "insert into " .. table_list_items .. " (id_list, list_value) values (" .. list_id .. ", '" .. alumnos[i].name .. "');"

		db:exec(query)

	end
	db:close()
end

-- init_db()
-- loadData()

function add_list( list_name )
	
	db = sqlite3.open( path ) 
	local query = "insert into " .. table_list_names .. " (list_name) values ('" .. list_name .. "');"

	db:exec(query)
	db:close()

	return true
end


function create_list_items( list_tittle, items )
	
	local exiting_list = get_list(list_tittle)

	if exiting_list ~= nil then
		local list_id = exiting_list.id_list


		print(exiting_list, list_id)

		db = sqlite3.open( path ) 

		for i = 1, #items do
			print(list_id, items[i])
			local query = "insert into " .. table_list_items .. " (id_list, list_value) values (" .. list_id .. ", '" .. items[i] .. "');"
			db:exec(query)

		end

		db:close()

	end


end


function get_list( list_name )
	db = sqlite3.open( path ) 
	result = {}
	local query = "select * from " .. table_list_names .. " where list_name = '" .. list_name .."';"
	for x in db:nrows(query) do
		result = {id_list = x.id_list, name = x.list_name}
	end
		
	db:close()
	return result

end


function get_list_items( list_id )

	db = sqlite3.open( path ) 
	result = {}
	local query = "select * from " .. table_list_items .. " where id_list = " .. list_id ..";"
	local k = 1
	for x in db:nrows(query) do
		table.insert( result, x.list_value )
		k = k + 1
	end

	db:close()
	return result
end


function get_list_names(  )

	db = sqlite3.open( path ) 
	result = {}
	local query = "select * from " .. table_list_names .. ";"
	local k = 1
	for x in db:nrows(query) do
		result[k] = {id_list = x.id_list, name = x.list_name}
		k = k + 1
	end

	db:close()
	return result
end

