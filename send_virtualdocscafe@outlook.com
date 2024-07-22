<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Sanitize and validate input data
    $name = htmlspecialchars(strip_tags(trim($_POST["name"])));
    $email = filter_var($_POST["email"], FILTER_SANITIZE_EMAIL);
    $message = htmlspecialchars(strip_tags(trim($_POST["message"])));

    if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
        // Email details
        $to = "virtualdocscafe@outlook.com";  // Replace with your email address
        $subject = "New Contact Form Submission from $name";
        $body = "Name: $name\nEmail: $email\n\nMessage:\n$message";
        $headers = "From: $email";

        // Send email
        if (mail($to, $subject, $body, $headers)) {
            echo "Email successfully sent!";
        } else {
            echo "Failed to send email.";
        }
    } else {
        echo "Invalid email address.";
    }
} else {
    echo "Invalid request method.";
}
?>
