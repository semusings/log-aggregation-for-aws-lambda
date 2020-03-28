# Log aggregation for AWS Lambda

Demo of how to ship logs from CloudWatch Logs to a Kinesis stream, and then ship them to ELK (from Logz.io).

## Deployment
1. insert the `logstash_host`, `logstash_port` and `token` in the `serverless.yml` file
2. run `./build.sh deploy test` to deploy to a stage called "test"
