terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=1.8.4"
}

provider "docker" {
  host     = "ssh://dio@158.160.156.245:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "random_password" "MYSQL_ROOT_PASSWORD" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "MYSQL_PASSWORD" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql"

  env = [ "MYSQL_ROOT_PASSWORD=${random_password.MYSQL_ROOT_PASSWORD.result}",
          "MYSQL_DATABASE=wordpress",
          "MYSQL_USER=wordpress",
          "MYSQL_PASSWORD=${random_password.MYSQL_PASSWORD.result}",
          "MYSQL_ROOT_HOST=\"%\""]

  ports {
    internal = 3306
    external = 3306
  }
}

