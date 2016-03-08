# HowTo stunnel CloudFormation

## Prerequis

- putty
- plink
- stunnel

## EC2 CloudFormation stunnel server conf

1. Se connecter à son compte AWS > CloudFormation
  1. "Create Stack"

2. "Upload a template  to Amazon S3" > stunnel_stack-0.0.2.json
  1. "Next"

3. "Stack Name"
  1. Choisir sa "AWS key pair"

4. Sélectionner le "VPC ID"
  1. Sélectionner le "Subnet ID"
  2. Choisir "Yes" pour l’"upload to s3 bucket"
  3. "Next"

5. "Next"

6. Cocher la case "I acknowledge..."
  1. "Create"

7. Passer sur l’onglet "Resources"
  1. Attendre...

8. Lorsque la Stack est au statut "CREATE_COMPLETE"
  1. Onglet "Outputs"

9. Noter le "StunnelPublicDnsName"
  1. Il sera utilisé pour la prochaine partie "Windows stunnel client conf" 

10. Cliquer sur le lien "BucketUrl"

11. Redirection sur S3
  1. Choisir le <prefix>-s3bucket (prefix = stunnel par défaut)

12. aws_ami_stunnel_....pem et aws_ami_stunnel_client_....pem sont présents
  1. Le bucket a une policy d’expiration à 1j
  2. Le bucket doit être vide pour pouvoir supprimer la stack depuis CloudFormation

13. Download de chaque .pem
  1. Le bucket a une policy d’expiration à 1j
  2. Le bucket doit être vide pour pouvoir supprimer la stack depuis CloudFormation



## Windows stunnel client conf


## Encapsulation de connexions au travers du tunnel SSH (TCP over SSH over SSL) avec Stunnel côté client


