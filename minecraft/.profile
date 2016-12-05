function mcserver { 
	echo forge-1.10.2 $*
	/etc/init.d/forge-1.10.2 $*
}

alias a=alias
alias aed='vi ~/.profile'
alias are='. ~/.profile'
alias aload='cp /vagrant/script/minecraft/.profile ~/ && are'
alias asave='cp ~/.profile /vagrant/script/minecraft/'
alias c='export player=chsliu && echo player=$player'
alias y='export player=yozliu && echo player=$player'
alias diamond='export item=diamond && echo item=$item'
alias  s1='export pos="-242 74 291"  && echo pos=蚊子車站'
alias  s2='export pos="986 103 291"   && echo pos=山丘車站'
alias  s3='export pos="986 103 -738"  && echo pos=陸湖車站'
alias  s4='export pos="-242 103 -738" && echo pos=水下車站'
alias tnt='export pos="540 82 310"   && echo pos=TNT礦車轟炸點'
alias tp='mcserver do tp $player $pos'
alias ungod='mcserver do gamemode s $player'
alias god='mcserver do gamemode c $player'
alias rain='mcserver do toggledownfall'
alias gamestop='mcserver backup && mcserver stop'
alias give='mcserver do give $player $item 64'
