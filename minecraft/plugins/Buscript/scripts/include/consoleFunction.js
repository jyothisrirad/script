//////////////////////////////////////////////////////////////////////////
var includedconsoleFunction
if (!includedconsoleFunction) {
includedconsoleFunction = true

//////////////////////////////////////////////////////////////////////////
var __filename__ = "consoleFunction.js"
broadcastPerm("vvvvv "+__filename__, "minecraft.command.op")

//////////////////////////////////////////////////////////////////////////
black="\u00a70"
dark_blue="\u00a71"
dark_green="\u00a72"
dark_aqua="\u00a73"
dark_red="\u00a74"
dark_purple="\u00a75"
gold="\u00a76"
gray="\u00a77"
dark_gray="\u00a78"
blue="\u00a79"
green="\u00a7a"
aqua="\u00a7b"
red="\u00a7c"
light_purple="\u00a7d"
yellow="\u00a7e"
white="\u00a7f"

scramble="\u00a7k"
bold="\u00a7l"
strike="\u00a7m"
underline="\u00a7n"
italian="\u00a7o"
off="\u00a7r"

//////////////////////////////////////////////////////////////////////////
function debug(e) {
	broadcastPerm(gold+bold+e, "minecraft.command.op")
}

function print(e) {
    broadcast(e)
}

function printWithPerm(perm,e) {
	broadcastPerm(green+bold+e, perm)
}

function say(t) {
	command("say "+t)
}

function tellraw(t) {
	command("tellraw @a [\"\",{\"text\":\""+t+"\"}]")
}

function title(t) {
	command("title @a title {\"text\":\""+t+"\"}")
}

function subtitle(t) {
	command("title @a subtitle {\"text\":\""+t+"\"}")
}

function actionbar(t) {
	command("title @a actionbar {\"text\":\""+t+"\"}")
}

function titles(t,s) {
	subtitle(s)
	title(t)
}

function playsound(t) {
	command("playsound "+t+" voice @p ~ ~ ~ 1 1 1")
}

debug("^^^^^ "+__filename__)
}