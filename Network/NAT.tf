resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.NAT_IP.id
  subnet_id     = aws_subnet.public-us-east-1a.id
  depends_on = [aws_internet_gateway.igw]
}

