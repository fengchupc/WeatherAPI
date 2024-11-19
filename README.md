# AWS API for Weather Data

## 1. Create an S3 Bucket
1. Navigate to the **S3 Console**.
2. Click **Create bucket**.
   - Name the bucket (e.g., `myweathertests3`).
   - Select a region (e.g., `ap-southeast-2`).
   - Enable versioning (optional, but recommended).
3. Click **Create bucket**.

---

## 2. Create IAM Role for Lambda
1. Navigate to the **IAM Console**.
2. Click **Roles** > **Create role**.
   - Choose **AWS service** > **Lambda**.
   - Attach the following policies:
     - `AWSLambdaBasicExecutionRole`
     - A custom policy granting S3 permissions:
       ```json
       {
         "Version": "2012-10-17",
         "Statement": [
           {
             "Effect": "Allow",
             "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:ListBucket"
             ],
             "Resource": [
               "arn:aws:s3:::my-weather-data-bucket",
               "arn:aws:s3:::my-weather-data-bucket/*"
             ]
           }
         ]
       }
       ```
3. Name the role (e.g., `LambdaWeatherRole`) and save.

---

## 3. Create Lambda Functions
1. Navigate to the **Lambda Console**.
2. Click **Create function** > **Author from scratch**.
   - Name: `getCurrentWeather`
   - Runtime: `Node.js 20.x`
   - Role: Use the role created earlier (`LambdaWeatherRole`).
3. Upload the code:
   - Package the `getCurrentWeather.js`, `getHistoricalWeather.js`, and `index.mjs` into a ZIP file along with a `package.json` file.
   - Use the AWS Lambda editor to specify `index.mjs` as the handler.
   - Example handler: `index.handler`.


---

## 4. Create API Gateway
1. Navigate to the **API Gateway Console**.
2. Click **Create API** > **HTTP API**.
3. Configure routes:
   - **Route 1**: `GET /weather/{city}`
     - Integration: Link to the `getCurrentWeather` Lambda function.
   - **Route 2**: `GET /weather/history/{city}`
     - Integration: Link to the `getHistoricalWeather` Lambda function.
4. Deploy the API and note the **API endpoint**.

---

## 5. Configure Environment Variables
1. In the **Lambda Console**, for each function:
   - Go to the **Configuration** tab > **Environment variables**.
   - Add:
     - `API_KEY`: The OpenWeatherMap API key.
     - `BUCKET_NAME`: The name of the S3 bucket.

---

## Testing the API

### Example for Current Weather
```bash
curl https://<api-id>.execute-api.<region>.amazonaws.com/weather/Melbourne

curl https://<api-id>.execute-api.<region>.amazonaws.com/weather/history/Melbourne
```
