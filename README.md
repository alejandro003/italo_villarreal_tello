# Repositorio de Italo Villarreal

# 2.1 Aplicación Contenerizada
- 1 Cree del cluster EKS en AWS, de nombre le puse Demo en una cuenta donde hice una POC para el cliente CCL:

<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Imagen1.png">
</p>

- 2 Realice el pipeline en Azure Devops en un sandbox que manejamos, la ejecucion fue exitosa, para mayor autenticidad puse mi nombre complete tanto en el pipeline como en el repo de github:

<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Imagen2.jpg">
</p>

<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Imagen21.jpg">
</p>


- 3 Las pruebas finales fueron al ingresar por el balanceador de AWS para ver el mensaje de Hello World en NodeJS:

<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Imagen3.png">
</p>

# 2.2 Diseño de infraestructura

<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/arquitectura_delfosti.drawio.png">
</p>


# 2.3 Estimación de costos
https://calculator.aws/#/estimate?id=e2515379a7bbcb65329bf7dc837e80c46251b705 - TEST
<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Ambiente%20test.png">
</p>


https://calculator.aws/#/estimate?id=b302532e90acc852d10da2e5c9ce5fe14cf12759 - QA
<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Ambiente%20QA.png">
</p>


https://calculator.aws/#/estimate?id=9d8cd4345133276ea937c22fbdea6083745fcf32 - PRD
<p align="center">
    <img src="https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/Images/Ambiente%20prd.png">
</p>

# 2.4 Levantamiento de infraestructura

- El archivo de Terraform se llama [diagrama_iac.tf](https://github.com/alejandro003/italo_villarreal_tello/blob/italo-villarreal/diagrama_iac.tf)