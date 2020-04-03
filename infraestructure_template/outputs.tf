output "IP-PORTAL"{
    value = "${aws_instance.aik-portal.public_ip}"
}