provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "weather_data" {
  bucket = "myweathertests3"
}

resource "aws_iam_role" "lambda_role" {
  name               = "weather-api-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_lambda_function" "current_weather" {
  function_name    = "getCurrentWeather"
  s3_bucket        = aws_s3_bucket.weather_data.id
  s3_key           = "lambda/getCurrentWeather.zip"
  runtime          = "nodejs20.x"
  handler          = "index.handler"

  environment {
    variables = {
      API_KEY      = var.api_key
      BUCKET_NAME  = aws_s3_bucket.weather_data.id
    }
  }
}

resource "aws_lambda_function" "historical_weather" {
  function_name    = "getHistoricalWeather"
  s3_bucket        = aws_s3_bucket.weather_data.id
  s3_key           = "lambda/getHistoricalWeather.zip"
  runtime          = "nodejs20.x"
  handler          = "index.handler"

  environment {
    variables = {
      API_KEY      = var.api_key
      BUCKET_NAME  = aws_s3_bucket.weather_data.id
    }
  }
}
