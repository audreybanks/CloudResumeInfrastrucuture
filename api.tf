resource "aws_apigatewayv2_api" "visitors-api" {
  name          = "visitors-api"
  protocol_type = "HTTP"
}

// Does not work, make lambda then switch to lambda integration
resource "aws_apigatewayv2_integration" "visitors-intergration" {
  api_id             = aws_apigatewayv2_api.visitors-api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "https://example.com/{proxy+}"
}

resource "aws_apigatewayv2_route" "visitors-get-route" {
  api_id    = aws_apigatewayv2_api.visitors-api.id
  route_key = "GET /visitors"
  target    = "integrations/${aws_apigatewayv2_integration.visitors-intergration.id}"
}