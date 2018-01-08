//////////////////////////////////////////////////////////////////////////
var __filename__ = "disableFly.js"
debug("vvvvv "+__filename__)

//////////////////////////////////////////////////////////////////////////
// var disablefly_timer
// if (disablefly_timer==null) { disablefly_timer = {} }
// debug("disablefly_timer getTimePassed="+getTimePassed(disablefly_timer))

//////////////////////////////////////////////////////////////////////////
// var disablefly
// if (disablefly==null) { disablefly = false }

//////////////////////////////////////////////////////////////////////////
function disableFly() {
	// disablefly=true
	// printWithPerm("minecraft.command.gamemode","移除飛行能力")
	// printWithPerm("minecraft.command.gamemode","\u79fb\u9664\u98db\u884c\u80fd\u529b")
	command("scoreboard players tag @a remove anvil")
	// command("scoreboard players tag @a[m=1] add anvil {Inventory:[{id:\"minecraft:anvil\"}]}")
	command("scoreboard players tag @a[m=1] add anvil")
	command("gamemode survival @a[tag=anvil]")
	command("gamemode creative @a[tag=anvil]")
}

//////////////////////////////////////////////////////////////////////////
if (disableFlyFlag) {
	disableFly()
	runLater("subscript/disableFly.js", "1s")
}

//////////////////////////////////////////////////////////////////////////
debug("^^^^^ "+__filename__)