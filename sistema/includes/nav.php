<nav>
			<ul>
				<li><a href="index.php"><i class="fas fa-home"></i> Inicio</a></li>
				<?php
					if($_SESSION['rol'] ==1){
				?>
				<li class="principal">
					<a href="#"><i class="fa fa-user"></i> Usuarios</a>
					<ul>
						<li><a href="registro_usuario.php"><i class="fas fa-plus-circle"></i>Novo Usuario</a></li>
						<li><a href="lista_usuario.php"><i class="fas fa-clipboard-list"></i> Lista de Usuarios</a></li>
					</ul>
				</li>
					<?php } ?>
				<li class="principal">
					<a href="#"><i class="fas fa-users"></i> Clientes</a>
					<ul>
						<li><a href="registro_cliente.php"><i class="fas fa-plus-circle"></i>Novo Cliente</a></li>
						<li><a href="lista_cliente.php"><i class="fas fa-clipboard-list"></i> Lista de Clientes</a></li>
					</ul>
				</li>
				<?php
					if($_SESSION['rol'] ==1 || $_SESSION['rol'] == 2){
				?>
				<li class="principal">
					<a href="#"><i class="fas fa-industry"></i> Fornecedor</a>
					<ul>
						<li><a href="registro_fornecedor.php"><i class="fas fa-plus-circle"></i> Novo Fornecedor</a></li>
						<li><a href="lista_fornecedor.php"><i class="fas fa-clipboard-list"></i> Lista de Fornecedor</a></li>
					</ul>
				</li>
					<?php } ?>
				
				<li class="principal">
					<a href="#"><i class="fas fa-boxes"></i> Produtos</a>
					<ul>
					<?php
					if($_SESSION['rol'] ==1 || $_SESSION['rol'] == 2){
				?>
						<li><a href="registro_produto.php"><i class="fas fa-plus-circle"></i> Novo Produto</a></li>
						<?php } ?>
						<li><a href="lista_produto.php"><i class="fas fa-clipboard-list"></i> Lista de Produtos</a></li>
						<li><a href="registro_categories.php"><i class="fas fa-clipboard-list"></i>Nova Categoria</a></li>
						<li><a href="lista_categories.php"><i class="fas fa-clipboard-list"></i>Lista de Categoria</a></li>
					</ul>
				</li>
			
				<li class="principal">
					<a href="#"><i class="fas fa-coins"></i> Vendas</a>
					<ul>
						<li><a href="nova_venda.php"><i class="fas fa-plus-circle"></i> Novo Venda</a></li>
						<li><a href="vendas.php"><i class="fas fa-clipboard-list"></i> Vendas</a></li>
						<li><a href="vendascliente.php"><i class="fas fa-clipboard-list"></i> Vendas Clientes</a></li>
					</ul>
				</li>
			</ul>
		</nav>