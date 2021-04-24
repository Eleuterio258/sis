<?php

if (empty($_SESSION['active']))
{
        header('location: ../');
}

?>
<header>
		<div class="header">
			
			<h1><img class="logo1" src="img/log1.png">SIGCVRS.COM</h1>
			<div class="optionsBar">
				<p>Maputo, <?php echo date("d-M-Y - h:i a"); ?></p>
				<span>|</span>
				<span class="user"><?php echo $_SESSION['user'].'-'.$_SESSION['rol'] ; ?> </span>
				
				<a href="sair.php"><img class="close" src="img/sair.png" alt="Salir del sistema" title="Salir"></a>
			</div>
		</div>
		<?php include "nav.php"; ?>
	</header>
	<div class="modal">
	<div class="bodyModal">
	</div>
	</div>