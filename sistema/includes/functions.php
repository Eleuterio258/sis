<?php 
	date_default_timezone_set('America/Los_Angeles'); 
	
	function fechaC(){
		$mes = array("",
					"January",
					"February",
					"March",
					"April",
					"May",
					"June",
					"July",
					"August",
					"September",
					"October",
					"November",
					"December");
		return date('d')." de ". $mes[date('n')] . " de " . date('Y');
	}
