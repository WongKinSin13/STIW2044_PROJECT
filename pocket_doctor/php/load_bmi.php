<?php
error_reporting(0);
include_once ("dbconnect.php");


$sql = "SELECT * FROM BMI ORDER BY CALDATE DESC lIMIT 8";    

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["bmis"] = array();
    while ($row = $result->fetch_assoc())
    {
        $bmilist = array();
        $bmilist["email"] = $row["EMAIL"];
        $bmilist["bmi"] = $row["BMI"];
        $bmilist["height"] = $row["HEIGHT"];
        $bmilist["weight"] = $row["WEIGHT"];
		$bmilist["date"] = $row["CALDATE"];

        array_push($response["bmis"], $bmilist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
