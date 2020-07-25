<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT * FROM BMI WHERE EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["bmihistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $bmihistorylist = array();
        $bmihistorylist["bmi"] = $row["BMI"];
        $bmihistorylist["height"] = $row["HEIGHT"];
        $bmihistorylist["weight"] = $row["WEIGHT"];
        $bmihistorylist["date"] = $row["CALDATE"];
        array_push($response["bmihistory"], $bmihistorylist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>

