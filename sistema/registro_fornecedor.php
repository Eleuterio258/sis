<?php
    session_start();
    if($_SESSION['rol'] !=1 and $_SESSION['rol'] !=2)
    {
        header("location: ./");
    }

    include "../conn.php";

    if(!empty($_POST))
    {
        $alert='';
        if(empty($_POST['proveedor']) || empty($_POST['contacto']) || empty($_POST['telefono']) || empty($_POST['direccion']))
        {
            $alert='<p class="msg_error">Todos os campos são obrigatórios.</p>';
        }else{

            $proveedor = $_POST['proveedor'];
            $contacto = $_POST['contacto'];
            $telefono = $_POST['telefono'];
            $direccion = $_POST['direccion'];
            $usuario_id = ($_SESSION['idUser']);
            
                $query_insert = mysqli_query($conn,"INSERT INTO proveedor(proveedor,contacto,telefono,direccion,usuario_id)
                                                        VALUES('$proveedor','$contacto','$telefono','$direccion','$usuario_id')");

                if($query_insert){
                    $alert='<p class="msg_save">Proveedor guardado correctamemte.</p>';
                }else{
                    $alert='<p class="msg_error">Error al guardar proveedor.</p>';
                }
            } 
            mysqli_close($conn);     
    }
   
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<?php include "includes/scripts.php"; ?>
	<title>Registro de Fornecedor</title>
</head>
<body>
<?php include "includes/header.php"; ?>
	<section id="container">

		<div class="form_register">
        <h1><i class="fas fa-industry"></i> Registro de Fornecedor</h1>
        <hr> 
        <div class="alert"><?php echo isset($alert) ? $alert : ''; ?></div>

        <form action="" method="post">
            <label for="proveedor">Fornecedor</label>
            <input type="text" name="proveedor" id="proveedor" placeholder="Nome de Fornecedor">
            <label for="contacto">Contacto</label>
            <input type="text" name="contacto" id="contacto" placeholder="Contacto">
            <label for="telefono">Telefono</label>
            <input type="number" name="telefono" id="telefono" placeholder="Telefone">
            <label for="direccion">Endereço</label>
            <input type="text" name="direccion" id="direccion" placeholder="Endereço completo">
           
         
            <input type="submit" value="Salvar Fornecedor" class="btn_save">
            
        </form>

    	</section>

	<?php include "includes/footer.php"; ?>
</body>
</html>