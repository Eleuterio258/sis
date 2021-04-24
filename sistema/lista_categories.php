<?php 
    session_start();
    if($_SESSION['rol'] !=1 and $_SESSION['rol'] !=2)
    {
        header("location: ./");
    }

    include "../conn.php";
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<?php include "includes/scripts.php"; ?>
	<title>Lista de Categoria</title>
</head>
<body>
<?php include "includes/header.php"; ?>
	<section id="container">
		<h1><i class="fas fa-industry"></i> Lista de Categoria</h1>
        <a href="registro_categories.php" class="btn_new"><i class="fas fa-plus-circle"></i> Registrar Categorias</a>
        
        <form action="#" method="get" class="form_search">
            <input type="text" name="busqueda" id="busqueda" placeholder="Buscar">
            <button type="submit" class="btn_view"><i class="fas fa-search"></i></button>
        </form>
        <table>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Image</th>
                <th>Data de Cadastro</th>
                <th>Ações</th>
            </tr>
        <?php
        //Paginador
        $sql_registe = mysqli_query($conn, "SELECT COUNT(*) as total_registro FROM proveedor WHERE estatus = 1 ");
        $result_register = mysqli_fetch_array($sql_registe);
        $total_registro = $result_register['total_registro'];
 
        $por_pagina = 5;

        if(empty($_GET['pagina']))
        {
            $pagina =1;
        }else{
            $pagina = $_GET['pagina'];
        }

        $desde = ($pagina-1) * $por_pagina;
        $total_paginas = ceil($total_registro / $por_pagina);

            $query = mysqli_query($conn, "SELECT*FROM categories 
                                                WHERE status = 1 
                                                ORDER BY id ASC LIMIT $desde,$por_pagina");
            
            mysqli_close($conn);

            $result = mysqli_num_rows($query);
            if($result > 0){

                    while($data = mysqli_fetch_array($query)){

                        $formato = 'Y-m-d H:i:s';
                        $fecha = DateTime::createFromFormat($formato,$data["created_at"]);
                       ?>
                <tr>
                <td><?php echo $data["id"] ?></td>
                <td><?php echo $data["name"] ?></td>
                <td class="img_producto"><img src="<?php echo $icon;?>"></td>
                <td><?php echo $fecha->format('d-m-Y'); ?></td>
                <td>
                    <a class="link_edit" href="#"><i class="fas fa-edit"></i> Editar</a>
                    |
                    <a class="link_delete" href="#"><i class="fas fa-trash-alt"></i> Eliminar</a>
                </td>
            </tr>
            <?php
                    }
        }
        ?>
        </table>
        <div class="paginador"> 
            <ul>
                <?php
                    if($pagina != 1)
                    {
                ?>
                <li><a href="?pagina=<?php echo 1; ?>"><i class="fas fa-angle-double-left"></i></a></li>
                <li><a href="?pagina=<?php echo $pagina-1; ?>"><i class="fas fa-angle-left"></i></a></li>
            <?php
                    }
                for ($i=1; $i <= $total_paginas; $i++){
                    if($i == $pagina)
                    {
                        echo '<li class="pageSelected">'.$i.'</li>';
                    }else{
                        echo '<li><a href="?pagina='.$i.'">'.$i.'</a></li>';
                    }
                    
                }
                if($pagina != $total_paginas)
                {
                ?>
                <li><a href="?pagina=<?php echo $pagina + 1; ?>"><i class="fas fa-angle-right"></i></a></li>
                <li><a href="?pagina=<?php echo $total_paginas; ?>"><i class="fas fa-angle-double-right"></i></a></li>
                <?php } ?>
    </div>
	</section>
	<?php include "includes/footer.php"; ?>
</body>
</hmtl>