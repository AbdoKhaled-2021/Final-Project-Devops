output "myvpc-id"{
    value = aws_vpc.myvpc.id
}

output "public-us-east-1a-id"{
    value = aws_subnet.public-us-east-1a.id
}

output "public-us-east-1b-id"{
    value = aws_subnet.public-us-east-1b.id
}

output "private-us-east-1a-id"{
    value = aws_subnet.private-us-east-1a.id
}

output "private-us-east-1b-id"{
    value = aws_subnet.private-us-east-1b.id
}