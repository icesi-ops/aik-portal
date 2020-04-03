# Feature Diseño maquinas virtuales #

## Story # 16 
Link: https://trello.com/c/1L3rs7ei/17-story-16-dise%C3%B1o-de-las-m%C3%A1quinas-para-el-front-y-back

### Manuel Alejandro Coral Lozano - A00301480
### John Sebastian Urbano Lenis - A00292788
### Andres Felipe Aguirre Aguilar - A00329792

Para el desarrollo de pruebas locales, nuestro equipo propuso Vagrant y Ansible con el fin de validar el desempeño del portal aik con máquinas virtuales teniendo como proveedor VirtualBox

A continuación se muestra el diagrama que se implemento, teniendo en cuenta solo las maquinas virtuales.  

![imagen1](https://raw.githubusercontent.com/andres1397/aik-portal/master/infraestructura/images/Dise%C3%B1oInfraestructuraStory%2316.png)

Para el aprovisionamiento se obto por usar Ansible y el diseño es el siguiente.  

![imagen2](https://raw.githubusercontent.com/andres1397/aik-portal/Feature-FrontBackInfraIntegr-DespliegueInfraestructura/infraestructura/images/Dise%C3%B1oInfraestructurayAprovisionamientoStory%2317.png)


Para el despliegue es necesario realizar un  
vagrant up  
Esto haría que se creen dos máquinas virtuales sencillas, las cuales seran aprovisionadas con git, nodejs, el codigo del repositorio aik-portal y se ejecutaran el codigo fuente de manera distribuida