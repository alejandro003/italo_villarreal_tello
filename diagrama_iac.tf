provider "aws" {
  region = "us-east-1"
}

# Crear una nueva VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Crear un Internet Gateway y asociarlo a la VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Crear una ruta hacia el Internet Gateway
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Crear subredes públicas en diferentes AZs
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Crear un grupo de seguridad para las instancias EC2
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Security group for backend EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Permitir tráfico HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear un bucket S3 para la aplicación Angular
resource "aws_s3_bucket" "angular_app_bucket" {
  bucket = "angular-app-bucket-prod"
  acl    = "public-read"

  # Configurar el bucket para servir un sitio web estático
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Configurar CloudFront para servir el contenido desde S3
resource "aws_cloudfront_distribution" "cdn_distribution" {
  origin {
    domain_name = aws_s3_bucket.angular_app_bucket.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.angular_app_bucket.bucket}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${aws_s3_bucket.angular_app_bucket.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Configurar las restricciones de precio y tamaño
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Configurar los registros DNS en Route 53 para el dominio
  aliases {
    domain       = "italo.com"
    enabled      = true
    comment      = "Route 53 alias para CloudFront distribution"
    evaluate_target_health = true
  }
}

# Configurar una instancia EC2 para el backend PHP
resource "aws_instance" "backend_instance" {
  ami           = "ami-06c68f701d8090592"
  instance_type = "c6g.2xlarge"
  key_name      = "llave1"
  subnet_id     = aws_subnet.public_subnet_a.id

  # Configuración del grupo de seguridad para EC2
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "Backend EC2 Instance"
  }
}

# Configurar una instancia de base de datos RDS Aurora PostgreSQL
resource "aws_db_instance" "aurora_db" {
  engine            = "aurora-postgresql"
  instance_class    = "db.r4.4xlarge"
  allocated_storage = 1000
  backup_retention_period = 7

  # Configuración de la VPC y subredes
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  subnet_group_name      = "default" 

  tags = {
    Name = "Aurora PostgreSQL DB"
  }
}

# Configurar Amazon ElastiCache para caching de consultas frecuentes
resource "aws_elasticache_cluster" "cache_cluster" {
  cluster_id           = "my-cache-cluster"
  engine               = "redis"
  node_type            = "cache.r6gd.12xlarge"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"

  # Configuración del grupo de seguridad
  security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "ElastiCache Cluster"
  }
}

# Configurar registros DNS en Route 53 para el dominio
resource "aws_route53_record" "example_com" {
  zone_id = "ZXXXXXXXXXXXXXX"  # ID de la zona Route 53
  name    = "ejemplo.com"
  type    = "A"
  ttl     = "300"
  records = [aws_cloudfront_distribution.cdn_distribution.domain_name]
}
