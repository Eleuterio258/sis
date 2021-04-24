<?php
session_start();
if ($_SESSION['rol'] != 1 and $_SESSION['rol'] != 2) {
    header("location: ./");
}

include "../conn.php";

if (!empty($_POST)) {
    $alert = '';
    if (empty($_POST['name'])|| empty($_POST['icon'])) {
        $alert = '<p class="msg_error">Todos os campos são obrigatórios.</p>';
    } else {


        $name = $_POST['name'];
        $icon = $_POST['icon'];
        $usuario_id = ($_SESSION['idUser']);


        $query_insert = mysqli_query($conn, "INSERT INTO categories(name,icon,user_id)
                                                        VALUES('$name','$icon','$usuario_id')");

        if ($query_insert) {
            $alert = '<p class="msg_save">categoria salvas corretamente.</p>';
        } else {
            $alert = '<p class="msg_error">Erro ao salvar categoria.</p>';
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
    <title>Registro de Categoria</title>
</head>

<body>
    <?php include "includes/header.php"; ?>
    <section id="container">

        <div class="form_register">
            <h1><i class="fas fa-industry"></i> Registro de Categoria</h1>
            <hr>
            <div class="alert"><?php echo isset($alert) ? $alert : ''; ?></div>

            <form action="" method="post">
                <label for="name">Categoria</label>
                <input type="text" name="name" id="name" placeholder="Nome de Categoria">

                <div class="photo">
                    <label for="icon">Foto</label>
                    <div class="prevPhoto">
                        <span class="delPhoto notBlock">x</span>
                        <label for="icon"></label>
                    </div>
                    <div class="upimg">
                        <input type="file" name="icon" id="icon">
                    </div>
                    <div id="form_alert"></div>
                </div>
                <input type="submit" value="Salvar categoria" class="btn_save">

            </form>

    </section>

    <?php include "includes/footer.php"; ?>
</body>

</html>