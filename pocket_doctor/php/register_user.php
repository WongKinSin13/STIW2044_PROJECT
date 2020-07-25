<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','1')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}

//http://slumberjer.com/grocery/php/register_user.php?name=Ahmad%20Hanis&email=slumberjer@gmail.com&phone=01949494959&password=123456

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Lab 3'; 
    $message = 'https://pdoc1.000webhostapp.com/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@mypdoc.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
