output "container_id" {
    value = docker_container.frontend.id
}

output "container_hostname" {
    value = docker_container.frontend.hostname
}