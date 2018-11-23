var mine = false;
function autoMine(){
	if (txpool.status.pending && !mine){
		mine = true;
		miner.start();
	}
	if (!txpool.status.pending && mine){
		mine = false;
		miner.stop();
	}
}

setInterval(autoMine, 1000)