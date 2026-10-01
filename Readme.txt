                   Internet
                     │
               Public IP / EC2
                     │
             ┌────────────────┐
             │  App Server     │
             │  EC2 + Tomcat   │
             └───────┬─────────┘
                     │
      ┌──────────────┼──────────────┐
      │              │              │
      ▼              ▼              ▼
 Amazon RDS      RabbitMQ EC2   ElastiCache
   MySQL           Ubuntu          Memcached