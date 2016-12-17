function utf8 {
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
}

function mcserver { 
	echo /etc/init.d/forge-1.10.2 $*
	/etc/init.d/forge-1.10.2 $*
}

utf8

alias a=alias
alias aed='vi ~/.profile'
alias are='. ~/.profile'
alias aload='cp /vagrant/script/minecraft/.profile ~/ && are'
alias asave='cp ~/.profile /vagrant/script/minecraft/'
alias p1='export player=chsliu && echo player=$player'
alias p2='export player=yozliu && echo player=$player'
alias  s1='export pos="-242 74 291"   && echo pos=蚊子車站'
alias  s2='export pos="986 103 291"   && echo pos=山丘車站'
alias  s3='export pos="986 103 -738"  && echo pos=陸湖車站'
alias  s4='export pos="-242 103 -738" && echo pos=水下車站'
alias tnt='export pos="540 82 310"    && echo pos=TNT礦車轟炸點'
alias cr1='export pos="-242 93 -256" && echo pos=田字東西起點'
alias cr2='export pos="256 103 291" && echo pos=田字南北起點'
alias diamond='export item=diamond && echo item=$item'
alias tp='mcserver do tp $player $pos'
alias ungod='mcserver do gamemode s $player'
alias god='mcserver do gamemode c $player'
alias rain='mcserver do toggledownfall'
alias gamestop='mcserver backup && mcserver stop'
alias give='mcserver do give $player $item 64'
alias day='mcserver do time set day'
alias night='mcserver do time set night'

