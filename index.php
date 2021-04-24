<?php

$alert = '';
session_start();
if (!empty($_SESSION['active'])) {
  header('location: sistema/');
} else {
  if (!empty($_POST)) {
    if (empty($_POST['usuario']) || empty($_POST['clave'])) {
      $alert = 'Digite seu nome de usuário e senha';
    } else {

      require_once "conn.php";
      $user = mysqli_real_escape_string($conn, $_POST['usuario']);
      $pass = md5(mysqli_real_escape_string($conn, $_POST['clave']));

      $query = mysqli_query($conn, "SELECT u.idusuario,u.nombre,u.correo,u.usuario,r.idrol,r.rol 
                                                        FROM usuario u
                                                        INNER JOIN rol r
                                                        ON u.rol = r.idrol
                                                        WHERE u.usuario= '$user' AND clave= '$pass'");
      mysqli_close($conn);
      $result = mysqli_num_rows($query);

      if ($result > 0) {
        $data = mysqli_fetch_array($query);
        $_SESSION['active'] = true;
        $_SESSION['idUser'] = $data['idusuario'];
        $_SESSION['nombre'] = $data['nombre'];
        $_SESSION['email'] = $data['correo'];
        $_SESSION['user'] = $data['usuario'];
        $_SESSION['rol'] = $data['idrol'];
        $_SESSION['rol_name'] = $data['rol'];

        header('location: sistema/');
      } else {
        $alert = 'O nome de usuário ou senha está incorreto';
        session_destroy();
      }
    }
  }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="fonts/icomoon/style.css" />

  <link rel="stylesheet" href="css/owl.carousel.min.css" />

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="css/bootstrap.min.css" />

  <!-- Style -->
  <link rel="stylesheet" href="css/style.css" />

  <title>Login #6</title>
</head>

<body>
  <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img class="d-block w-100" src="images/04.jpg" height="20%" />
      </div>
      <div class="carousel-item">
        <img class="d-block w-100" src="images/02.png" height="20%" />
      </div>
      <div class="carousel-item">
        <img class="d-block w-100" src="images/04.jpg" height="20%" />
      </div>
    </div>
    <a class="carousel-control-prev" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
  <div class="d-lg-flex half">
    <div class="contents order-2 order-md-1">
      <div class="container">
        <div class="row align-items-center justify-content-center">
          <div class="col-md-7">
            <br /><br />
            <div class="linha">
              <p>SISTEMA DE GESTÃO DA VENDA E COMPRA DE RESÍDUOS SÓLIDOS</p>
            </div>

            <form action="#" method="post">
              <div class="form-group first">
                <label for="username">Username</label>
                <input type="text" class="form-control" name="usuario" />
              </div>
              <div class="form-group last mb-3">
                <label for="password">Password</label>
                <input type="password" class="form-control" name="clave" />
              </div>
              <div class="alert"><?php echo isset($alert)? $alert: '';  ?></div>
              <input type="submit" value="Log In" class="btn btn-block btn-primary" />
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="js/jquery-3.3.1.min.js"></script>
  <script src="js/popper.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
</body>

</html>