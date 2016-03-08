# HowTo stunnel CloudFormation

## Prerequis

- putty
- plink
- stunnel

## EC2 CloudFormation stunnel server conf

1. Se connecter à son compte AWS > CloudFormation
  1. "Create Stack"

![Alt text](img/EC2 CloudFormation stunnel server conf/1.jpg?raw=true)

2. "Upload a template  to Amazon S3" > stunnel_stack-0.0.2.json
  1. "Next"

![Alt text](img/EC2 CloudFormation stunnel server conf/2.jpg?raw=true)

3. "Stack Name"
  1. Choisir sa "AWS key pair"

![Alt text](img/EC2 CloudFormation stunnel server conf/3.jpg?raw=true)

4. Sélectionner le "VPC ID"
  1. Sélectionner le "Subnet ID"
  2. Choisir "Yes" pour l’"upload to s3 bucket"
  3. "Next"

![Alt text](img/EC2 CloudFormation stunnel server conf/4.jpg?raw=true)

5. "Next"

![Alt text](img/EC2 CloudFormation stunnel server conf/5.jpg?raw=true)

6. Cocher la case "I acknowledge..."
  1. "Create"

![Alt text](img/EC2 CloudFormation stunnel server conf/6.jpg?raw=true)

7. Passer sur l’onglet "Resources"
  1. Attendre...

![Alt text](img/EC2 CloudFormation stunnel server conf/7.jpg?raw=true)

8. Lorsque la Stack est au statut "CREATE_COMPLETE"
  1. Onglet "Outputs"

![Alt text](img/EC2 CloudFormation stunnel server conf/8.jpg?raw=true)

9. Noter le "StunnelPublicDnsName"
  1. Il sera utilisé pour la prochaine partie "Windows stunnel client conf" 

![Alt text](img/EC2 CloudFormation stunnel server conf/9.jpg?raw=true)

10. Cliquer sur le lien "BucketUrl"

![Alt text](img/EC2 CloudFormation stunnel server conf/10.jpg?raw=true)

11. Redirection sur S3
  1. Choisir le <prefix>-s3bucket (prefix = stunnel par défaut)

![Alt text](img/EC2 CloudFormation stunnel server conf/11.jpg?raw=true)

12. aws_ami_stunnel_....pem et aws_ami_stunnel_client_....pem sont présents
  1. Le bucket a une policy d’expiration à 1j
  2. Le bucket doit être vide pour pouvoir supprimer la stack depuis CloudFormation

![Alt text](img/EC2 CloudFormation stunnel server conf/12.jpg?raw=true)

13. Download de chaque .pem
  1. Le bucket a une policy d’expiration à 1j
  2. Le bucket doit être vide pour pouvoir supprimer la stack depuis CloudFormation

![Alt text](img/EC2 CloudFormation stunnel server conf/13.jpg?raw=true)


## Windows stunnel client conf

1. Lancer le batch "generate_stunnel_client_conf.bat"
  1. Renseigner les réponses aux questions
  2. Les chemins ne doivent pas avoir de "\" de fin
  3. Les chemins ne doivent contenir que des "\" en tant que séparateur d’arborescence
  4. Sélectionner les certificats (.pem) adéquats (server/client)

![Alt text](img/Windows stunnel client conf/1.jpg?raw=true)

2. Le fichier stunnel.conf est généré et consultable à l’emplacement renseigné dans le script
 
![Alt text](img/Windows stunnel client conf/2.jpg?raw=true)

3. Le fichier stunnel.conf est à copier dans le répertoire d’installation de stunnel
  1. Ecraser la configuration si nécessaire
 
![Alt text](img/Windows stunnel client conf/3.jpg?raw=true)

4. Dans stunnel
  1. Menu configuration > reload configuration
  2. Vérifier la mention de "Configuration successful"
 
![Alt text](img/Windows stunnel client conf/4.jpg?raw=true)

5. Lancer putty
  1. Préciser le host et port renseignés en tant que "bind host" et "bind port" du batch "generate_stunnel_client_conf.bat"
 
![Alt text](img/Windows stunnel client conf/5.jpg?raw=true)

6. Aller dans le menu Connection > SSH > Auth
  1. Renseigner le chemin vers le AWS key pair dans le champ "Private key file for authentication"
  2. "Open"
 
![Alt text](img/Windows stunnel client conf/6.jpg?raw=true)

7. "Yes"

![Alt text](img/Windows stunnel client conf/7.jpg?raw=true)

8. Utiliser le user ec-2user
  1. Le tunnel est accessible !

![Alt text](img/Windows stunnel client conf/8.jpg?raw=true)

## Encapsulation de connexions au travers du tunnel SSH (TCP over SSH over SSL) avec Stunnel côté client


