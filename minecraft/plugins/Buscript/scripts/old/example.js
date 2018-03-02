var __filename__ = "example.js"
debug("_____ "+__filename__)

// message("%target%", "You have just been given flight in the creative world for 30 minutes!")
// command("op %target%")
if (server.getOnlinePlayers().size() == 1) {
	broadcast("there's only one left")
}
broadcast(server.getOnlinePlayers().size())
broadcast(server.getMaxPlayers())
broadcast(server)
broadcast(plugin.getDataFolder())
broadcast("plugin=")
broadcast(plugin)
broadcast("metaData=")
broadcast(metaData)
// broadcast("economy=",economy)
// broadcast("permissions=",permissions)
// broadcast("chat=",chat)
broadcast("target=%target%")
if (stringReplace("%target%") == NULL) { broadcast("there's no target") }
broadcast("Hello, server, %target%")
// broadcast("Thanks for voting, %target%!")
broadcastPerm("Hello, some of you with such permission", "some.permission")
command("op someplayer")
// command("kick %target%")
commandSpoof("chsliu", "help")
commandSpoof("%target%", "/suicide")
message("%target%", "Best be respectin'")
message("chsliu", "Best be respectin'")
isOnline("chsliu")
isOnline("%target%")
run("somescript.txt")
runTarget("somescript.txt", "%target%")
runLater("somescript.txt", "30s")
runLaterTarget("somescript.txt", "1m45s", "%target%")
// clearScripts("%target%")
if (stringReplace("%target%") == "dumptruckman") { broadcast("do stuff") }
registerEvent("org.bukkit.event.entity.PlayerDeathEvent", "NORMAL", "player-died.txt")
hasPerm("%target%", "some.permission")
// hasPermOffline("world_nether", "%target%", "some.permission")
// addPerm("world_nether", "%target%", "some.permission")
// removePerm("world_nether", "%target%", "some.permission")
// hasMoney("%target%", 20.0)
// addMoney("%target%", 20.0)
// removeMoney("%target%", 20.0)


// var a = ['a', 'b', 'c'];
// a.forEach(msg)
// a.forEach(function(e) {
    // broadcast(e)
// })
// a.map(function(e){  
    // broadcast(e)
// })
// a.filter(function(e){  
    // broadcast(e)
// })
// a.reduce(function(e){  
    // broadcast(e)
// })
// var a = [1, 2, 3, 4];
// var newArr = a.filter(function(val){  
    // return val > 2;
// }).map(function(val){
    // return val * 2;
// })
// broadcast(newArr)

debug("^^^^^ "+__filename__)