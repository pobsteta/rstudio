# pobsteta/rstudio #


## Quickstart

Démarrez un container RStudio en lançant la commande dans un terminal :

```bash
sudo docker run -d -p 8787:8787 pobsteta/rstudio
```
Utilisez la commande 'docker-machine ip' pour déterminer l'adresse IP de votre machine, puis rendez-vous à l'adresse IP
renvoyée en ajoutant le port ':8787'. Vous pouvez alors vous connecter sur le serveur RStudio avec l'identifant et le
mot de passe suivant :

- username: rstudio 
- password: rstudio


## Trademarks ##

RStudio is a registered trademark of RStudio, Inc.  The use of the trademarked term RStudio and the distribution of the RStudio binaries through the images hosted on [hub.docker.com](https://registry.hub.docker.com/) has been granted by explicit permission of RStudio.  Please review [RStudio's trademark use policy](http://www.rstudio.com/about/trademark/) and address inquiries about further distribution or other questions to [permissions@rstudio.com](emailto:permissions@rstudio.com).
