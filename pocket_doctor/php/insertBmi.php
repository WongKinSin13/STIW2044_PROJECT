<?php 
include "dbconnect.php";
// Add Bmi

    $email = $_POST['email'];
    $bmi = $_POST['bmi'];
    $height = $_POST['height'];
    $weight= $_POST['weight'];
  
        $query = "INSERT INTO BMI(EMAIL, BMI, HEIGHT, WEIGHT)
  			  VALUES('$email', '$bmi','$height','$weight')";
    $results = mysqli_query($connect, $query);
	if ($conn->query($query) === true)
    {
        echo "bmi added successfully";
    }
	else
	{
		echo "Insert failed";
	}