provider "docker" {

}

resource "docker_container" "frontend"{
    #docker run -d -p 3030:3030 --name container_frontend imagen
    image = docker_image.img_frontend.latest
    name = "container_frontend"
    attach = false
    ports {
        internal = var.ports
        external = var.ports
    }
}

resource "docker_image" "img_frontend" {
    
    name = "aikfrontend:0.0.1"

}
