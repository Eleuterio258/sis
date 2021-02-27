<?php
    $host = 'localhost';
    $user = 'root';
    $password = '';
    $db = 'facturacion';

   $conn= @mysqli_connect($host,$user,$password,$db);

    

    if(!$conn){
            echo "Conexão falhou";
    }
    ?>
    