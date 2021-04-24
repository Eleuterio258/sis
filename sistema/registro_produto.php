<?php
session_start();
if ($_SESSION['rol'] != 1 and $_SESSION['rol'] != 2) {
    header("location: ./");
}

include "../conn.php";

if (!empty($_POST)) {
    $alert = '';
    if (
        empty($_POST['proveedor']) ||
        empty($_POST['producto']) ||
        empty($_POST['precio']) ||
        empty($_POST['category_id']) ||
        empty($_POST['discount']) ||
        empty($_POST['discount']) ||
        empty($_POST['detail'])
    ) {
        $alert = '<p class="msg_error">Todos os campos são obrigatórios.</p>';
    } else {

        $proveedor = $_POST['proveedor'];
        $producto = $_POST['producto'];
        $precio = $_POST['precio'];
        $discount = $_POST['discount'];
        $category_id = $_POST['category_id'];
        $detail = $_POST['detail'];
        $cantidad = $_POST['cantidad'];
        $usuario_id = ($_SESSION['idUser']);

        $foto = $_FILES['foto'];
        $nombre_foto = $foto['name'];
        $type = $foto['tmp_name'];
        $url_temp = $foto['tmp_name'];

        $imgProducto = 'img_producto.jpg';

        if ($nombre_foto != '') {
            $destino = 'img/uploads/';
            $img_nombre = 'img_' . md5(date('d-m-Y H:m:s'));
            $imgProducto = $img_nombre . '.jpg';
            $src = $destino . $imgProducto;
        }

        $query_insert = mysqli_query($conn, "INSERT INTO products(proveedor,descripcion,precio,existencia,category_id,detail,discount,usuario_id,foto)
                                                        VALUES('$proveedor','$producto','$precio','$cantidad','$category_id','$detail','$discount','$usuario_id','$imgProducto')");

        if ($query_insert) {
            if ($nombre_foto != '') {
                move_uploaded_file($url_temp, $src);
            }
            $alert = '<p class="msg_save">Producto guardado correctamemte.</p>';
        } else {
            $alert = '<p class="msg_error">Error al guardar el Producto.</p>';
        }
    }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <?php include "includes/scripts.php"; ?>
    <title>Registro Producto</title>
</head>

<body>
    <?php include "includes/header.php"; ?>
    <section id="container">

        <div class="form_register">
            <h1><i class="fas fa-boxes"></i> Registro Produto</h1>
            <hr>
            <div class="alert"><?php echo isset($alert) ? $alert : ''; ?></div>

            <form action="" method="post" enctype="multipart/form-data">
                <!-- FORNECEDORES  -->
                <label for="proveedor">Fornecedor</label>

                <?php
                $query_proveedor = mysqli_query($conn, "SELECT codproveedor, proveedor FROM proveedor WHERE estatus= 1 ORDER BY proveedor ASC");
                $result_proveedor = mysqli_num_rows($query_proveedor);

                ?>
                <select name="proveedor" id="proveedor">
                    <?php

                    if ($result_proveedor > 0) {
                        while ($proveedor = mysqli_fetch_array($query_proveedor)) {
                    ?>
                            <option value="<?php echo $proveedor['codproveedor']; ?>"><?php echo $proveedor['proveedor'] ?></option>
                    <?php
                        }
                    }
                    ?>

                </select>
                <!-- FIM  -->

                <!-- CATEGORIA   -->
                <label for="categories">Categoria</label>

                <?php
                $query_categories = mysqli_query($conn, "SELECT id,name FROM categories  WHERE status= 1 ORDER BY name ASC");
                $result_categories = mysqli_num_rows($query_categories);

                ?>
                <select name="categories" id="categories">
                    <?php

                    if ($result_categories > 0) {
                        while ($categories = mysqli_fetch_array($query_categories)) {
                    ?>
                            <option value="<?php echo $categories['id']; ?>"><?php echo $categories['name'] ?></option>
                    <?php
                        }
                    }
                    ?>

                </select>
                <!-- FIM  -->
                <label for="producto">Produto</label>
                <input type="text" name="producto" id="producto" placeholder="Nome do produto">
                <label for="precio">Preço</label>
                <input type="number" name="precio" id="precio" placeholder="Preço do produto">
                <label for="cantidad">Disconto</label>
                <input type="number" name="cantidad" id="cantidad" placeholder="Disconto de produto">
                <label for="cantidad">Detalhes</label>
                <input type="text" name="detail" id="detail" placeholder="Detailhe de produto">

                <div class="photo">
                    <label for="foto">Foto</label>
                    <div class="prevPhoto">
                        <span class="delPhoto notBlock">x</span>
                        <label for="foto"></label>
                    </div>
                    <div class="upimg">
                        <input type="file" name="foto" id="foto">
                    </div>
                    <div id="form_alert"></div>
                </div>
                <input type="submit" value="Salvar Produto" class="btn_save">
            </form>

    </section>

    <?php include "includes/footer.php"; ?>
</body>

</html>