[
  {
      "name": "adminer",
      "image": "adminer",
      "cpu": 10,
      "memoryReservation": 300,
      "portMappings": [
        {
          "hostPort": 8432,
          "protocol": "tcp",
          "containerPort": 8080
        }
      ],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/psider-cms",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]