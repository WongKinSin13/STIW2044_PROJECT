<?php

$servername = "localhost";
$dBUsername = "id12896100_pd1";
$dBPassword = "pocketDOC";
$dBName = "id12896100_pocketdoctor"; 

$conn = mysqli_connect($servername, $dBUsername, $dBPassword, $dBName);

if (!$conn) {
	 die("Connection failed: ".mysqli_connect_error());
}

